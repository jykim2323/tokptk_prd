using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Outbounds;
using TOK.WMS.UI.Services.ETC;
using TOK.WMS.UI.ViewModels.Base;

using System.Windows.Controls;

namespace TOK.WMS.UI.ViewModels.MainMenus.Outbounds;

public partial class Frm4500ViewModel : DocumentViewModelBase
{
    private readonly IFrm4500Api _frm4500Api;

    private readonly IDialogService _dialog;

    private readonly IExcelService _excelService;


    // =========================================================
    // 검색 조건
    // =========================================================

    [ObservableProperty]
    private DateTime? _fromDate =
        DateTime.Today;


    [ObservableProperty]
    private DateTime? _toDate =
        DateTime.Today;


    [ObservableProperty]
    private string _itemCode =
        string.Empty;


    [ObservableProperty]
    private string _itemName =
        string.Empty;


    // =========================================================
    // 상단 품목별 Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm4500Dto.ItemSummaryDto> _items =
        [];


    [ObservableProperty]
    private Frm4500Dto.ItemSummaryDto? _selectedItem;


    // =========================================================
    // 하단 LOT Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm4500Dto.LotSummaryDto> _lotItems =
        [];


    [ObservableProperty]
    private Frm4500Dto.LotSummaryDto? _selectedLotItem;


    // =========================================================
    // 상태
    // =========================================================

    [ObservableProperty]
    private int _recordCount;


    [ObservableProperty]
    private int _lotRecordCount;


    [ObservableProperty]
    private decimal _totalQty;


    [ObservableProperty]
    private decimal _lotTotalQty;


    [ObservableProperty]
    private string _statusMessage =
        string.Empty;


    public Frm4500ViewModel(
        IFrm4500Api frm4500Api,
        IDialogService dialog,
        IExcelService excelService)
    {
        _frm4500Api =
            frm4500Api;


        _dialog =
            dialog;


        _excelService =
            excelService;


        Title =
            "출고 실적 현황";


        ContentId =
            DocumentKeys.Frm4500;
    }


    // =========================================================
    // 화면 Loaded
    // =========================================================

    [RelayCommand]
    private async Task Loaded()
    {
        await Search();
    }


    // =========================================================
    // 조회
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            if (FromDate == null ||
                ToDate == null)
            {
                _dialog.ShowWarning(
                    "출고일자를 선택해주세요.",
                    "확인");

                return;
            }


            if (FromDate >
                ToDate)
            {
                _dialog.ShowWarning(
                    "시작일자가 종료일자보다 클 수 없습니다.",
                    "확인");

                return;
            }


            var reqDto =
                new Frm4500Dto.ReqDto
                {
                    FromDate =
                        FromDate.Value
                            .ToString(
                                "yyyyMMdd"),

                    ToDate =
                        ToDate.Value
                            .ToString(
                                "yyyyMMdd"),

                    ItemCode =
                        ItemCode?
                            .Trim(),

                    ItemName =
                        ItemName?
                            .Trim()
                };


            var result =
                await _frm4500Api
                    .SearchAsync(
                        reqDto);


            Items.Clear();

            LotItems.Clear();


            SelectedItem =
                null;


            SelectedLotItem =
                null;


            foreach (var item in
                result ?? [])
            {
                Items.Add(
                    item);
            }


            RecordCount =
                Items.Count;


            TotalQty =
                Items.Sum(
                    x => x.StkTqty);


            StatusMessage =
                $"품목 {RecordCount:N0}건 / 총 출고중량 {TotalQty:N2}";


            // =================================================
            // Delphi Query1.Open 후 First와 비슷하게
            // 첫 번째 품목 자동 선택
            // =================================================

            if (Items.Count > 0)
            {
                SelectedItem =
                    Items[0];
            }
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // SelectedItem 변경
    //
    // Delphi DataSource1DataChange 대응
    // =========================================================

    partial void OnSelectedItemChanged(
        Frm4500Dto.ItemSummaryDto? value)
    {
        _ =
            LotSearchAsync(
                value);
    }


    // =========================================================
    // LOT별 조회
    // =========================================================

    private async Task LotSearchAsync(
        Frm4500Dto.ItemSummaryDto? item)
    {
        try
        {
            LotItems.Clear();


            LotRecordCount =
                0;


            LotTotalQty =
                0;


            if (item == null ||
                string.IsNullOrWhiteSpace(
                    item.StkCode))
            {
                return;
            }


            if (FromDate == null ||
                ToDate == null)
            {
                return;
            }


            var reqDto =
                new Frm4500Dto.LotReqDto
                {
                    FromDate =
                        FromDate.Value
                            .ToString(
                                "yyyyMMdd"),

                    ToDate =
                        ToDate.Value
                            .ToString(
                                "yyyyMMdd"),

                    ItemCode =
                        item.StkCode
                };


            var result =
                await _frm4500Api
                    .LotSearchAsync(
                        reqDto);


            foreach (var row in
                result ?? [])
            {
                LotItems.Add(
                    row);
            }


            LotRecordCount =
                LotItems.Count;


            LotTotalQty =
                LotItems.Sum(
                    x => x.StkTqty);
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"LOT별 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // Excel
    //
    // Delphi는 Query1, 즉 품목별 실적을 저장
    // =========================================================

    [RelayCommand]
    private void Excel(DataGrid? grid)
    {
        if (Items.Count == 0)
        {
            _dialog.ShowInfo(
                "엑셀로 저장할 데이터가 없습니다.",
                "확인");

            return;
        }


        if (!_dialog.ShowConfirm(
            "해당 조회건을 엑셀로 저장할까요?",
            "확인"))
        {
            return;
        }


        var result =
            _excelService.Export(
                Items,
                "출고실적현황",
                "출고실적현황", grid: grid);


        if (result)
        {
            _dialog.ShowInfo(
                "엑셀 저장이 완료되었습니다.",
                "완료");
        }
    }
}
