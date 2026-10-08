using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.EMMA;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections;
using System.Collections.ObjectModel;
using System.Reflection;
using System.Windows;
using TOK.WMS.Core.DTOs;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.ETC;
using TOK.WMS.UI.ViewModels.Base;

using System.Windows.Controls;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

public partial class Frm3400ViewModel : DocumentViewModelBase
{
    private readonly IDialogService _dialog;
    private readonly IExcelService _excel;
    private readonly IFrm3400Api _frm3400Api;

    // =========================================================
    // DataGrid
    // =========================================================

    [ObservableProperty] private ObservableCollection<Frm3400Dto.ResDto> _items = [];

    [ObservableProperty] private Frm3400Dto.ResDto? _selectedItem;

    [ObservableProperty] private int _rowTotalCount = 0;


    // =========================================================
    // 검색 조건
    // Delphi SeltCB / ItemCB
    // =========================================================

    public ObservableCollection<Frm3400Dto.SearchTypeDto> SearchTypes { get; } =
    [
        new() { Name = "전체",     Value = "ALL" },
        new() { Name = "호기",     Value = "HOGI" },
        new() { Name = "품목코드", Value = "CODE" },
        new() { Name = "품목명",   Value = "NAME" },
        new() { Name = "LOT-NO",   Value = "LOTNO" },
        new() { Name = "PLT-NO",   Value = "PLTNO" }
     ];

    public ObservableCollection<Frm3400Dto.RFlagTypeDto> RFlagTypes { get; } =
    [
        new() { Name = "전체",     Value = "ALL" },
        new() { Name = "신규입고", Value = "N" },
        new() { Name = "재입고",   Value = "R" }
    ];

    [ObservableProperty] private Frm3400Dto.SearchTypeDto? _selectedSearchType;

    [ObservableProperty] private Frm3400Dto.RFlagTypeDto? _selectedRFlagType;

    [ObservableProperty] private DateTime? _fromDate = DateTime.Today;
    [ObservableProperty] private DateTime? _toDate = DateTime.Today;

    [ObservableProperty] private string _searchText = string.Empty;


    // =========================================================
    // 입고 선택
    // Delphi SelRG
    //
    // ALL = 전체
    // N   = 신규입고
    // R   = 재입고
    // =========================================================
    [ObservableProperty] private string _selectedRFlag = "ALL";
    partial void OnSelectedRFlagChanged(string value)
    {
        SearchCommand.Execute(null);
    }



    [ObservableProperty] private string _statusMessage = string.Empty;

    public Frm3400ViewModel(IFrm3400Api frm3400Api, IDialogService dialog, IExcelService excel)
    {
        _frm3400Api = frm3400Api;
        _dialog = dialog;
        _excel = excel;

        Title = "입고 이력 현황";
        ContentId = DocumentKeys.Frm3400;
        SelectedSearchType = SearchTypes[0];
    }

    [RelayCommand]
    private async Task Search()
    {
        try
        {

            var reqDto = new Frm3400Dto.ReqDto
            {
                FromDate = FromDate?.ToString("yyyyMMdd")
                           ?? DateTime.Today.ToString("yyyyMMdd"),

                ToDate = ToDate?.ToString("yyyyMMdd")
                         ?? DateTime.Today.ToString("yyyyMMdd"),

                RFlag = SelectedRFlag,

                SearchType = SelectedSearchType?.Value ?? "ALL",

                SearchText = SearchText?.Trim()
            };

            var result = await _frm3400Api.SearchAsync(reqDto);

            Items.Clear();

            foreach (var item in result ?? [])
            {
                Items.Add(item);
            }

            RowTotalCount = Items.Count;

        }
        catch (Exception ex)
        {
            StatusMessage = "조회 오류";

            _dialog.ShowWarning(
                $"조회 중 오류가 발생했습니다.\n{ex.Message}",
                "오류");
        }
    }

    [RelayCommand]
    private async Task DeleteAsync()
    {
        if (SelectedItem == null)
        {
            _dialog.ShowWarning("삭제할 항목을 선택해주세요.", "오류");
            return;
        }

        try
        {
            var reqDto = new Frm3400Dto.DeleteReqDto
            {
                InptCode = SelectedItem.InptCode,
                InptIndex = SelectedItem.InptIndex
            };

            var result = await _frm3400Api.DeleteAsync(reqDto);

            if (!result)
            {
                _dialog.ShowWarning("삭제할 데이터를 찾을 수 없습니다.", "오류");
                return;
            }

            _dialog.ShowInfo("삭제 완료되었습니다.", "완료");

            this.SearchCommand.Execute(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"삭제 중 오류가 발생했습니다.\n{ex.Message}",
                "오류");
        }
    }

    [RelayCommand]
    private async Task ExportExcel(DataGrid? grid)
    {
        try
        {
            if (Items.Count == 0) { _dialog.ShowInfo("저장할 데이터가 없습니다.", "안내"); return; }
            if (_excel.Export(Items, "입고이력현황", grid: grid))
                _dialog.ShowInfo("엑셀로 저장되었습니다.", "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Print()
    {
        try
        {
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
        }
    }

}
