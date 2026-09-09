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

namespace TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

public partial class Frm3300ViewModel : DocumentViewModelBase
{
    //private readonly IExcelService _excel;

    private readonly IDialogService _dialog;

    private readonly IExcelService _excel;
    private readonly IFrm3300Api _frm3300Api;

    [ObservableProperty] private ObservableCollection<Frm3300Dto.ResDto> _items = [];

    [ObservableProperty] private Frm3300Dto.ResDto? _selectedItem;

    [ObservableProperty] private int _rowTotalCount = 0;


    public Frm3300ViewModel(IFrm3300Api frm3300Api, IDialogService dialog, IExcelService excel)
    {
        _frm3300Api = frm3300Api;
        _dialog = dialog;
        _excel = excel;

        Title = "미 입고 현황";
        ContentId = DocumentKeys.Frm3300;
    }

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var response = await _frm3300Api.SearchAsync();

            Items.Clear();

            if (response == null)
            {
                return;
            }

            foreach (var item in response)
            {
                Items.Add(item);
            }

            RowTotalCount = Items.Count;
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"조회 중 오류가 발생했습니다.\n{ex.Message}",
                "오류");
        }
    }

    [RelayCommand]
    private async Task DeleteAsync()
    {
        if (SelectedItem == null)
        {
            _dialog.ShowMessage("삭제할 항목을 선택해주세요.", "오류");
            return;
        }

        try
        {
            if (
            _dialog.ShowConfirm(
                " 입고 이력  데이타를 삭제 하겠습니까??", "삭제") == false)
            {
                return;
            }

            var reqDto = new Frm3300Dto.DeleteReqDto
            {
                InptCode = SelectedItem.InptCode,
                InptLotno = SelectedItem.InptLotno,
                InptIndex = SelectedItem.InptIndex,
                InptLoca = SelectedItem.InptLoca
            };

            await _frm3300Api.DeleteAsync(reqDto);
        
            _dialog.ShowMessage("삭제 완료되었습니다.", "완료");

            this.SearchCommand.ExecuteAsync(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"삭제 중 오류가 발생했습니다.\n{ex.Message}",
                "오류");
        }
    }

    [RelayCommand]
    private async Task ExportExcel()
    {
        try
        {
            if (Items.Count == 0) { _dialog.ShowMessage("저장할 데이터가 없습니다.", "안내"); return; }
            if (_excel.Export(Items, "미입고현황"))
                _dialog.ShowMessage("엑셀로 저장되었습니다.", "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
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
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private void Close(Window? window) => window?.Close();
}
