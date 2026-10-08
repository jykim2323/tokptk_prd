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

public partial class Frm6700ViewModel : DocumentViewModelBase
{
    private readonly IDialogService _dialog;
    private readonly IFrm6700Api _frm6700Api;
    private readonly IExcelService _excel;
    [ObservableProperty] private string _jegoCode = string.Empty;
    [ObservableProperty] private string _stokFlag = string.Empty;
    [ObservableProperty] private string _stokLoca = string.Empty;
    [ObservableProperty] private string _stokPltno = string.Empty;
    [ObservableProperty] private string _stokCode = string.Empty;
    [ObservableProperty] private string _mastName = string.Empty;
    [ObservableProperty] private string _stokLotno = string.Empty;
    [ObservableProperty] private string _stokQty = string.Empty;
    [ObservableProperty] private string _stokBoxno = string.Empty;
    [ObservableProperty] private string _stokRemark = string.Empty;
    [ObservableProperty] private string _stokIndate = string.Empty;
    [ObservableProperty] private string _stokIntime = string.Empty;
    [ObservableProperty] private string _gubn1Name = string.Empty;
    [ObservableProperty] private string _gubn2Name = string.Empty;
    [ObservableProperty] private string _gubn3Name = string.Empty;
    [ObservableProperty] private string _stokWgtTotal = string.Empty;
    [ObservableProperty] private string _stokPltTotal = string.Empty;
    [ObservableProperty] private DateTime? _selectedInDate;

    [ObservableProperty] private ComboItem? _selectedSearchType;
    [ObservableProperty] private ComboItem? _selectedDangerousType;
    [ObservableProperty] private ComboItem? _selectedSolubilityType;
    [ObservableProperty] private ComboItem? _selectedPetroleumType;
    [ObservableProperty] private ObservableCollection<Frm6700Dto.ResDto> _Items = [];
    [ObservableProperty] private Frm6700Dto.ResDto? _selectedItem;
    [ObservableProperty] private bool _whType = false;
    [ObservableProperty] private bool _stokWhM = false;
    [ObservableProperty] private bool _stokWhS = false;
    [ObservableProperty] private bool _stokWhW = false;
    [ObservableProperty] private bool _stokWhA = false;

    public Frm6700ViewModel(IFrm6700Api frm6700Api, IDialogService dialog, IExcelService excel)
    {
        _frm6700Api = frm6700Api;
        _dialog = dialog;
        _excel = excel;

        Title = "전일 재고 현황";
        ContentId = DocumentKeys.Frm6700;

        SelectedDangerousType = DangerousTypes.FirstOrDefault();
        SelectedSolubilityType = SolubilityTypes.FirstOrDefault();
        SelectedPetroleumType = PetroleumTypes.FirstOrDefault();

        SelectedInDate = DateTime.Now;
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
            var reqDto = new Frm6700Dto.ReqDto
            {
                JegoDate = SelectedInDate?.ToString("yyyyMMdd") ?? DateTime.Now.ToString("yyyyMMdd"),
                JegoCode = JegoCode ?? string.Empty,
                MastName = MastName ?? string.Empty,
                StokWhM = StokWhM,
                StokWhS = StokWhS,
                StokWhW = StokWhW,
                DangerousType = SelectedDangerousType?.Value ?? string.Empty,
                PetroleumType = SelectedPetroleumType?.Value ?? string.Empty,
                SolubilityType = SelectedSolubilityType?.Value ?? string.Empty,
            };

            var response = await _frm6700Api.SearchAsync(reqDto);

            Items.Clear();
            foreach (var h in response ?? []) Items.Add(h);

        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task ExportExcel(DataGrid? grid)
    {
        try
        {
            if (Items.Count == 0) { _dialog.ShowInfo("저장할 데이터가 없습니다.", "안내"); return; }
            if (_excel.Export(Items, "전일재고현황", grid: grid))
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
