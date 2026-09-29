using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using System.Windows;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Monitoring;

namespace TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

public partial class RackCellDetailViewModel : ObservableObject
{
    private readonly ISc1LineApi _api;
    private readonly IDialogService _dialog;

    [ObservableProperty]
    private string _location = string.Empty;

    [ObservableProperty]
    private string _displayLocation = string.Empty;

    [ObservableProperty]
    private string _cellFlag = string.Empty;

    [ObservableProperty]
    private string _cellStatusName = "조회 대기";

    [ObservableProperty]
    private string _cellPalletNo = string.Empty;

    [ObservableProperty]
    private string _cellInboundAt = string.Empty;

    [ObservableProperty]
    private bool _isLoading;

    [ObservableProperty]
    private string _statusMessage = "셀 정보를 조회하세요.";

    [ObservableProperty]
    private int _inventoryCount;

    public RackCellDetailViewModel(ISc1LineApi api, IDialogService dialog)
    {
        _api = api;
        _dialog = dialog;
    }

    public ObservableCollection<RackInventoryRow> InventoryItems { get; } = [];

    public void Initialize(string location)
    {
        Location = NormalizeLocation(location);
        DisplayLocation = FormatLocation(Location);
        _ = LoadDetailAsync();
    }

    [RelayCommand]
    private async Task SearchAsync()
    {
        if (IsLoading)
            return;

        await LoadDetailAsync();
    }

    [RelayCommand]
    private static void Close(Window? window) => window?.Close();

    private async Task LoadDetailAsync()
    {
        if (IsLoading)
            return;

        if (Location.Length != 6 || Location.Any(character => !char.IsDigit(character)))
        {
            ClearDetail();
            StatusMessage = "저장위치는 BBYYLL 형식의 숫자 6자리여야 합니다.";
            return;
        }

        IsLoading = true;
        StatusMessage = $"{DisplayLocation} 셀 정보를 조회하는 중입니다.";

        try
        {
            var detail = await _api.GetRackCellDetailAsync(Location);
            if (detail is null)
            {
                ClearDetail();
                StatusMessage = $"{DisplayLocation} 저장위치를 찾을 수 없습니다.";
                return;
            }

            ApplyDetail(detail);
            StatusMessage = $"{DisplayLocation} · 재고 {InventoryCount:N0}건";
        }
        catch (Exception ex)
        {
            ClearDetail();
            StatusMessage = $"{DisplayLocation} 조회에 실패했습니다.";
            _dialog.ShowMessage($"셀 정보 조회 실패: {ex.Message}", "오류");
        }
        finally
        {
            IsLoading = false;
        }
    }

    private void ApplyDetail(MonitoringRackCellDetailDto detail)
    {
        var cell = detail.Cell ?? new MonitoringRackCellDto { Location = Location };
        if (!string.IsNullOrWhiteSpace(cell.Location))
        {
            Location = NormalizeLocation(cell.Location);
            DisplayLocation = FormatLocation(Location);
        }

        CellFlag = cell.Flag?.Trim().ToUpperInvariant() ?? string.Empty;
        CellStatusName = string.IsNullOrWhiteSpace(cell.StatusName)
            ? ResolveStatusName(CellFlag)
            : cell.StatusName.Trim();
        CellPalletNo = cell.PalletNo?.Trim() ?? string.Empty;

        var inDate = FormatDate(cell.InDate);
        var inTime = FormatTime(cell.InTime);
        CellInboundAt = string.Join(" ", new[] { inDate, inTime }
            .Where(value => !string.IsNullOrWhiteSpace(value)));

        InventoryItems.Clear();
        foreach (var item in detail.InventoryItems ?? [])
            InventoryItems.Add(RackInventoryRow.From(item));

        InventoryCount = InventoryItems.Count;
    }

    private void ClearDetail()
    {
        CellFlag = string.Empty;
        CellStatusName = "조회 정보 없음";
        CellPalletNo = string.Empty;
        CellInboundAt = string.Empty;
        InventoryItems.Clear();
        InventoryCount = 0;
    }

    private static string NormalizeLocation(string? value) =>
        (value ?? string.Empty).Trim().Replace("-", string.Empty);

    private static string FormatLocation(string value) =>
        value.Length == 6
            ? $"{value[..2]}-{value.Substring(2, 2)}-{value.Substring(4, 2)}"
            : value;

    private static string ResolveStatusName(string flag) => flag switch
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

    internal static string FormatDate(string? value)
    {
        var text = value?.Trim() ?? string.Empty;
        return text.Length == 8
            ? $"{text[..4]}-{text.Substring(4, 2)}-{text.Substring(6, 2)}"
            : text;
    }

    internal static string FormatTime(string? value)
    {
        var text = value?.Trim() ?? string.Empty;
        return text.Length == 6
            ? $"{text[..2]}:{text.Substring(2, 2)}:{text.Substring(4, 2)}"
            : text;
    }
}

public sealed record RackInventoryRow(
    string Flag,
    string PalletNo,
    string ItemCode,
    string ItemName,
    string LotNo,
    decimal Quantity,
    decimal ReservedQuantity,
    string BoxNo,
    string Remark,
    string InDate,
    string InTime)
{
    public static RackInventoryRow From(MonitoringRackInventoryDto item) => new(
        item.Flag?.Trim() ?? string.Empty,
        item.PalletNo?.Trim() ?? string.Empty,
        item.ItemCode?.Trim() ?? string.Empty,
        item.ItemName?.Trim() ?? string.Empty,
        item.LotNo?.Trim() ?? string.Empty,
        item.Quantity,
        item.ReservedQuantity,
        item.BoxNo?.Trim() ?? string.Empty,
        item.Remark?.Trim() ?? string.Empty,
        RackCellDetailViewModel.FormatDate(item.InDate),
        RackCellDetailViewModel.FormatTime(item.InTime));
}
