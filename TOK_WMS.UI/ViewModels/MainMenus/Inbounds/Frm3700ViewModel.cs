using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

public partial class Frm3700ViewModel : DocumentViewModelBase
{
    private readonly IFrm3700Api _frm3700Api;
    private readonly IDialogService _dialog;


    public Frm3700ViewModel(
        IFrm3700Api frm3700Api,
        IDialogService dialog)
    {
        _frm3700Api = frm3700Api;
        _dialog = dialog;
    }


    // =========================================================
    // 날짜
    // =========================================================

    [ObservableProperty]
    private DateTime? _fromDate = DateTime.Today;

    [ObservableProperty]
    private DateTime? _toDate = DateTime.Today;


    // =========================================================
    // 검색조건
    // =========================================================

    [ObservableProperty]
    private string _itemCode = string.Empty;

    [ObservableProperty]
    private string _itemName = string.Empty;


    // =========================================================
    // 상단 DataGrid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm3700Dto.ResDto> _items = [];

    [ObservableProperty]
    private Frm3700Dto.ResDto? _selectedItem;


    // =========================================================
    // 하단 LOT DataGrid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm3700Dto.LotResDto> _lotItems = [];

    [ObservableProperty]
    private Frm3700Dto.LotResDto? _selectedLotItem;


    // =========================================================
    // 기타
    // =========================================================

    [ObservableProperty]
    private int _recordCount;

    [ObservableProperty]
    private int _lotRecordCount;

    [ObservableProperty]
    private bool _isBusy;

    [ObservableProperty]
    private string _statusMessage = string.Empty;


    // =========================================================
    // 조회
    // Delphi StartBitBtnClick
    // =========================================================

    [RelayCommand]
    private async Task SearchAsync()
    {
        try
        {
            IsBusy = true;


            var reqDto = new Frm3700Dto.ReqDto
            {
                FromDate =
                    FromDate?.ToString("yyyyMMdd")
                    ?? DateTime.Today.ToString("yyyyMMdd"),

                ToDate =
                    ToDate?.ToString("yyyyMMdd")
                    ?? DateTime.Today.ToString("yyyyMMdd"),

                ItemCode =
                    ItemCode?.Trim(),

                ItemName =
                    ItemName?.Trim()
            };


            var result =
                await _frm3700Api.SearchAsync(reqDto);


            Items.Clear();
            LotItems.Clear();


            foreach (var item in result ?? [])
            {
                Items.Add(item);
            }


            RecordCount = Items.Count;
            LotRecordCount = 0;


            StatusMessage =
                $"조회 {RecordCount:N0}건";
        }
        catch (Exception ex)
        {
            StatusMessage = "조회 오류";

            _dialog.ShowMessage(
                $"조회 중 오류가 발생했습니다.\n{ex.Message}",
                "오류");
        }
        finally
        {
            IsBusy = false;
        }
    }


    // =========================================================
    // LOT 조회
    // Delphi LotNo_Select_Proc
    // =========================================================

    private async Task LotSearchAsync(
        Frm3700Dto.ResDto item)
    {
        try
        {
            var reqDto =
                new Frm3700Dto.LotReqDto
                {
                    FromDate =
                        FromDate?.ToString("yyyyMMdd")
                        ?? DateTime.Today.ToString("yyyyMMdd"),

                    ToDate =
                        ToDate?.ToString("yyyyMMdd")
                        ?? DateTime.Today.ToString("yyyyMMdd"),

                    StkCode =
                        item.StkCode
                };


            var result =
                await _frm3700Api.LotSearchAsync(reqDto);


            LotItems.Clear();


            foreach (var lot in result ?? [])
            {
                LotItems.Add(lot);
            }


            LotRecordCount =
                LotItems.Count;
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"LOT 조회 중 오류가 발생했습니다.\n{ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 상단 선택 행 변경
    // Delphi DataSource1DataChange
    // =========================================================

    partial void OnSelectedItemChanged(
        Frm3700Dto.ResDto? value)
    {
        if (value == null)
        {
            LotItems.Clear();

            LotRecordCount = 0;

            return;
        }


        _ = LotSearchAsync(value);
    }
}