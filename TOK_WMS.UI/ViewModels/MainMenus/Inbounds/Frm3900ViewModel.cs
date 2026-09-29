using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

public partial class Frm3900ViewModel : DocumentViewModelBase
{
    private readonly IDialogService _dialog;
    private readonly IFrm3900Api _frm3900Api;
    private ICurrentUserService _currentUser;

    // 기존 바닥재고를 수정하기 위해 불러온 PLT
    private string _checkPltNo = string.Empty;

    // 기존 바닥재고 중 작업목록에서 제외한 데이터
    // 저장할 때 DB DELETE
    private readonly List<Frm3900Dto.DeleteDto> _deleteItems = [];


    // =========================================================
    // 조회조건
    // =========================================================

    [ObservableProperty] private DateTime? _fromDate = DateTime.Today;
    [ObservableProperty] private DateTime? _toDate = DateTime.Today;

    [ObservableProperty] private string _searchText = string.Empty;

    [ObservableProperty] private Frm3900Dto.SearchTypeDto? _selectedSearchType;
    [ObservableProperty] private Frm3900Dto.HogiDto? _selectedHogi;


    // =========================================================
    // 상세 입력
    // =========================================================

    [ObservableProperty] private string _pltno = string.Empty;
    [ObservableProperty] private string _itemCode = string.Empty;
    [ObservableProperty] private string _itemName = string.Empty;
    [ObservableProperty] private string _lotno = string.Empty;

    [ObservableProperty] private string _weight = string.Empty;
    [ObservableProperty] private string _boxNo = string.Empty;
    [ObservableProperty] private string _remark = string.Empty;

    [ObservableProperty] private string _inDate = string.Empty;
    [ObservableProperty] private string _inTime = string.Empty;
    [ObservableProperty] private string _ouptIndex = string.Empty;


    // =========================================================
    // 기타
    // =========================================================

    [ObservableProperty] private int _recordCount;


    // =========================================================
    // DataGrid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm3900Dto.ResDto> _items = [];

    [ObservableProperty]
    private ObservableCollection<Frm3900Dto.WorkDto> _workItems = [];


    [ObservableProperty]
    private Frm3900Dto.ResDto? _selectedItem;

    [ObservableProperty]
    private Frm3900Dto.WorkDto? _selectedWorkItem;


    // =========================================================
    // ComboBox
    // =========================================================

    public ObservableCollection<Frm3900Dto.SearchTypeDto> SearchTypes { get; } =
    [
        new() { Name = "ALL", Value = "ALL" },
        new() { Name = "PLT-NO", Value = "PLTNO" },
        new() { Name = "품목코드", Value = "CODE" },
        new() { Name = "품목명", Value = "NAME" },
        new() { Name = "LOT-NO", Value = "LOTNO" }
    ];


    public ObservableCollection<Frm3900Dto.HogiDto> HogiItems { get; } =
    [
        new() { Name = "전체", Value = "ALL" },
        new() { Name = "1호기", Value = "1" },
        new() { Name = "2호기", Value = "2" },
        new() { Name = "3호기", Value = "3" }
    ];


    // =========================================================
    // 생성자
    // =========================================================

    public Frm3900ViewModel(
        IFrm3900Api frm3900Api,
        IDialogService dialog,
        ICurrentUserService currentUser)
    {
        _frm3900Api = frm3900Api;
        _dialog = dialog;
        _currentUser = currentUser;

        SelectedSearchType = SearchTypes[0];
        SelectedHogi = HogiItems[0];

        Title = "재입고 관리";
        ContentId = DocumentKeys.Frm3900;
    }


    // =========================================================
    // 조회
    // Delphi StartBitBtnClick
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var reqDto = new Frm3900Dto.ReqDto
            {
                FromDate = FromDate?.ToString("yyyyMMdd"),
                ToDate = ToDate?.ToString("yyyyMMdd"),

                SearchType =
                    SelectedSearchType?.Value ?? "ALL",

                SearchText =
                    SearchText?.Trim(),

                Hogi =
                    SelectedHogi?.Value ?? "ALL"
            };


            var result =
                await _frm3900Api.SearchAsync(reqDto);


            Items.Clear();

            foreach (var h in result ?? [])
                Items.Add(h);


            RecordCount = Items.Count;
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 조회 그리드 선택
    //
    // Delphi DBGrid1CellClick
    // =========================================================

    partial void OnSelectedItemChanged(
        Frm3900Dto.ResDto? value)
    {
        _ = SelectedItemChangedAsync(value);
    }


    private async Task SelectedItemChangedAsync(
        Frm3900Dto.ResDto? item)
    {
        try
        {
            if (item == null)
            {
                ClearInput(true);
                return;
            }


            // =================================================
            // 1. 선택된 출고이력 → 입력창
            // =================================================

            Pltno =
                item.OuptPltno ?? string.Empty;

            ItemCode =
                item.OuptCode ?? string.Empty;

            ItemName =
                item.MastName ?? string.Empty;

            Lotno =
                item.OuptLotno ?? string.Empty;

            Weight =
                item.RemainWgt.ToString("0.##");

            BoxNo =
                item.OuptBoxno ?? string.Empty;

            Remark =
                item.OuptRemark ?? string.Empty;

            InDate =
                item.OuptIndate ?? string.Empty;

            InTime =
                item.OuptIntime ?? string.Empty;

            OuptIndex =
                item.OuptIndex ?? string.Empty;


            // =================================================
            // 2. 바닥재고 확인
            //
            // 0 = 신규
            // 1 = 바닥재고
            // 2 = 랙재고
            // =================================================

            var status =
                item.StatusCode ?? string.Empty;

            var pltNo =
                item.OuptPltno?.Trim() ?? string.Empty;


            if (status != "1")
                return;

            if (string.IsNullOrWhiteSpace(pltNo))
                return;


            // =================================================
            // 3. 작업 목록에 이미 데이터가 있는 경우
            // =================================================

            if (WorkItems.Count > 0)
            {
                var firstPltNo =
                    WorkItems.FirstOrDefault()?
                        .SubkPltno?
                        .Trim()
                    ?? string.Empty;


                // 같은 PLT면 이미 불러온 것으로 판단
                if (firstPltNo == pltNo)
                    return;


                // 다른 PLT가 작업 중이면 불러오지 않음
                return;
            }


            // =================================================
            // 4. 기존 바닥재고 불러오기 확인
            // =================================================

            if (!_dialog.ShowConfirm(
                $"해당 PLT-NO [{pltNo}]로 등록된 바닥 재고 데이터가 있습니다.\n" +
                $"작업 목록으로 불러오시겠습니까?",
                "확인"))
            {
                return;
            }


            // =================================================
            // 5. T2MISUBK 조회
            // =================================================

            var result =
                await _frm3900Api.FloorStockSearchAsync(
                    pltNo);


            if (result == null ||
                !result.Any())
            {
                _dialog.ShowMessage(
                    "등록된 재고 정보를 찾을 수 없습니다.",
                    "오류");

                return;
            }


            // =================================================
            // 6. Delphi InResGrid → WorkItems
            // =================================================

            WorkItems.Clear();


            foreach (var h in result)
            {
                WorkItems.Add(h);
            }


            // 기존 바닥재고를 불러온 PLT 기록
            _checkPltNo = pltNo;
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"바닥재고 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 작업목록 추가
    //
    // Delphi ConfirmBtnClick
    // =========================================================

    [RelayCommand]
    private async Task AddWork()
    {
        try
        {
            var pltNo =
                Pltno?.Trim() ?? string.Empty;

            var code =
                ItemCode?.Trim() ?? string.Empty;

            var lotNo =
                Lotno?.Trim() ?? string.Empty;


            // =================================================
            // 기본 체크
            // =================================================

            if (string.IsNullOrWhiteSpace(pltNo))
            {
                _dialog.ShowMessage(
                    "PLT-NO가 입력되지 않았습니다.",
                    "오류");

                return;
            }


            if (string.IsNullOrWhiteSpace(code))
            {
                _dialog.ShowMessage(
                    "품목코드가 없습니다.",
                    "오류");

                return;
            }


            // =================================================
            // 품목 마스터 체크
            // =================================================

            var mast =
                await _frm3900Api.ItemCheckAsync(code);


            if (mast == null)
            {
                _dialog.ShowMessage(
                    "품목 마스터에 존재하지 않는 코드입니다.",
                    "오류");

                return;
            }


            ItemCode =
                mast.MastCode ?? code;

            ItemName =
                mast.MastName ?? string.Empty;


            // =================================================
            // 중량 체크
            // =================================================

            var weightText =
                Weight?
                    .Replace(",", "")
                    .Trim();


            if (!decimal.TryParse(
                    weightText,
                    out var qty) ||
                qty <= 0)
            {
                _dialog.ShowMessage(
                    "입고할 중량은 0보다 커야 합니다.",
                    "오류");

                return;
            }


            // =================================================
            // 작업목록에 다른 PLT가 있는지
            // =================================================

            var firstPltNo =
                WorkItems.FirstOrDefault()?
                    .SubkPltno?
                    .Trim();


            if (!string.IsNullOrWhiteSpace(firstPltNo) &&
                firstPltNo != pltNo)
            {
                _dialog.ShowMessage(
                    $"작업 목록에는 동일한 PLT-NO만 등록할 수 있습니다.\n\n" +
                    $"기존 목록 : [{firstPltNo}]\n" +
                    $"현재 입력 : [{pltNo}]",
                    "오류");

                return;
            }


            // =================================================
            // DB PLT 상태 확인
            // =================================================

            var pltCheck =
                await _frm3900Api.PltCheckAsync(
                    pltNo);


            if (pltCheck != null &&
                pltCheck.Count > 0)
            {
                // =============================================
                // 랙에 들어가 있는 PLT
                // =============================================

                if (!string.IsNullOrWhiteSpace(
                    pltCheck.SubkLoca))
                {
                    _dialog.ShowMessage(
                        $"[{pltNo}] 는 이미 적재 완료된 파렛트입니다.\n" +
                        $"위치 : {pltCheck.SubkLoca}",
                        "오류");

                    return;
                }


                // =============================================
                // 바닥재고
                // =============================================

                var gridHasPlt =
                    WorkItems.Any(x =>
                        x.SubkPltno == pltNo);


                if (!gridHasPlt &&
                    pltNo != _checkPltNo)
                {
                    _dialog.ShowMessage(
                        $"[{pltNo}] 는 이미 등록된 바닥 재고입니다.\n" +
                        $"먼저 출고이력에서 해당 PLT-NO를 선택하여 " +
                        $"기존 재고를 작업목록으로 불러와주세요.",
                        "오류");

                    return;
                }
            }


            // =================================================
            // PLT + CODE + LOT 중복 체크
            // =================================================

            if (WorkItems.Any(x =>
                x.SubkPltno == pltNo &&
                x.SubkCode == code &&
                x.SubkLotno == lotNo))
            {
                _dialog.ShowMessage(
                    "이미 작업 목록에 추가된 항목입니다.",
                    "오류");

                return;
            }


            // =================================================
            // 작업목록 추가
            // =================================================

            WorkItems.Add(
                new Frm3900Dto.WorkDto
                {
                    SubkPltno = pltNo,

                    SubkCode = code,

                    MastName =
                        ItemName,

                    SubkLotno =
                        lotNo,

                    SubkWgt =
                        qty,

                    SubkBoxno =
                        BoxNo?.Trim(),

                    SubkRemark =
                        Remark?.Trim(),

                    SubkIndate =
                        InDate,

                    SubkIntime =
                        InTime,

                    OuptIndex =
                        OuptIndex,

                    // 신규/수정 데이터
                    Status = "0"
                });


            // PLT는 유지하고 나머지만 초기화
            ClearInput(false);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"작업목록 추가 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 작업목록 수정/취소
    //
    // Delphi CancelSBClick
    // =========================================================

    [RelayCommand]
    private void ModifyWork(
        Frm3900Dto.WorkDto item)
    {
        try
        {
            if (item == null)
            {
                _dialog.ShowMessage(
                    "수정할 데이터를 선택해주세요.",
                    "오류");

                return;
            }


            if (!_dialog.ShowConfirm(
                "선택한 데이터를 목록에서 제외하고 수정하시겠습니까?\n" +
                "(기존 등록 재고는 저장 시 삭제됩니다.)",
                "확인"))
            {
                return;
            }


            // =================================================
            // 입력창으로 값 복원
            // =================================================

            Pltno =
                item.SubkPltno ?? string.Empty;

            ItemCode =
                item.SubkCode ?? string.Empty;

            ItemName =
                item.MastName ?? string.Empty;

            Lotno =
                item.SubkLotno ?? string.Empty;

            Weight =
                item.SubkWgt?.ToString("0.##")
                ?? string.Empty;

            BoxNo =
                item.SubkBoxno ?? string.Empty;

            Remark =
                item.SubkRemark ?? string.Empty;

            InDate =
                item.SubkIndate ?? string.Empty;

            InTime =
                item.SubkIntime ?? string.Empty;

            OuptIndex =
                item.OuptIndex ?? string.Empty;


            // =================================================
            // 기존 바닥재고라면 삭제 예정 목록 추가
            // =================================================

            if (item.Status == "1")
            {
                _checkPltNo =
                    item.SubkPltno ?? string.Empty;


                var exists =
                    _deleteItems.Any(x =>
                        x.SubkPltno == item.SubkPltno &&
                        x.SubkCode == item.SubkCode &&
                        x.SubkLotno == item.SubkLotno);


                if (!exists)
                {
                    _deleteItems.Add(
                        new Frm3900Dto.DeleteDto
                        {
                            SubkPltno =
                                item.SubkPltno,

                            SubkCode =
                                item.SubkCode,

                            SubkLotno =
                                item.SubkLotno
                        });
                }
            }


            // =================================================
            // 작업목록에서 제거
            // =================================================

            WorkItems.Remove(item);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"수정 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 재입고 확정
    //
    // Delphi ReservedSBClick
    // =========================================================

    [RelayCommand]
    private async Task Save()
    {
        try
        {
            if (WorkItems.Count == 0 &&
                _deleteItems.Count == 0)
            {
                _dialog.ShowMessage(
                    "저장할 데이터가 없습니다.",
                    "오류");

                return;
            }


            if (!_dialog.ShowConfirm(
                "작업 목록을 재입고 확정 하시겠습니까?",
                "확인"))
            {
                return;
            }


            var reqDto =
                new Frm3900Dto.SaveReqDto
                {
                    UserId = _currentUser?.User?.UserId,

                    //UserId = string.Empty,

                    Items =
                        WorkItems.ToList(),

                    DeleteItems =
                        _deleteItems.ToList()
                };


            var result =
                await _frm3900Api.SaveAsync(
                    reqDto);


            _deleteItems.Clear();

            WorkItems.Clear();

            _checkPltNo =
                string.Empty;


            SelectedWorkItem = null;

            ClearInput(true);


            _dialog.ShowMessage(
                $"저장이 완료되었습니다. ({result}건)",
                "확인");


            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"저장 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 작업목록 전체 초기화
    // 필요하면 버튼 연결 가능
    // =========================================================

    [RelayCommand]
    private void ClearWork()
    {
        if (WorkItems.Count == 0)
            return;


        if (!_dialog.ShowConfirm(
            "현재 작업 목록을 초기화하시겠습니까?",
            "확인"))
        {
            return;
        }


        WorkItems.Clear();

        _deleteItems.Clear();

        _checkPltNo =
            string.Empty;

        SelectedWorkItem = null;

        ClearInput(true);
    }


    // =========================================================
    // 입력창 초기화
    //
    // clearPltNo = false
    // → PLT-NO 유지
    //
    // clearPltNo = true
    // → 전체 초기화
    // =========================================================

    private void ClearInput(
        bool clearPltNo)
    {
        if (clearPltNo)
        {
            Pltno = string.Empty;
        }


        ItemCode =
            string.Empty;

        ItemName =
            string.Empty;

        Lotno =
            string.Empty;

        Weight =
            string.Empty;

        BoxNo =
            string.Empty;

        Remark =
            string.Empty;

        InDate =
            string.Empty;

        InTime =
            string.Empty;

        OuptIndex =
            string.Empty;
    }
}