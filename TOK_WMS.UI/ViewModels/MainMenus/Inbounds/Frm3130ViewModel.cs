using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using System.Windows.Threading;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

public partial class Frm3130ViewModel : DocumentViewModelBase
{
    private readonly IDialogService _dialog;
    private readonly IFrm3130Api _frm3130Api;
    // 로그인 사용자 서비스 있으면 추가
    private readonly ICurrentUserService _currentUser;

    private readonly DispatcherTimer _searchTimer;
    private readonly DispatcherTimer _resumeTimer;
    private readonly SemaphoreSlim _scanGate = new(1, 1);
    private int _scanSessionVersion;
    private int _searchVersion;
    private bool _isDisposed;

    public event Action? PltFocusRequested;
    public event Action? BarcodeFocusRequested;


    // =========================================================
    // Scanner
    // =========================================================

    [ObservableProperty] private string _pltnoEdit = string.Empty;
    [ObservableProperty] private string _itemBcrEdit = string.Empty;


    // =========================================================
    // 상세정보
    // =========================================================

    [ObservableProperty] private string _codeEdit = string.Empty;
    [ObservableProperty] private string _nameEdit = string.Empty;
    [ObservableProperty] private string _lotnoEdit = string.Empty;
    [ObservableProperty] private string _qtyEdit = string.Empty;
    [ObservableProperty] private string _boxNoEdit = string.Empty;
    [ObservableProperty] private string _bigoEdit = string.Empty;


    // =========================================================
    // 상태
    // =========================================================

    [ObservableProperty] private string _statusMessage = string.Empty;

    [ObservableProperty] private bool _isStopped;


    // =========================================================
    // DataGrid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm3130Dto.ResDto> _items = [];

    [ObservableProperty]
    private Frm3130Dto.ResDto? _selectedItem;


    // =========================================================
    // 생성자
    // =========================================================

    public Frm3130ViewModel(
        IFrm3130Api frm3130Api,
        IDialogService dialog,
        ICurrentUserService currentUser)
    {
        _frm3130Api = frm3130Api;
        _dialog = dialog;
        _currentUser = currentUser;

        Title = "핸드스캔 입고 등록";
        ContentId = DocumentKeys.Frm3130;


        // =====================================================
        // Delphi Timer1 대체
        // 주기적 자동조회
        // =====================================================

        _searchTimer = new DispatcherTimer
        {
            Interval = TimeSpan.FromSeconds(5)
        };

        _searchTimer.Tick += async (_, _) =>
        {
            if (!IsStopped && !_isDisposed)
            {
                await Search();
            }
        };


        // =====================================================
        // Delphi Timer2 대체
        // DataGrid 클릭 후 5초 뒤 자동조회 복귀
        // =====================================================

        _resumeTimer = new DispatcherTimer
        {
            Interval = TimeSpan.FromSeconds(5)
        };

        _resumeTimer.Tick += async (_, _) =>
        {
            _resumeTimer.Stop();

            if (_isDisposed)
                return;

            IsStopped = false;

            _searchTimer.Start();

            await Search();
        };


        _searchTimer.Start();
    }


    // =========================================================
    // 조회
    // Delphi StartBitBtnClick
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        var pltNo = PltnoEdit.Trim();
        var sessionVersion = _scanSessionVersion;
        var searchVersion = ++_searchVersion;

        if (_isDisposed)
            return;

        try
        {
            if (string.IsNullOrWhiteSpace(pltNo))
            {
                Items.Clear();
                return;
            }


            var result =
                await _frm3130Api.SearchAsync(
                    new Frm3130Dto.ReqDto
                    {
                        SubkPltno = pltNo
                    });

            if (!IsCurrentScan(sessionVersion) || searchVersion != _searchVersion)
                return;

            Items.Clear();

            foreach (var h in result ?? [])
            {
                Items.Add(h);
            }


            StatusMessage =
                $"조회 {Items.Count:N0}건";
        }
        catch (Exception ex)
        {
            if (!IsCurrentScan(sessionVersion) || searchVersion != _searchVersion)
                return;

            StatusMessage =
                $"조회 실패: {ex.Message}";
        }
    }


    // =========================================================
    // PLT-NO Enter
    // Delphi BcrData1MedKeyPress
    // =========================================================

    [RelayCommand(AllowConcurrentExecutions = true)]
    private async Task PltEnter()
    {
        var pltNo = PltnoEdit.Trim();
        PltnoEdit = pltNo;
        ResetProductDetails();
        var sessionVersion = _scanSessionVersion;

        await _scanGate.WaitAsync();
        try
        {
            if (!IsCurrentScan(sessionVersion))
                return;

            if (string.IsNullOrWhiteSpace(pltNo))
            {
                PltFocusRequested?.Invoke();
                return;
            }


            var check =
                await _frm3130Api.PltCheckAsync(
                    pltNo);

            if (!IsCurrentScan(sessionVersion))
                return;

            if (check == null)
            {
                _dialog.ShowWarning(
                    "파렛트 상태를 확인할 수 없습니다.",
                    "오류");

                PltFocusRequested?.Invoke();
                return;
            }


            // 이미 위치가 지정된 재고
            if (check.LocatedSubkCount > 0)
            {
                _dialog.ShowWarning(
                    $"{pltNo}\n" +
                    "해당 파레트 번호는 이미 창고에 있는 번호입니다.\n" +
                    "확인 후 다시 입력하세요!",
                    "오류");


                PltnoEdit =
                    string.Empty;

                PltFocusRequested?.Invoke();

                return;
            }


            StatusMessage =
                $"PLT-NO [{pltNo}] 입력 완료";

            BarcodeFocusRequested?.Invoke();

            await Search();
        }
        catch (Exception ex)
        {
            if (!IsCurrentScan(sessionVersion))
                return;

            _dialog.ShowWarning(
                $"PLT-NO 확인 실패: {ex.Message}",
                "오류");
            PltFocusRequested?.Invoke();
        }
        finally
        {
            _scanGate.Release();
        }
    }


    // =========================================================
    // 제품 바코드 Enter
    // Delphi BcrData2MedKeyPress
    // =========================================================

    [RelayCommand(AllowConcurrentExecutions = true)]
    private async Task BarcodeEnter()
    {
        var barcode = ItemBcrEdit.Trim();
        if (string.IsNullOrWhiteSpace(barcode))
            return;

        var sessionVersion = _scanSessionVersion;
        var focusPallet = false;
        // 다음 스캔을 즉시 받을 수 있도록 입력을 먼저 비우고 순서대로 처리한다.
        ItemBcrEdit = string.Empty;

        await _scanGate.WaitAsync();
        try
        {
            if (!IsCurrentScan(sessionVersion))
                return;


            // =================================================
            // END
            // =================================================

            if (barcode.Equals(
                "END",
                StringComparison.OrdinalIgnoreCase))
            {
                ResetScanSession();
                return;
            }


            // =================================================
            // CANCEL
            // =================================================

            if (barcode.Equals(
                "CANCEL",
                StringComparison.OrdinalIgnoreCase))
            {
                await DeleteAllCore(sessionVersion);
                return;
            }


            var pltNo =
                PltnoEdit?.Trim()
                ?? string.Empty;


            if (string.IsNullOrWhiteSpace(pltNo))
            {
                focusPallet = true;
                _dialog.ShowWarning(
                    "파레트 번호(PLT-NO)가 없습니다.",
                    "오류");

                return;
            }


            // =================================================
            // 트래킹 / 재고 체크
            // =================================================

            var check =
                await _frm3130Api.PltCheckAsync(
                    pltNo);

            if (!IsCurrentScan(sessionVersion))
                return;

            if (check == null)
            {
                focusPallet = true;
                _dialog.ShowWarning(
                    "파렛트 상태를 확인할 수 없습니다.",
                    "오류");

                return;
            }


            if (check.TrackingCount > 0)
            {
                focusPallet = true;
                _dialog.ShowWarning(
                    "현재 트래킹(이동) 구간에 위치한 파레트입니다.\n" +
                    "추가 작업을 진행할 수 없습니다.",
                    "오류");

                return;
            }


            if (check.LstkCount > 0)
            {
                focusPallet = true;
                _dialog.ShowWarning(
                    "이미 재고로 확정 등록된 파레트입니다.\n" +
                    "추가 작업을 진행할 수 없습니다.",
                    "오류");

                return;
            }


            ClearDetail();


            // =================================================
            // EMPTY
            // =================================================

            if (barcode.Equals(
                "EMPTY",
                StringComparison.OrdinalIgnoreCase))
            {
                await EmptyInsert();

                return;
            }


            // =================================================
            // Barcode Parsing
            //
            // 3개
            // CODE | NAME | QTY
            //
            // 6개 이상
            // CODE | NAME | LOT | QTY | BOX | REMARK
            // =================================================

            var split =
                barcode
                    .Split('|')
                    .Select(x => x.Trim())
                    .ToArray();


            if (split.Length == 3)
            {
                CodeEdit =
                    split[0];

                NameEdit =
                    split[1];

                QtyEdit =
                    split[2];

                LotnoEdit =
                    string.Empty;

                BoxNoEdit =
                    string.Empty;

                BigoEdit =
                    string.Empty;
            }
            else if (split.Length >= 6)
            {
                CodeEdit =
                    split[0];

                NameEdit =
                    split[1];

                LotnoEdit =
                    split[2];

                QtyEdit =
                    split[3];

                BoxNoEdit =
                    split[4];

                BigoEdit =
                    split[5];
            }
            else
            {
                _dialog.ShowWarning(
                    $"{barcode}\n\n" +
                    "스캔 바코드 형식 오류입니다!\n\n" +
                    "[출하처] 코드|명|수량\n" +
                    "[표준] 코드|명|LOT|수량|BOX|비고",
                    "오류");


                return;
            }


            // =================================================
            // 중량 변환
            // =================================================

            var qtyText =
                QtyEdit
                    .Replace(",", "")
                    .Trim();


            if (!decimal.TryParse(
                qtyText,
                out var qty))
            {
                _dialog.ShowWarning(
                    "중량 값이 올바르지 않습니다.",
                    "오류");

                return;
            }


            if (qty <= 0)
            {
                _dialog.ShowWarning(
                    "중량은 0보다 커야 합니다.",
                    "오류");

                return;
            }


            // =================================================
            // INSERT
            // =================================================

            var result =
                await _frm3130Api.InsertAsync(
                    new Frm3130Dto.InsertReqDto
                    {
                        SubkPltno =
                            pltNo,

                        SubkCode =
                            CodeEdit.Trim(),

                        SubkLotno =
                            LotnoEdit.Trim(),

                        SubkWgt =
                            qty,

                        SubkBoxno =
                            BoxNoEdit.Trim(),

                        SubkRemark =
                            BigoEdit.Trim(),

                        // 실제 로그인 서비스 연결
                        UserId =
                            _currentUser?.User?.UserId ?? string.Empty
                    });

            if (!IsCurrentScan(sessionVersion))
                return;

            if (result == null ||
                !result.Success)
            {
                _dialog.ShowWarning(
                    result?.Message
                    ?? "등록 실패",
                    "오류");

                return;
            }


            await Search();
        }
        catch (Exception ex)
        {
            if (!IsCurrentScan(sessionVersion))
                return;

            _dialog.ShowWarning(
                $"바코드 처리 실패: {ex.Message}",
                "오류");
        }
        finally
        {
            _scanGate.Release();
            if (IsCurrentScan(sessionVersion))
            {
                if (focusPallet || string.IsNullOrWhiteSpace(PltnoEdit))
                    PltFocusRequested?.Invoke();
                else
                    BarcodeFocusRequested?.Invoke();
            }
        }
    }


    // =========================================================
    // EMPTY 등록
    // =========================================================

    private async Task EmptyInsert()
    {
        var sessionVersion = _scanSessionVersion;
        try
        {
            var pltNo =
                PltnoEdit?.Trim()
                ?? string.Empty;


            if (string.IsNullOrWhiteSpace(pltNo))
            {
                _dialog.ShowWarning(
                    "PLT-NO가 없습니다.",
                    "오류");

                return;
            }


            var result =
                await _frm3130Api.EmptyInsertAsync(
                    pltNo,

                    // 실제 로그인 사용자 ID 연결
                    string.Empty);

            if (!IsCurrentScan(sessionVersion))
                return;

            if (result == null ||
                !result.Success)
            {
                _dialog.ShowWarning(
                    result?.Message
                    ?? "EMPTY 등록 실패",
                    "오류");

                return;
            }


            CodeEdit =
                "EMPTY";

            NameEdit =
                result.MastName
                ?? "공파렛트";

            LotnoEdit =
                string.Empty;

            QtyEdit =
                result.Qty.ToString("0.00");

            BoxNoEdit =
                string.Empty;

            BigoEdit =
                string.Empty;

            await Search();
        }
        catch (Exception ex)
        {
            if (!IsCurrentScan(sessionVersion))
                return;

            _dialog.ShowWarning(
                $"EMPTY 등록 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // DataGrid 행 선택
    // Delphi DBGrid1CellClick
    // =========================================================

    [RelayCommand]
    private void ItemSelect(
        Frm3130Dto.ResDto item)
    {
        if (item == null)
        {
            return;
        }


        CodeEdit =
            item.SubkCode
            ?? string.Empty;

        NameEdit =
            item.MastName
            ?? string.Empty;

        LotnoEdit =
            item.SubkLotno
            ?? string.Empty;

        QtyEdit =
            item.SubkWgt?
                .ToString("0.00")
            ?? string.Empty;

        BoxNoEdit =
            item.SubkBoxno
            ?? string.Empty;

        BigoEdit =
            item.SubkRemark
            ?? string.Empty;


        // =====================================================
        // 자동조회 일시 정지
        // =====================================================

        IsStopped =
            true;

        _searchTimer.Stop();


        // 기존 5초 복귀 타이머 다시 시작
        _resumeTimer.Stop();
        _resumeTimer.Start();
    }


    // =========================================================
    // 선택행 삭제
    // Delphi DeleteBitBtnClick
    // =========================================================

    [RelayCommand]
    private async Task Delete(
        Frm3130Dto.ResDto item)
    {
        var sessionVersion = _scanSessionVersion;
        await _scanGate.WaitAsync();
        try
        {
            if (IsCurrentScan(sessionVersion))
                await DeleteCore(item, sessionVersion);
        }
        finally
        {
            _scanGate.Release();
        }
    }

    private async Task DeleteCore(Frm3130Dto.ResDto item, int sessionVersion)
    {
        var pausedForDelete = false;
        try
        {
            if (item == null)
            {
                _dialog.ShowWarning(
                    "삭제할 행을 먼저 선택해주세요.",
                    "오류");

                return;
            }


            // 삭제 처리 중 자동조회 멈춤
            IsStopped = true;
            pausedForDelete = true;

            _searchTimer.Stop();
            _resumeTimer.Stop();


            var pltNo =
                item.SubkPltno?.Trim()
                ?? string.Empty;


            var check =
                await _frm3130Api.PltCheckAsync(
                    pltNo);

            if (!IsCurrentScan(sessionVersion))
                return;

            if (!CanDelete(
                check,
                out var message))
            {
                _dialog.ShowWarning(
                    message,
                    "오류");

                ResumeAutoSearch();

                return;
            }


            if (!_dialog.ShowConfirm(
                $"파레트 번호 : [{pltNo}]\n" +
                $"품 목 코 드 : [{item.SubkCode}]\n\n" +
                $"해당 데이터를 삭제하시겠습니까?",
                "확인"))
            {
                ResumeAutoSearch();

                return;
            }


            var count =
                await _frm3130Api.DeleteAsync(
                    new Frm3130Dto.DeleteReqDto
                    {
                        SubkPltno =
                            pltNo,

                        SubkCode =
                            item.SubkCode,

                        SubkLotno =
                            item.SubkLotno
                    });

            if (!IsCurrentScan(sessionVersion))
                return;

            if (count <= 0)
            {
                _dialog.ShowWarning(
                    "삭제된 데이터가 없습니다.",
                    "오류");

                ResumeAutoSearch();

                return;
            }


            ClearDetail();

            await Search();

            ResumeAutoSearch();
        }
        catch (Exception ex)
        {
            if (!IsCurrentScan(sessionVersion))
                return;

            ResumeAutoSearch();

            _dialog.ShowWarning(
                $"삭제 실패: {ex.Message}",
                "오류");
        }
        finally
        {
            if (pausedForDelete)
                ResumeAutoSearch();
        }
    }


    // =========================================================
    // PLT 전체 삭제
    // Delphi AllDeleteBitBtnClick / CANCEL
    // =========================================================

    [RelayCommand]
    private async Task DeleteAll()
    {
        var sessionVersion = _scanSessionVersion;
        await _scanGate.WaitAsync();
        try
        {
            if (IsCurrentScan(sessionVersion))
                await DeleteAllCore(sessionVersion);
        }
        finally
        {
            _scanGate.Release();
        }
    }

    private async Task DeleteAllCore(int sessionVersion)
    {
        var pausedForDelete = false;
        try
        {
            var pltNo =
                PltnoEdit?.Trim()
                ?? string.Empty;


            if (string.IsNullOrWhiteSpace(pltNo))
            {
                _dialog.ShowWarning(
                    "삭제할 파레트 번호가 입력되지 않았습니다.",
                    "오류");

                return;
            }


            IsStopped = true;
            pausedForDelete = true;

            _searchTimer.Stop();
            _resumeTimer.Stop();


            var check =
                await _frm3130Api.PltCheckAsync(
                    pltNo);

            if (!IsCurrentScan(sessionVersion))
                return;

            if (!CanDelete(
                check,
                out var message))
            {
                _dialog.ShowWarning(
                    message,
                    "오류");

                ResumeAutoSearch();

                return;
            }


            if (!_dialog.ShowConfirm(
                $"파레트 번호 [{pltNo}]의\n" +
                $"모든 데이터를 삭제하시겠습니까?",
                "확인"))
            {
                ResumeAutoSearch();

                return;
            }


            var count =
                await _frm3130Api.DeleteAllAsync(
                    pltNo);

            if (!IsCurrentScan(sessionVersion))
                return;

            if (count <= 0)
            {
                _dialog.ShowWarning(
                    "삭제된 데이터가 없습니다.",
                    "오류");

                ResumeAutoSearch();

                return;
            }


            ResetScanSession();

            ResumeAutoSearch();
        }
        catch (Exception ex)
        {
            if (!IsCurrentScan(sessionVersion))
                return;

            ResumeAutoSearch();

            _dialog.ShowWarning(
                $"전체삭제 실패: {ex.Message}",
                "오류");
        }
        finally
        {
            if (pausedForDelete)
                ResumeAutoSearch();
        }
    }


    // =========================================================
    // 삭제 가능 상태 확인
    // =========================================================

    private bool CanDelete(
        Frm3130Dto.PltCheckDto? check,
        out string message)
    {
        message =
            string.Empty;


        if (check == null)
        {
            message =
                "파렛트 상태를 확인할 수 없습니다.";

            return false;
        }


        if (check.TrackingCount > 0)
        {
            message =
                "현재 트래킹 구간에 위치한 파레트입니다.\n" +
                "삭제할 수 없습니다.";

            return false;
        }


        if (check.LstkCount > 0)
        {
            message =
                "이미 재고 등록된 파레트입니다.\n" +
                "삭제할 수 없습니다.";

            return false;
        }


        if (!string.IsNullOrWhiteSpace(
            check.BlockFlag))
        {
            message =
                check.BlockFlag switch
                {
                    "X" =>
                        "현재 [입고 대기] 상태입니다.\n" +
                        "삭제할 수 없습니다.",

                    "1" =>
                        "이미 [재고 등록]이 완료된 상태입니다.\n" +
                        "삭제할 수 없습니다.",

                    "Y" =>
                        "현재 [출고 예약] 상태인 파레트입니다.\n" +
                        "삭제할 수 없습니다.",

                    "M" =>
                        "현재 [작업 이동 중]인 파레트입니다.\n" +
                        "삭제할 수 없습니다.",

                    _ =>
                        "현재 삭제할 수 없는 상태입니다."
                };


            return false;
        }


        return true;
    }


    // =========================================================
    // 자동조회 멈춤 CheckBox
    // =========================================================

    partial void OnIsStoppedChanged(
        bool value)
    {
        if (_isDisposed)
        {
            _searchTimer.Stop();
            _resumeTimer.Stop();
            return;
        }

        if (value)
        {
            _searchTimer.Stop();
        }
        else
        {
            _resumeTimer.Stop();
            _searchTimer.Start();
        }
    }


    // =========================================================
    // 자동조회 복귀
    // =========================================================

    private void ResumeAutoSearch()
    {
        if (_isDisposed)
            return;

        _resumeTimer.Stop();

        IsStopped =
            false;

        _searchTimer.Start();
    }


    // =========================================================
    // 완료
    // =========================================================

    [RelayCommand]
    private async Task Complete()
    {
        await End();
    }


    // =========================================================
    // END
    // Delphi EndBitBtnClick
    // =========================================================

    [RelayCommand(AllowConcurrentExecutions = true)]
    private async Task End()
    {
        var sessionVersion = _scanSessionVersion;
        await _scanGate.WaitAsync();
        try
        {
            if (IsCurrentScan(sessionVersion))
                ResetScanSession();
        }
        finally
        {
            _scanGate.Release();
        }
    }

    private void ResetScanSession()
    {
        ItemBcrEdit =
            string.Empty;

        PltnoEdit =
            string.Empty;


        ResetProductDetails();


        StatusMessage =
            string.Empty;

        PltFocusRequested?.Invoke();
    }

    partial void OnPltnoEditChanged(string value)
    {
        ResetProductDetails();
    }

    private void ResetProductDetails()
    {
        ++_scanSessionVersion;
        ItemBcrEdit = string.Empty;
        SelectedItem = null;
        Items.Clear();
        ClearDetail();
    }

    private bool IsCurrentScan(int sessionVersion) =>
        !_isDisposed && sessionVersion == _scanSessionVersion;

    public override void Dispose()
    {
        _isDisposed = true;
        ++_scanSessionVersion;
        _searchTimer.Stop();
        _resumeTimer.Stop();
        base.Dispose();
    }


    // =========================================================
    // 상세정보 초기화
    // =========================================================

    private void ClearDetail()
    {
        CodeEdit =
            string.Empty;

        NameEdit =
            string.Empty;

        LotnoEdit =
            string.Empty;

        QtyEdit =
            string.Empty;

        BoxNoEdit =
            string.Empty;

        BigoEdit =
            string.Empty;
    }
}
