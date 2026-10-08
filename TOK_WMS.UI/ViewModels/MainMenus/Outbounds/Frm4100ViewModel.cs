using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Outbounds;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Outbounds;

public partial class Frm4100ViewModel
    : DocumentViewModelBase
{
    private readonly IFrm4100Api _frm4100Api;
    private readonly IDialogService _dialog;
    private readonly ICurrentUserService _currentUser;


    // =========================================================
    // 검색
    // =========================================================

    [ObservableProperty] private string _itemCodeSrc = string.Empty;
    [ObservableProperty] private string _itemNameSrc = string.Empty;
    [ObservableProperty] private string _lotNoSrc = string.Empty;

    [ObservableProperty] private bool _isEmergency;


    // =========================================================
    // Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm4100Dto.StockDto> _items = [];


    [ObservableProperty]
    private ObservableCollection<Frm4100Dto.PalletItemDto> _palletItems = [];


    [ObservableProperty]
    private ObservableCollection<Frm4100Dto.WorkDto> _workItems = [];


    [ObservableProperty]
    private Frm4100Dto.StockDto? _selectedItem;


    [ObservableProperty]
    private Frm4100Dto.PalletItemDto? _selectedPalletItem;


    [ObservableProperty]
    private Frm4100Dto.WorkDto? _selectedWorkItem;


    // =========================================================
    // 출고 편집
    // =========================================================

    [ObservableProperty] private string _locaEdit = string.Empty;
    [ObservableProperty] private string _pltnoEdit = string.Empty;

    [ObservableProperty] private string _itemCodeEdit = string.Empty;
    [ObservableProperty] private string _itemNameEdit = string.Empty;

    [ObservableProperty] private string _lotnoEdit = string.Empty;

    [ObservableProperty] private string _boxNoEdit = string.Empty;
    [ObservableProperty] private string _remarkEdit = string.Empty;

    [ObservableProperty] private string _customerEdit = string.Empty;

    [ObservableProperty] private string _outBoxNoEdit = string.Empty;
    [ObservableProperty] private string _outRemarkEdit = string.Empty;

    [ObservableProperty] private string _inDateEdit = string.Empty;
    [ObservableProperty] private string _inTimeEdit = string.Empty;


    [ObservableProperty] private string _realStockQty = string.Empty;

    [ObservableProperty] private string _availableQty = string.Empty;

    [ObservableProperty] private string _requestQty = string.Empty;


    // =========================================================
    // Station
    // =========================================================

    [ObservableProperty]
    private Frm4100Dto.StationStatusDto? _stationStatus;


    [ObservableProperty]
    private string _selectedWsno = string.Empty;


    [ObservableProperty]
    private bool _isEditPanelVisible;


    [ObservableProperty]
    private string _statusMessage = string.Empty;


    public Frm4100ViewModel(
        IFrm4100Api frm4100Api,
        IDialogService dialog,
        ICurrentUserService currentUser)
    {
        _frm4100Api =
            frm4100Api;

        _dialog =
            dialog;

        _currentUser =
            currentUser;


        Title =
            "재고 출고 등록";

        ContentId =
            DocumentKeys.Frm4100;


        _ =
            Search();
    }


    // =========================================================
    // 검색
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var result =
                await _frm4100Api.SearchAsync(
                    new Frm4100Dto.ReqDto
                    {
                        ItemCode =
                            ItemCodeSrc.Trim(),

                        ItemName =
                            ItemNameSrc.Trim(),

                        LotNo =
                            LotNoSrc.Trim()
                    });


            Items.Clear();


            foreach (var item in result ?? [])
            {
                Items.Add(
                    item);
            }


            StatusMessage =
                $"재고 {Items.Count:N0}건";
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"재고조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 첫 Grid 선택 시 같은 위치 PLT 구성 조회
    // =========================================================

    partial void OnSelectedItemChanged(
        Frm4100Dto.StockDto? value)
    {
        if (value == null)
        {
            PalletItems.Clear();
            return;
        }


        _ =
            LoadPalletAsync(
                value.SubkLoca);
    }


    private async Task LoadPalletAsync(
        string? loca)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(
                loca))
            {
                PalletItems.Clear();
                return;
            }


            var result =
                await _frm4100Api.PalletSearchAsync(
                    loca);


            PalletItems.Clear();


            foreach (var item in result ?? [])
            {
                PalletItems.Add(
                    item);
            }
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"팔레트 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 재고 더블클릭
    // =========================================================

    [RelayCommand]
    private async Task StockDoubleClick(
        Frm4100Dto.StockDto? item)
    {
        try
        {
            if (item == null)
                return;


            LocaEdit =
                item.SubkLoca
                ?? string.Empty;


            PltnoEdit =
                item.SubkPltno
                ?? string.Empty;


            ItemCodeEdit =
                item.SubkCode
                ?? string.Empty;


            ItemNameEdit =
                item.MastName
                ?? string.Empty;


            LotnoEdit =
                item.SubkLotno
                ?? string.Empty;


            BoxNoEdit =
                item.SubkBoxno
                ?? string.Empty;


            RemarkEdit =
                item.SubkRemark
                ?? string.Empty;


            InDateEdit =
                item.SubkIndate
                ?? string.Empty;


            InTimeEdit =
                item.SubkIntime
                ?? string.Empty;


            RealStockQty =
                item.SubkWgt.ToString(
                    "0.00");


            var alreadyRequested =
                WorkItems
                    .Where(
                        x =>
                            x.SubkLoca ==
                            item.SubkLoca &&

                            x.SubkPltno ==
                            item.SubkPltno &&

                            x.SubkCode ==
                            item.SubkCode &&

                            x.SubkLotno ==
                            item.SubkLotno)
                    .Sum(
                        x =>
                            x.RequestQty);


            var available =
                item.SubkWgt -
                alreadyRequested;


            AvailableQty =
                available.ToString(
                    "0.00");


            RequestQty =
                available.ToString(
                    "0.00");


            StationStatus =
                await _frm4100Api
                    .StationStatusAsync(
                        LocaEdit);


            SelectedWsno =
                StationStatus?.Station2No
                ?? StationStatus?.Station1No
                ?? string.Empty;


            IsEditPanelVisible =
                true;
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"출고정보 설정 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 예약 목록 추가
    // =========================================================

    [RelayCommand]
    private void AddWork()
    {
        if (string.IsNullOrWhiteSpace(
            PltnoEdit))
        {
            _dialog.ShowWarning(
                "출고할 재고를 선택해주세요.",
                "확인");

            return;
        }


        if (!decimal.TryParse(
            AvailableQty.Replace(",", ""),
            out var available) ||
            available <= 0)
        {
            _dialog.ShowWarning(
                "출고 가능한 재고가 없습니다.",
                "오류");

            return;
        }


        if (!decimal.TryParse(
            RequestQty.Replace(",", ""),
            out var requestQty) ||
            requestQty <= 0)
        {
            _dialog.ShowWarning(
                "지시 수량을 입력해주세요.",
                "오류");

            return;
        }


        if (requestQty > available)
        {
            _dialog.ShowWarning(
                "출고 수량이 재고 수량보다 큽니다.",
                "오류");

            return;
        }


        if (string.IsNullOrWhiteSpace(
            SelectedWsno))
        {
            _dialog.ShowWarning(
                "출고할 컨베어 스테이션을 선택해주세요.",
                "확인");

            return;
        }


        var duplicate =
            WorkItems.Any(
                x =>
                    x.SubkPltno ==
                    PltnoEdit &&

                    x.SubkCode ==
                    ItemCodeEdit &&

                    x.SubkLotno ==
                    LotnoEdit &&

                    x.Customer ==
                    CustomerEdit);


        if (duplicate)
        {
            _dialog.ShowWarning(
                "동일한 출고예약 데이터가 이미 존재합니다.",
                "오류");

            return;
        }


        var samePlt =
            WorkItems
                .FirstOrDefault(
                    x =>
                        x.SubkPltno ==
                        PltnoEdit);


        if (samePlt != null &&
            samePlt.Wsno !=
            SelectedWsno)
        {
            _dialog.ShowWarning(
                $"PLT-NO [{PltnoEdit}]는 " +
                $"이미 {samePlt.Wsno}번 출고대에 예약되어 있습니다.",
                "오류");

            return;
        }


        if (!ValidateStation())
            return;


        if (!_dialog.ShowConfirm(
            "출고 예약 데이터에 추가하시겠습니까?",
            "확인"))
        {
            return;
        }


        decimal.TryParse(
            RealStockQty.Replace(",", ""),
            out var realStockQty);


        WorkItems.Add(
            new Frm4100Dto.WorkDto
            {
                SubkLoca =
                    LocaEdit,

                SubkPltno =
                    PltnoEdit,

                SubkCode =
                    ItemCodeEdit,

                MastName =
                    ItemNameEdit,

                SubkLotno =
                    LotnoEdit,

                SubkBoxno =
                    BoxNoEdit,

                SubkRemark =
                    RemarkEdit,

                StockQty =
                    realStockQty,

                RequestQty =
                    requestQty,

                Customer =
                    CustomerEdit,

                OutBoxno =
                    OutBoxNoEdit,

                OutRemark =
                    OutRemarkEdit,

                Wsno =
                    SelectedWsno,

                SubkIndate =
                    InDateEdit,

                SubkIntime =
                    InTimeEdit
            });


        ClearEdit();
    }


    // =========================================================
    // Station 검사
    // =========================================================

    private bool ValidateStation()
    {
        if (StationStatus == null)
        {
            _dialog.ShowWarning(
                "출고대 상태를 확인할 수 없습니다.",
                "오류");

            return false;
        }


        if (!StationStatus.AutoMode)
        {
            _dialog.ShowWarning(
                "해당 컨베어가 자동모드가 아닙니다.",
                "오류");

            return false;
        }


        if (SelectedWsno ==
            StationStatus.Station1No)
        {
            if (!StationStatus.Station1OutputMode)
            {
                _dialog.ShowWarning(
                    $"{SelectedWsno}번 컨베어가 출고모드가 아닙니다.",
                    "오류");

                return false;
            }
        }
        else if (SelectedWsno ==
                 StationStatus.Station2No)
        {
            if (!StationStatus.Station2OutputMode)
            {
                _dialog.ShowWarning(
                    $"{SelectedWsno}번 컨베어가 출고모드가 아닙니다.",
                    "오류");

                return false;
            }
        }
        else
        {
            _dialog.ShowWarning(
                "현재 위치에서 사용할 수 없는 출고대입니다.",
                "오류");

            return false;
        }


        return true;
    }


    // =========================================================
    // 선택 예약 삭제
    // =========================================================

    [RelayCommand]
    private void DeleteWork()
    {
        if (SelectedWorkItem == null)
        {
            _dialog.ShowWarning(
                "삭제할 출고예약 데이터를 선택해주세요.",
                "확인");

            return;
        }


        if (!_dialog.ShowConfirm(
            "현재 라인을 삭제하시겠습니까?",
            "확인"))
        {
            return;
        }


        WorkItems.Remove(
            SelectedWorkItem);


        SelectedWorkItem =
            null;
    }


    // =========================================================
    // 전체 예약 취소
    // =========================================================

    [RelayCommand]
    private void ClearWork()
    {
        if (WorkItems.Count == 0)
            return;


        if (!_dialog.ShowConfirm(
            "전체 출고예약 데이터를 취소하시겠습니까?",
            "확인"))
        {
            return;
        }


        WorkItems.Clear();
    }


    // =========================================================
    // 출고예약 확정
    // =========================================================

    [RelayCommand]
    private async Task Reserve()
    {
        try
        {
            if (WorkItems.Count == 0)
            {
                _dialog.ShowWarning(
                    "출고작업할 데이터가 없습니다.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "수동 출고 예약을 확정하시겠습니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm4100Api.ReserveAsync(
                    new Frm4100Dto.ReserveReqDto
                    {
                        UserId =
                            _currentUser.User.UserId,

                        Emergency =
                            IsEmergency,

                        Items =
                            WorkItems.ToList()
                    });


            if (result == null ||
                !result.Success)
            {
                _dialog.ShowWarning(
                    result?.Message
                    ?? "출고예약 실패",
                    "오류");

                return;
            }


            _dialog.ShowInfo(
                $"{result.Message}\n" +
                $"PLT {result.PltCount:N0}건 / " +
                $"상세 {result.DetailCount:N0}건",
                "완료");


            WorkItems.Clear();

            ClearEdit();

            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"출고예약 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 바로출고
    // =========================================================

    [RelayCommand]
    private async Task DirectOutput()
    {
        try
        {
            if (string.IsNullOrWhiteSpace(
                PltnoEdit))
            {
                _dialog.ShowWarning(
                    "출고할 재고를 선택해주세요.",
                    "확인");

                return;
            }


            if (WorkItems.Any(
                x =>
                    x.SubkPltno ==
                    PltnoEdit))
            {
                _dialog.ShowWarning(
                    $"해당 PLT [{PltnoEdit}]는 이미 출고예약 목록에 있습니다.\n" +
                    "예약목록에서 삭제하거나 출고예약 버튼을 사용해주세요.",
                    "오류");

                return;
            }


            if (!decimal.TryParse(
                RequestQty.Replace(",", ""),
                out var requestQty) ||
                requestQty <= 0)
            {
                _dialog.ShowWarning(
                    "지시 수량을 입력해주세요.",
                    "오류");

                return;
            }


            if (!decimal.TryParse(
                RealStockQty.Replace(",", ""),
                out var stockQty))
            {
                return;
            }


            if (!ValidateStation())
                return;


            if (!_dialog.ShowConfirm(
                "현재 입력된 내용으로 즉시 출고하시겠습니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm4100Api.DirectOutputAsync(
                    new Frm4100Dto.DirectOutputReqDto
                    {
                        UserId =
                            _currentUser.User.UserId,

                        Emergency =
                            IsEmergency,

                        Item =
                            new Frm4100Dto.WorkDto
                            {
                                SubkLoca =
                                    LocaEdit,

                                SubkPltno =
                                    PltnoEdit,

                                SubkCode =
                                    ItemCodeEdit,

                                MastName =
                                    ItemNameEdit,

                                SubkLotno =
                                    LotnoEdit,

                                SubkBoxno =
                                    BoxNoEdit,

                                SubkRemark =
                                    RemarkEdit,

                                StockQty =
                                    stockQty,

                                RequestQty =
                                    requestQty,

                                Customer =
                                    CustomerEdit,

                                OutBoxno =
                                    OutBoxNoEdit,

                                OutRemark =
                                    OutRemarkEdit,

                                Wsno =
                                    SelectedWsno,

                                SubkIndate =
                                    InDateEdit,

                                SubkIntime =
                                    InTimeEdit
                            }
                    });


            if (result == null ||
                !result.Success)
            {
                _dialog.ShowWarning(
                    result?.Message
                    ?? "바로출고 실패",
                    "오류");

                return;
            }


            _dialog.ShowInfo(
                result.Message
                ?? "바로출고 완료",
                "완료");


            ClearEdit();

            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"바로출고 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 편집창 닫기
    // =========================================================

    [RelayCommand]
    private void CancelEdit()
    {
        ClearEdit();
    }


    private void ClearEdit()
    {
        LocaEdit =
            string.Empty;

        PltnoEdit =
            string.Empty;

        ItemCodeEdit =
            string.Empty;

        ItemNameEdit =
            string.Empty;

        LotnoEdit =
            string.Empty;

        BoxNoEdit =
            string.Empty;

        RemarkEdit =
            string.Empty;

        CustomerEdit =
            string.Empty;

        OutBoxNoEdit =
            string.Empty;

        OutRemarkEdit =
            string.Empty;

        InDateEdit =
            string.Empty;

        InTimeEdit =
            string.Empty;

        RealStockQty =
            string.Empty;

        AvailableQty =
            string.Empty;

        RequestQty =
            string.Empty;

        SelectedWsno =
            string.Empty;

        StationStatus =
            null;

        IsEditPanelVisible =
            false;
    }
}