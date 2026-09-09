using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Xaml.Behaviors.Media;
using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.Api.Inventory;
using TOK.WMS.UI.Services.ETC;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public partial class Frm6300ViewModel : DocumentViewModelBase
{
    private readonly IDialogService _dialog;
    private readonly IFrm6300Api _frm6300Api;
    private readonly IExcelService _excel;

    [ObservableProperty] private string _subkIndateFrom = string.Empty;
    [ObservableProperty] private string _subkIndateTo = string.Empty;
    [ObservableProperty] private string _searchText = string.Empty;
    [ObservableProperty] private int _recNo;
    [ObservableProperty] private string _subkFlag = string.Empty;
    [ObservableProperty] private string _subkLoca = string.Empty;
    [ObservableProperty] private string _subkPltno = string.Empty;
    [ObservableProperty] private string _subkCode = string.Empty;
    [ObservableProperty] private string _mastName = string.Empty;
    [ObservableProperty] private string _subkLotno = string.Empty;
    [ObservableProperty] private string _subkWgt = string.Empty;
    [ObservableProperty] private string _subkRwgt = string.Empty;
    [ObservableProperty] private string _subkBoxno = string.Empty;
    [ObservableProperty] private string _subkRemark = string.Empty;
    [ObservableProperty] private string _subkIndate = string.Empty;
    [ObservableProperty] private string _subkIntime = string.Empty;
    [ObservableProperty] private string _gubn1Name = string.Empty;
    [ObservableProperty] private string _gubn2Name = string.Empty;
    [ObservableProperty] private string _gubn3Name = string.Empty;
    [ObservableProperty] private string _subkWgtTotal = string.Empty;

    [ObservableProperty] private ComboItem? _selectedSearchType;
    [ObservableProperty] private ComboItem? _selectedDangerousType;
    [ObservableProperty] private ComboItem? _selectedSolubilityType;
    [ObservableProperty] private ComboItem? _selectedPetroleumType;

    [ObservableProperty] private ObservableCollection<Frm6300Dto.ResDto> _Items = [];
    [ObservableProperty] private ObservableCollection<Frm6300Dto.LotnoResDto> _SubkItems = [];

    [ObservableProperty] private Frm6300Dto.ResDto? _selectedItem;

    [ObservableProperty] private bool _isBanPanelVisible;

    [ObservableProperty] private string _banRemark = string.Empty;
    [ObservableProperty] private string _banType = "1";

    public Frm6300ViewModel(IFrm6300Api frm6300Api, IDialogService dialog, IExcelService excel)
    {
        _frm6300Api = frm6300Api;
        _dialog = dialog;
        _excel = excel;

        Title = "재고 집계 자료조회";
        ContentId = DocumentKeys.Frm6300;

        SelectedDangerousType = DangerousTypes.FirstOrDefault();
        SelectedSolubilityType = SolubilityTypes.FirstOrDefault();
        SelectedPetroleumType = PetroleumTypes.FirstOrDefault();
    }

    #region ComboBox Items
    public class ComboItem
    {
        public string Name { get; set; } = string.Empty;
        public string Value { get; set; } = string.Empty;
    }


    // 검색 조건
    public ObservableCollection<ComboItem> SearchTypes { get; } = new()
    {
        new() { Name = "ALL",      Value = "ALL" },
        new() { Name = "저장위치", Value = "LOCA" },
        new() { Name = "품목코드", Value = "CODE" },
        new() { Name = "품목명",   Value = "NAME" },
        new() { Name = "LOT-NO",   Value = "LOTNO" }
    };

    // 위험물
    public ObservableCollection<ComboItem> DangerousTypes { get; } = new()
    {
        new() { Value = "", Name = "" },
        new() { Value = "1", Name = "제 1류" },
        new() { Value = "2", Name = "제 2류" },
        new() { Value = "3", Name = "제 3류" },
        new() { Value = "4", Name = "제 4류" },
        new() { Value = "5", Name = "제 5류" },
    };

    // 수용성
    public ObservableCollection<ComboItem> SolubilityTypes { get; } = new()
    {
        new() { Value = "", Name = "" },
        new() { Value = "1", Name = "비수용성" },
        new() { Value = "2", Name = "수용성" },
    };

    // 석유류
    public ObservableCollection<ComboItem> PetroleumTypes { get; } = new()
    {
        new() { Value = "", Name = "" },
        new() { Value = "1", Name = "제 1 석유류" },
        new() { Value = "2", Name = "제 2 석유류" },
        new() { Value = "3", Name = "제 3 석유류" },
        new() { Value = "4", Name = "제 4 석유류" },
        new() { Value = "9", Name = "자기반응물질" },
    };

    #endregion

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var reqDto = new Frm6300Dto.ReqDto
            {
                SubkCode = SubkCode ?? string.Empty,
                DangerousType = SelectedDangerousType?.Value ?? string.Empty,
                PetroleumType = SelectedPetroleumType?.Value ?? string.Empty,
                SolubilityType = SelectedSolubilityType?.Value ?? string.Empty
            };

            var response = await _frm6300Api.SearchAsync(reqDto);

            Items.Clear();
            foreach (var h in response ?? []) Items.Add(h);

            SubkWgtTotal = Items.Sum(x => decimal.TryParse(x.SubkTqty, out var wgt) ? wgt : 0).ToString();

        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task LotnoSearch()
    {
        try
        {
            SubkItems.Clear();

            if (SelectedItem?.SubkCode == null)
            {
                return;
            }

            var reqDto = new Frm6300Dto.ReqDto
            {
                SubkCode = SelectedItem.SubkCode
            };


            var result = await _frm6300Api.LotnoSearchAsync(reqDto);



            foreach (var h in result ?? []) SubkItems.Add(h);

        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task ExportExcel()
    {
        try
        {
            if (Items.Count == 0) { _dialog.ShowMessage("저장할 데이터가 없습니다.", "안내"); return; }
            if (_excel.Export(Items, "재고집계자료조회"))
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
