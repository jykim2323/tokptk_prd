using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using System.Windows;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Monitoring;
using TOK.WMS.UI.Services.Interfaces.Popup;

namespace TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

public partial class RackOverviewViewModel : ObservableObject
{
    private const int FirstBank = 1;
    private const int LastBank = 14;
    private const int LevelCount = 9;

    private readonly ISc1LineApi _api;
    private readonly IDialogService _dialog;
    private readonly IWindowService _windowService;
    private int _highlightedBay;
    private int _requestedBank;

    [ObservableProperty]
    private int _selectedBank = FirstBank;

    [ObservableProperty]
    private bool _isLoading;

    [ObservableProperty]
    private string _statusMessage = "열을 선택한 후 조회하세요.";

    [ObservableProperty]
    private int _loadedCellCount;

    public RackOverviewViewModel(
        ISc1LineApi api,
        IDialogService dialog,
        IWindowService windowService)
    {
        _api = api;
        _dialog = dialog;
        _windowService = windowService;

        BankOptions = Enumerable.Range(FirstBank, LastBank).ToArray();
    }

    public IReadOnlyList<int> BankOptions { get; }

    public ObservableCollection<RackBayHeader> BayHeaders { get; } = [];

    public ObservableCollection<RackLevelRow> LevelRows { get; } = [];

    public void Initialize(int bank, int selectedBay)
    {
        SelectedBank = Math.Clamp(bank, FirstBank, LastBank);
        _requestedBank = SelectedBank;

        var lastBay = GetLastBay(SelectedBank);
        _highlightedBay = selectedBay >= 1 && selectedBay <= lastBay
            ? selectedBay
            : 0;

        _ = LoadCellsAsync();
    }

    [RelayCommand]
    private async Task SearchAsync()
    {
        if (IsLoading)
            return;

        if (SelectedBank != _requestedBank)
            _highlightedBay = 0;

        _requestedBank = SelectedBank;
        await LoadCellsAsync();
    }

    [RelayCommand]
    private void OpenCell(RackCellTile? tile)
    {
        if (tile is not { IsAvailable: true } || string.IsNullOrWhiteSpace(tile.Location))
            return;

        _windowService.ShowRackCellDetail(tile.Location);
    }

    [RelayCommand]
    private static void Close(Window? window) => window?.Close();

    private async Task LoadCellsAsync()
    {
        if (IsLoading)
            return;

        IsLoading = true;
        StatusMessage = $"{SelectedBank}열 셀 현황을 조회하는 중입니다.";

        try
        {
            var cells = await _api.GetRackCellsAsync(SelectedBank);
            BuildRack(cells ?? []);
            LoadedCellCount = cells?.Count ?? 0;
            StatusMessage = $"{SelectedBank}열 · {LoadedCellCount:N0}개 셀";
        }
        catch (Exception ex)
        {
            BuildRack([]);
            LoadedCellCount = 0;
            StatusMessage = $"{SelectedBank}열 조회에 실패했습니다.";
            _dialog.ShowMessage($"랙 셀 현황 조회 실패: {ex.Message}", "오류");
        }
        finally
        {
            IsLoading = false;
        }
    }

    private void BuildRack(IReadOnlyCollection<MonitoringRackCellDto> cells)
    {
        var lastBay = GetLastBay(SelectedBank);
        var cellsByCoordinate = cells
            .Select(cell => new
            {
                Cell = cell,
                Bay = ParseCoordinate(cell.Bay),
                Level = ParseCoordinate(cell.Level)
            })
            .Where(item => item.Bay is >= 1 and <= 15 && item.Level is >= 1 and <= LevelCount)
            .GroupBy(item => (item.Bay, item.Level))
            .ToDictionary(group => group.Key, group => group.First().Cell);

        BayHeaders.Clear();
        for (var bay = 1; bay <= lastBay; bay++)
            BayHeaders.Add(new RackBayHeader(bay, bay == _highlightedBay));

        LevelRows.Clear();
        for (var level = LevelCount; level >= 1; level--)
        {
            var tiles = new ObservableCollection<RackCellTile>();
            for (var bay = 1; bay <= lastBay; bay++)
            {
                cellsByCoordinate.TryGetValue((bay, level), out var cell);
                tiles.Add(RackCellTile.Create(
                    SelectedBank,
                    bay,
                    level,
                    cell,
                    bay == _highlightedBay));
            }

            LevelRows.Add(new RackLevelRow(level, tiles));
        }
    }

    private static int GetLastBay(int bank) => bank <= 2 ? 9 : 15;

    private static int ParseCoordinate(string? value) =>
        int.TryParse(value?.Trim(), out var number) ? number : 0;
}

public sealed record RackBayHeader(int Bay, bool IsSelected);

public sealed record RackLevelRow(
    int Level,
    ObservableCollection<RackCellTile> Cells);

public sealed record RackCellTile(
    string Location,
    string DisplayLocation,
    string Flag,
    string StatusName,
    string PalletNo,
    string InDate,
    string InTime,
    bool IsAvailable,
    bool IsSelectedBay)
{
    public static RackCellTile Create(
        int bank,
        int bay,
        int level,
        MonitoringRackCellDto? cell,
        bool isSelectedBay)
    {
        var fallbackLocation = $"{bank:00}{bay:00}{level:00}";
        var location = string.IsNullOrWhiteSpace(cell?.Location)
            ? fallbackLocation
            : cell.Location.Trim();

        return new RackCellTile(
            location,
            FormatLocation(location),
            cell?.Flag?.Trim().ToUpperInvariant() ?? string.Empty,
            cell is null ? "제외 셀" : ResolveStatusName(cell),
            cell?.PalletNo?.Trim() ?? string.Empty,
            FormatDate(cell?.InDate),
            FormatTime(cell?.InTime),
            cell is not null,
            isSelectedBay);
    }

    private static string ResolveStatusName(MonitoringRackCellDto cell)
    {
        if (!string.IsNullOrWhiteSpace(cell.StatusName))
            return cell.StatusName.Trim();

        return cell.Flag?.Trim().ToUpperInvariant() switch
        {
            "0" => "빈 셀",
            "1" => "적재",
            "X" => "입고 예약",
            "Y" => "출고 예약",
            "W" or "D" => "이중격납",
            "E" => "공출고",
            "N" => "사용금지",
            _ => "상태 미확인"
        };
    }

    private static string FormatLocation(string value) =>
        value.Length == 6
            ? $"{value[..2]}-{value.Substring(2, 2)}-{value.Substring(4, 2)}"
            : value;

    private static string FormatDate(string? value)
    {
        var text = value?.Trim() ?? string.Empty;
        return text.Length == 8
            ? $"{text[..4]}-{text.Substring(4, 2)}-{text.Substring(6, 2)}"
            : text;
    }

    private static string FormatTime(string? value)
    {
        var text = value?.Trim() ?? string.Empty;
        return text.Length == 6
            ? $"{text[..2]}:{text.Substring(2, 2)}:{text.Substring(4, 2)}"
            : text;
    }
}
