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
    private bool _isInitializing;
    private int _loadVersion;
    private CancellationTokenSource? _loadCancellation;

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(OpenCellCommand))]
    private int _selectedBank = FirstBank;

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(SearchCommand))]
    [NotifyCanExecuteChangedFor(nameof(OpenCellCommand))]
    private bool _isLoading;

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(OpenCellCommand))]
    private int _displayedBank;

    [ObservableProperty]
    private string _statusMessage = "열을 선택하면 자동으로 조회합니다.";

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
        _isInitializing = true;
        try
        {
            SelectedBank = Math.Clamp(bank, FirstBank, LastBank);
            var lastBay = GetLastBay(SelectedBank);
            _highlightedBay = selectedBay >= 1 && selectedBay <= lastBay
                ? selectedBay
                : 0;
        }
        finally
        {
            _isInitializing = false;
        }

        _ = LoadCellsAsync();
    }

    partial void OnSelectedBankChanged(int value)
    {
        if (_isInitializing)
            return;

        _highlightedBay = 0;
        _ = LoadCellsAsync();
    }

    public void RefreshForLocation(string location)
    {
        var normalized = location?.Trim() ?? string.Empty;
        if (normalized.Length != 6 || normalized.Any(character => character is < '0' or > '9'))
            return;

        if (int.TryParse(normalized.AsSpan(0, 2), out var bank) && bank == SelectedBank)
            _ = LoadCellsAsync();
    }

    private bool CanSearch() => !IsLoading;

    [RelayCommand(CanExecute = nameof(CanSearch), AllowConcurrentExecutions = true)]
    private async Task SearchAsync()
    {
        if (IsLoading)
            return;

        await LoadCellsAsync();
    }

    private bool CanOpenCell(RackCellTile? tile) =>
        !IsLoading && DisplayedBank == SelectedBank
        && tile is { IsAvailable: true } && !string.IsNullOrWhiteSpace(tile.Location);

    [RelayCommand(CanExecute = nameof(CanOpenCell))]
    private void OpenCell(RackCellTile? tile)
    {
        if (!CanOpenCell(tile))
            return;

        _windowService.ShowRackCellDetail(tile!.Location);
    }

    [RelayCommand]
    private static void Close(Window? window) => window?.Close();

    private async Task LoadCellsAsync()
    {
        var bank = SelectedBank;
        var version = ++_loadVersion;
        var cancellation = new CancellationTokenSource();
        var previous = _loadCancellation;
        _loadCancellation = cancellation;
        previous?.Cancel();

        IsLoading = true;
        StatusMessage = DisplayedBank > 0 && DisplayedBank != bank
            ? $"{bank}열 조회 중 · {DisplayedBank}열 화면 유지"
            : $"{bank}열 셀 현황을 조회하는 중입니다.";

        try
        {
            var cells = await _api.GetRackCellsAsync(bank, cancellation.Token);
            if (version != _loadVersion)
                return;

            BuildRack(bank, cells ?? []);
            DisplayedBank = bank;
            LoadedCellCount = cells?.Count ?? 0;
            StatusMessage = $"{bank}열 · {LoadedCellCount:N0}개 셀";
        }
        catch (OperationCanceledException) when (cancellation.IsCancellationRequested)
        {
        }
        catch (Exception ex)
        {
            if (version != _loadVersion)
                return;

            StatusMessage = DisplayedBank > 0
                ? $"{bank}열 조회 실패 · {DisplayedBank}열 화면 유지"
                : $"{bank}열 조회에 실패했습니다.";
            _dialog.ShowMessage($"랙 셀 현황 조회 실패: {ex.Message}", "오류");
        }
        finally
        {
            if (version == _loadVersion)
            {
                _loadCancellation = null;
                IsLoading = false;
            }

            cancellation.Dispose();
        }
    }

    private void BuildRack(int bank, IReadOnlyCollection<MonitoringRackCellDto> cells)
    {
        var lastBay = GetLastBay(bank);
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

        while (BayHeaders.Count > lastBay)
            BayHeaders.RemoveAt(BayHeaders.Count - 1);

        for (var bay = 1; bay <= lastBay; bay++)
        {
            var header = new RackBayHeader(bay, bay == _highlightedBay);
            if (BayHeaders.Count < bay)
                BayHeaders.Add(header);
            else if (BayHeaders[bay - 1] != header)
                BayHeaders[bay - 1] = header;
        }

        for (var level = LevelCount; level >= 1; level--)
        {
            var rowIndex = LevelCount - level;
            if (LevelRows.Count <= rowIndex)
                LevelRows.Add(new RackLevelRow(level, []));

            var tiles = LevelRows[rowIndex].Cells;
            while (tiles.Count > lastBay)
                tiles.RemoveAt(tiles.Count - 1);

            for (var bay = 1; bay <= lastBay; bay++)
            {
                cellsByCoordinate.TryGetValue((bay, level), out var cell);
                var tile = RackCellTile.Create(
                    bank,
                    bay,
                    level,
                    cell,
                    bay == _highlightedBay);
                if (tiles.Count < bay)
                    tiles.Add(tile);
                else
                    tiles[bay - 1].UpdateFrom(tile);
            }
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

public sealed partial class RackCellTile : ObservableObject
{
    [ObservableProperty] private string _location;
    [ObservableProperty] private string _displayLocation;
    [ObservableProperty] private string _flag;
    [ObservableProperty] private string _statusName;
    [ObservableProperty] private string _palletNo;
    [ObservableProperty] private string _inDate;
    [ObservableProperty] private string _inTime;
    [ObservableProperty] private bool _isAvailable;
    [ObservableProperty] private bool _isSelectedBay;

    public RackCellTile(
        string location,
        string displayLocation,
        string flag,
        string statusName,
        string palletNo,
        string inDate,
        string inTime,
        bool isAvailable,
        bool isSelectedBay)
    {
        _location = location;
        _displayLocation = displayLocation;
        _flag = flag;
        _statusName = statusName;
        _palletNo = palletNo;
        _inDate = inDate;
        _inTime = inTime;
        _isAvailable = isAvailable;
        _isSelectedBay = isSelectedBay;
    }

    internal void UpdateFrom(RackCellTile tile)
    {
        Location = tile.Location;
        DisplayLocation = tile.DisplayLocation;
        Flag = tile.Flag;
        StatusName = tile.StatusName;
        PalletNo = tile.PalletNo;
        InDate = tile.InDate;
        InTime = tile.InTime;
        IsAvailable = tile.IsAvailable;
        IsSelectedBay = tile.IsSelectedBay;
    }

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
