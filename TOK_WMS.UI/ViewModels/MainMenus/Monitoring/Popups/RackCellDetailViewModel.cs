using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using System.Windows;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Monitoring;
using TOK.WMS.UI.Services.Interfaces.Popup;

namespace TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

public partial class RackCellDetailViewModel : ObservableObject
{
    private readonly ISc1LineApi _api;
    private readonly IDialogService _dialog;
    private readonly IWindowService _windows;

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(ProhibitCommand))]
    [NotifyCanExecuteChangedFor(nameof(EnableCommand))]
    [NotifyCanExecuteChangedFor(nameof(AddCommand))]
    [NotifyCanExecuteChangedFor(nameof(EditCommand))]
    [NotifyCanExecuteChangedFor(nameof(DeleteCommand))]
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
    [NotifyCanExecuteChangedFor(nameof(SearchCommand))]
    [NotifyCanExecuteChangedFor(nameof(ProhibitCommand))]
    [NotifyCanExecuteChangedFor(nameof(EnableCommand))]
    [NotifyCanExecuteChangedFor(nameof(AddCommand))]
    [NotifyCanExecuteChangedFor(nameof(EditCommand))]
    [NotifyCanExecuteChangedFor(nameof(DeleteCommand))]
    private bool _isLoading;

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(CloseCommand))]
    private bool _isMutating;

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(ProhibitCommand))]
    [NotifyCanExecuteChangedFor(nameof(EnableCommand))]
    [NotifyCanExecuteChangedFor(nameof(AddCommand))]
    [NotifyCanExecuteChangedFor(nameof(EditCommand))]
    [NotifyCanExecuteChangedFor(nameof(DeleteCommand))]
    private bool _hasCellDetail;

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(EditCommand))]
    [NotifyCanExecuteChangedFor(nameof(DeleteCommand))]
    private RackInventoryRow? _selectedInventoryItem;

    [ObservableProperty]
    private string _statusMessage = "셀 정보를 조회하세요.";

    [ObservableProperty]
    private int _inventoryCount;

    public RackCellDetailViewModel(ISc1LineApi api, IDialogService dialog, IWindowService windows)
    {
        _api = api;
        _dialog = dialog;
        _windows = windows;
    }

    public ObservableCollection<RackInventoryRow> InventoryItems { get; } = [];

    public event Action<string>? CellUsageChanged;

    public void Initialize(string location)
    {
        Location = NormalizeLocation(location);
        DisplayLocation = FormatLocation(Location);
        _ = LoadDetailAsync();
    }

    [RelayCommand(CanExecute = nameof(CanSearch))]
    private async Task SearchAsync()
    {
        if (IsLoading)
            return;

        await LoadDetailAsync();
    }

    private bool CanSearch() => !IsLoading;

    private bool CanChangeCellUsage() =>
        !IsLoading && HasCellDetail && Location.Length == 6
        && Location.All(character => character is >= '0' and <= '9');

    [RelayCommand(CanExecute = nameof(CanChangeCellUsage))]
    private Task ProhibitAsync() => ChangeCellUsageAsync(isProhibited: true);

    [RelayCommand(CanExecute = nameof(CanChangeCellUsage))]
    private Task EnableAsync() => ChangeCellUsageAsync(isProhibited: false);

    [RelayCommand(CanExecute = nameof(CanChangeCellUsage))]
    private Task AddAsync(Window? owner) => EditInventoryAsync(null, owner);

    private bool CanEditInventory() => CanChangeCellUsage()
        && SelectedInventoryItem is not null && InventoryItems.Contains(SelectedInventoryItem);

    [RelayCommand(CanExecute = nameof(CanEditInventory))]
    private Task EditAsync(Window? owner) => CanEditInventory()
        ? EditInventoryAsync(SelectedInventoryItem!.ToDto(), owner)
        : Task.CompletedTask;

    private async Task EditInventoryAsync(MonitoringRackInventoryDto? original, Window? owner)
    {
        if (!CanChangeCellUsage())
            return;

        var actionName = original is null ? "등록" : "수정";
        var location = Location;
        var previousStatus = StatusMessage;
        IsLoading = true;
        IsMutating = true;
        try
        {
            StatusMessage = $"재고 {actionName} 화면에서 값을 입력하세요.";
            if (!_windows.ShowRackInventoryEdit(location, original, owner))
            {
                StatusMessage = previousStatus;
                return;
            }

            await RefreshAfterInventoryChangeAsync(location, actionName);
        }
        catch (Exception ex)
        {
            StatusMessage = $"재고 {actionName} 화면을 열지 못했습니다.";
            _dialog.ShowWarning($"재고 {actionName} 화면 오류: {ex.Message}", "오류");
        }
        finally
        {
            IsMutating = false;
            IsLoading = false;
        }
    }

    [RelayCommand(CanExecute = nameof(CanEditInventory))]
    private async Task DeleteAsync()
    {
        if (!CanEditInventory())
            return;

        var original = SelectedInventoryItem!.ToDto();
        var location = Location;
        if (!_dialog.ShowConfirm(
                $"{DisplayLocation} 셀의 선택한 재고를 삭제하시겠습니까?\n"
                + $"PLT-NO: {original.PalletNo}\n품번: {original.ItemCode}\nLOT-NO: {original.LotNo}",
                "재고 삭제 확인"))
            return;

        IsLoading = true;
        IsMutating = true;
        StatusMessage = "선택한 재고를 삭제하는 중입니다.";
        try
        {
            await _api.DeleteRackInventoryAsync(location,
                new MonitoringRackInventoryDeleteRequest { Original = original });
            await RefreshAfterInventoryChangeAsync(location, "삭제");
        }
        catch (Exception ex)
        {
            StatusMessage = "재고 삭제에 실패했습니다. 조회 후 다시 확인하세요.";
            _dialog.ShowWarning($"재고 삭제 실패: {ex.Message}", "오류");
        }
        finally
        {
            IsMutating = false;
            IsLoading = false;
        }
    }

    private async Task RefreshAfterInventoryChangeAsync(string location, string actionName)
    {
        CellUsageChanged?.Invoke(location);
        IsMutating = false;
        try
        {
            var detail = await _api.GetRackCellDetailAsync(location);
            if (detail is null)
                throw new InvalidOperationException("저장위치를 찾을 수 없습니다.");

            ApplyDetail(detail);
            StatusMessage = $"재고 {actionName} 완료 · 재고 {InventoryCount:N0}건";
        }
        catch (Exception ex)
        {
            ClearDetail();
            StatusMessage = $"재고 {actionName} 완료 · 재조회에 실패했습니다.";
            _dialog.ShowWarning(
                $"재고 {actionName}은 완료했지만 재조회에 실패했습니다. 조회 버튼으로 확인하세요.\n{ex.Message}",
                "재조회 오류");
        }
    }

    private bool CanClose() => !IsMutating;

    [RelayCommand(CanExecute = nameof(CanClose))]
    private void Close(Window? window)
    {
        if (CanClose())
            window?.Close();
    }

    private async Task ChangeCellUsageAsync(bool isProhibited)
    {
        if (!CanChangeCellUsage())
            return;

        var actionName = isProhibited ? "금지" : "사용";
        if (!_dialog.ShowConfirm(
                $"{DisplayLocation} 셀을 {actionName} 처리하시겠습니까?",
                $"셀 {actionName} 확인"))
        {
            return;
        }

        var location = Location;
        var displayLocation = DisplayLocation;
        var saved = false;
        IsLoading = true;
        IsMutating = true;
        StatusMessage = $"{displayLocation} 셀 {actionName} 처리 중입니다.";

        try
        {
            await _api.SetRackCellUsageAsync(location, isProhibited);
            saved = true;
            CellUsageChanged?.Invoke(location);
            IsMutating = false;

            var detail = await _api.GetRackCellDetailAsync(location);
            if (detail is null)
            {
                ClearDetail();
                StatusMessage = $"{displayLocation} 셀 {actionName} 처리는 완료했지만 저장위치를 찾을 수 없습니다.";
                return;
            }

            ApplyDetail(detail);
            StatusMessage = $"{displayLocation} 셀 {actionName} 처리 완료 · 재고 {InventoryCount:N0}건";
        }
        catch (Exception ex)
        {
            ClearDetail();
            StatusMessage = saved
                ? $"{displayLocation} 셀 {actionName} 처리 완료 · 재조회에 실패했습니다."
                : $"{displayLocation} 셀 {actionName} 처리에 실패했습니다.";
            _dialog.ShowWarning(
                saved
                    ? $"셀 {actionName} 저장은 완료했지만 재조회에 실패했습니다. 조회 버튼으로 확인하세요.\n{ex.Message}"
                    : $"셀 {actionName} 처리 실패: {ex.Message}",
                "오류");
        }
        finally
        {
            IsMutating = false;
            IsLoading = false;
        }
    }

    private async Task LoadDetailAsync()
    {
        if (IsLoading)
            return;

        if (Location.Length != 6 || Location.Any(character => character is < '0' or > '9'))
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
            _dialog.ShowWarning($"셀 정보 조회 실패: {ex.Message}", "오류");
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

        var selected = SelectedInventoryItem;
        SelectedInventoryItem = null;
        InventoryItems.Clear();
        foreach (var item in detail.InventoryItems ?? [])
            InventoryItems.Add(RackInventoryRow.From(item));

        SelectedInventoryItem = InventoryItems.FirstOrDefault(item => selected is not null
            && item.PalletNo == selected.PalletNo && item.ItemCode == selected.ItemCode
            && item.LotNo == selected.LotNo) ?? InventoryItems.FirstOrDefault();

        InventoryCount = InventoryItems.Count;
        HasCellDetail = true;
    }

    private void ClearDetail()
    {
        HasCellDetail = false;
        CellFlag = string.Empty;
        CellStatusName = "조회 정보 없음";
        CellPalletNo = string.Empty;
        CellInboundAt = string.Empty;
        SelectedInventoryItem = null;
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
    private string? OriginalInDate { get; init; }
    private string? OriginalInTime { get; init; }

    public MonitoringRackInventoryDto ToDto() => new()
    {
        Flag = Flag,
        PalletNo = PalletNo,
        ItemCode = ItemCode,
        ItemName = ItemName,
        LotNo = LotNo,
        Quantity = Quantity,
        ReservedQuantity = ReservedQuantity,
        BoxNo = BoxNo,
        Remark = Remark,
        InDate = OriginalInDate ?? InDate.Replace("-", string.Empty),
        InTime = OriginalInTime ?? InTime.Replace(":", string.Empty)
    };

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
        RackCellDetailViewModel.FormatTime(item.InTime))
    {
        // 표시 형식과 별도로 원본을 보관해 기존의 불완전한 일시도 정확히 비교한다.
        OriginalInDate = item.InDate?.Trim() ?? string.Empty,
        OriginalInTime = item.InTime?.Trim() ?? string.Empty
    };
}
