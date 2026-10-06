using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Globalization;
using System.Windows;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Monitoring;
using TOK.WMS.UI.Services.Api.Standards;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.Services.Interfaces.Popup;

namespace TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

public partial class RackInventoryEditViewModel : ObservableObject
{
    private readonly ISc1LineApi _api;
    private readonly IDialogService _dialog;
    private readonly IWindowService _windows;
    private readonly IMastDispApi _mastApi;
    private readonly ICurrentUserService _currentUser;
    private MonitoringRackInventoryDto? _original;
    private string _location = string.Empty;
    private bool _isInitializing;

    [ObservableProperty] private string _displayLocation = string.Empty;
    [ObservableProperty] private string _selectedFlag = "1";
    [ObservableProperty] private string _palletNo = string.Empty;
    [ObservableProperty] private string _itemCode = string.Empty;
    [ObservableProperty] private string _itemName = string.Empty;
    [ObservableProperty] private string _lotNo = string.Empty;
    [ObservableProperty] private string _quantity = "0";
    [ObservableProperty] private string _reservedQuantity = "0";
    [ObservableProperty] private string _boxNo = string.Empty;
    [ObservableProperty] private string _remark = string.Empty;
    [ObservableProperty] private DateTime? _inDate;
    [ObservableProperty] private string _inTime = string.Empty;
    [ObservableProperty] private string _statusMessage = "재고 정보를 입력한 뒤 확정하세요.";

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(Title))]
    [NotifyCanExecuteChangedFor(nameof(ItemSearchCommand))]
    private bool _isEditing;

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(IsNotSaving))]
    [NotifyCanExecuteChangedFor(nameof(ConfirmCommand))]
    [NotifyCanExecuteChangedFor(nameof(CloseCommand))]
    [NotifyCanExecuteChangedFor(nameof(ItemSearchCommand))]
    private bool _isSaving;

    public RackInventoryEditViewModel(
        ISc1LineApi api,
        IDialogService dialog,
        IWindowService windows,
        IMastDispApi mastApi,
        ICurrentUserService currentUser)
    {
        _api = api;
        _dialog = dialog;
        _windows = windows;
        _mastApi = mastApi;
        _currentUser = currentUser;
    }

    public IReadOnlyList<RackInventoryFlagOption> FlagOptions { get; } =
    [
        new("1", "1 - 적재"),
        new("X", "X - 입고 예약"),
        new("Y", "Y - 출고 예약"),
        new("W", "W - 이중격납"),
        new("E", "E - 공출고"),
        new("N", "N - 사용금지")
    ];

    public string Title => IsEditing ? "재고 수정" : "재고 등록";
    public bool IsNotSaving => !IsSaving;
    public bool IsSaved { get; private set; }

    public void Initialize(string location, MonitoringRackInventoryDto? original = null)
    {
        if (IsSaving)
            return;

        _isInitializing = true;
        try
        {
            _location = (location ?? string.Empty).Trim().Replace("-", string.Empty);
            DisplayLocation = _location.Length == 6
                ? $"{_location[..2]}-{_location.Substring(2, 2)}-{_location.Substring(4, 2)}"
                : _location;
            _original = original is null ? null : Copy(original);
            IsEditing = _original is not null;
            IsSaved = false;

            SelectedFlag = string.IsNullOrWhiteSpace(_original?.Flag)
                ? "1"
                : _original.Flag.Trim().ToUpperInvariant();
            // 레거시처럼 재고가 있는 행의 빈 셀 상태는 적재로 표시한다.
            if (SelectedFlag == "0")
                SelectedFlag = "1";
            // W/D는 같은 이중격납 상태이며 편집에는 W를 사용한다.
            if (SelectedFlag == "D")
                SelectedFlag = "W";
            PalletNo = _original?.PalletNo?.Trim() ?? string.Empty;
            ItemCode = _original?.ItemCode?.Trim() ?? string.Empty;
            ItemName = _original?.ItemName?.Trim() ?? string.Empty;
            LotNo = _original?.LotNo?.Trim() ?? string.Empty;
            Quantity = (_original?.Quantity ?? 0).ToString("0.##", CultureInfo.InvariantCulture);
            ReservedQuantity = (_original?.ReservedQuantity ?? 0).ToString("0.##", CultureInfo.InvariantCulture);
            BoxNo = _original?.BoxNo?.Trim() ?? string.Empty;
            Remark = _original?.Remark?.Trim() ?? string.Empty;
            InDate = _original is null ? DateTime.Today : ParseDate(_original.InDate);
            InTime = _original is null
                ? DateTime.Now.ToString("HH:mm:ss", CultureInfo.InvariantCulture)
                : FormatTime(_original.InTime);
            StatusMessage = IsEditing
                ? "선택한 재고를 수정합니다. 품번코드와 LOT-NO는 변경할 수 없습니다."
                : "재고 정보를 입력한 뒤 확정하세요.";
        }
        finally
        {
            _isInitializing = false;
        }

        ConfirmCommand.NotifyCanExecuteChanged();
        CloseCommand.NotifyCanExecuteChanged();
        ItemSearchCommand.NotifyCanExecuteChanged();
    }

    partial void OnItemCodeChanged(string value)
    {
        if (!_isInitializing)
            ItemName = string.Empty;
    }

    private bool CanConfirm() => !IsSaving && !IsSaved;
    private bool CanClose() => !IsSaving;
    private bool CanSearchItem() => !IsEditing && !IsSaving && !IsSaved;

    [RelayCommand(CanExecute = nameof(CanSearchItem))]
    private void ItemSearch()
    {
        if (!CanSearchItem())
            return;

        try
        {
            var item = _windows.ShowMastDisp(ItemCode?.Trim() ?? string.Empty);
            if (item is null)
                return;

            ItemCode = item.MastCode?.Trim() ?? string.Empty;
            ItemName = item.MastName?.Trim() ?? string.Empty;
        }
        catch (Exception ex)
        {
            ReportError($"품번 조회 실패: {ex.Message}");
        }
    }

    [RelayCommand(CanExecute = nameof(CanConfirm))]
    private async Task ConfirmAsync(Window? window)
    {
        if (!CanConfirm())
            return;

        IsSaving = true;
        StatusMessage = "입력 정보를 확인하는 중입니다.";
        try
        {
            if (!TryCreateItem(out var item, out var error))
            {
                ReportError(error);
                return;
            }

            var matches = await _mastApi.SearchAsync(new MastDispDto.ReqDto { SearchText = item.ItemCode });
            var master = matches?.FirstOrDefault(candidate =>
                string.Equals(candidate.MastCode?.Trim(), item.ItemCode, StringComparison.OrdinalIgnoreCase));
            if (master is null)
            {
                ReportError("등록된 품번코드가 아닙니다. 품번을 조회한 뒤 다시 확정하세요.");
                return;
            }

            ItemName = master.MastName?.Trim() ?? string.Empty;
            item.ItemName = ItemName;
            var request = new MonitoringRackInventorySaveRequest
            {
                Item = item,
                Original = _original is null ? null : Copy(_original),
                UserId = _currentUser.User?.UserId ?? string.Empty
            };

            StatusMessage = IsEditing ? "재고를 수정하는 중입니다." : "재고를 등록하는 중입니다.";
            if (IsEditing)
                await _api.UpdateRackInventoryAsync(_location, request);
            else
                await _api.AddRackInventoryAsync(_location, request);

            IsSaved = true;
            ConfirmCommand.NotifyCanExecuteChanged();
            ItemSearchCommand.NotifyCanExecuteChanged();
            StatusMessage = IsEditing ? "재고 수정이 완료되었습니다." : "재고 등록이 완료되었습니다.";
            window?.Close();
        }
        catch (Exception ex)
        {
            ReportError($"재고 {(IsEditing ? "수정" : "등록")} 실패: {ex.Message}");
        }
        finally
        {
            IsSaving = false;
        }
    }

    [RelayCommand(CanExecute = nameof(CanClose))]
    private void Close(Window? window)
    {
        if (CanClose())
            window?.Close();
    }

    private bool TryCreateItem(out MonitoringRackInventoryDto item, out string error)
    {
        item = new MonitoringRackInventoryDto();
        error = string.Empty;
        var normalizedTime = InTime?.Trim() ?? string.Empty;
        if (_location.Length != 6 || _location.Any(character => character is < '0' or > '9'))
            error = "저장위치는 숫자 6자리여야 합니다.";
        else if (!FlagOptions.Any(option => option.Code == SelectedFlag))
            error = "상태를 선택하세요.";
        else if (!ValidText(PalletNo, 12, required: true))
            error = "PLT-NO는 1~12자로 입력하세요.";
        else if (!ValidText(ItemCode, 18, required: true))
            error = "품번코드는 1~18자로 입력하세요.";
        else if (!ValidText(LotNo, 20))
            error = "LOT-NO는 20자 이내로 입력하세요.";
        else if (!ValidText(BoxNo, 30))
            error = "BOX-NO는 30자 이내로 입력하세요.";
        else if (!ValidText(Remark, 30))
            error = "비고는 30자 이내로 입력하세요.";
        else if (_original is not null
            && (!string.Equals(ItemCode.Trim(), _original.ItemCode?.Trim(), StringComparison.Ordinal)
                || !string.Equals(LotNo.Trim(), _original.LotNo?.Trim(), StringComparison.Ordinal)))
            error = "수정할 때 품번코드와 LOT-NO는 변경할 수 없습니다.";
        else if (!TryQuantity(Quantity, out _))
            error = "재고수량은 0~99999.99 범위에서 소수 둘째 자리까지 입력하세요.";
        else if (!TryQuantity(ReservedQuantity, out _))
            error = "예약수량은 0~99999.99 범위에서 소수 둘째 자리까지 입력하세요.";
        else if (InDate is null)
            error = "입고일자를 선택하세요.";
        else if (!TimeOnly.TryParseExact(normalizedTime, "HH:mm:ss", CultureInfo.InvariantCulture,
            DateTimeStyles.None, out _))
            error = "입고시간은 HH:mm:ss 형식으로 입력하세요.";

        if (error.Length > 0)
            return false;

        TryQuantity(Quantity, out var quantity);
        TryQuantity(ReservedQuantity, out var reservedQuantity);
        if (reservedQuantity > quantity)
        {
            error = "예약수량은 재고수량보다 클 수 없습니다.";
            return false;
        }

        var time = TimeOnly.ParseExact(normalizedTime, "HH:mm:ss", CultureInfo.InvariantCulture);
        item = new MonitoringRackInventoryDto
        {
            Flag = SelectedFlag,
            PalletNo = PalletNo.Trim(),
            ItemCode = ItemCode.Trim(),
            ItemName = ItemName?.Trim() ?? string.Empty,
            LotNo = LotNo?.Trim() ?? string.Empty,
            Quantity = quantity,
            ReservedQuantity = reservedQuantity,
            BoxNo = BoxNo?.Trim() ?? string.Empty,
            Remark = Remark?.Trim() ?? string.Empty,
            InDate = InDate!.Value.ToString("yyyyMMdd", CultureInfo.InvariantCulture),
            InTime = time.ToString("HHmmss", CultureInfo.InvariantCulture)
        };
        return true;
    }

    private void ReportError(string message)
    {
        StatusMessage = message;
        _dialog.ShowMessage(message, "확인");
    }

    private static bool ValidText(string? value, int maximumLength, bool required = false)
    {
        var text = value?.Trim() ?? string.Empty;
        return text.Length <= maximumLength && (!required || text.Length > 0);
    }

    private static bool TryQuantity(string? text, out decimal value)
    {
        var normalized = text?.Trim() ?? string.Empty;
        if (!decimal.TryParse(normalized, NumberStyles.AllowDecimalPoint | NumberStyles.AllowLeadingSign,
                CultureInfo.InvariantCulture, out value)
            || value is < 0 or > 99999.99m)
            return false;

        var separator = normalized.IndexOf('.');
        return separator < 0 || normalized.Length - separator - 1 <= 2;
    }

    private static DateTime? ParseDate(string? value) =>
        DateTime.TryParseExact(value?.Trim(), ["yyyyMMdd", "yyyy-MM-dd"], CultureInfo.InvariantCulture,
            DateTimeStyles.None, out var date) ? date.Date : null;

    private static string FormatTime(string? value)
    {
        var text = value?.Trim() ?? string.Empty;
        return text.Length == 6
            ? $"{text[..2]}:{text.Substring(2, 2)}:{text.Substring(4, 2)}"
            : text;
    }

    private static MonitoringRackInventoryDto Copy(MonitoringRackInventoryDto item) => new()
    {
        Flag = item.Flag,
        PalletNo = item.PalletNo,
        ItemCode = item.ItemCode,
        ItemName = item.ItemName,
        LotNo = item.LotNo,
        Quantity = item.Quantity,
        ReservedQuantity = item.ReservedQuantity,
        BoxNo = item.BoxNo,
        Remark = item.Remark,
        InDate = item.InDate,
        InTime = item.InTime
    };
}

public sealed record RackInventoryFlagOption(string Code, string Name);
