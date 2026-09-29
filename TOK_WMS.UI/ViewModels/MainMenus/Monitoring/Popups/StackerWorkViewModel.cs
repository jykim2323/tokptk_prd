using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Windows;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Monitoring;

namespace TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

public partial class StackerWorkViewModel : ObservableObject
{
    private readonly ISc1LineApi _api;
    private readonly IDialogService _dialog;

    public StackerWorkViewModel(ISc1LineApi api, IDialogService dialog)
    {
        _api = api;
        _dialog = dialog;
    }

    public IReadOnlyList<int> CraneNumbers { get; } = [1, 2, 3, 4, 5, 6, 7];

    [ObservableProperty]
    private int _selectedCraneNo = 1;

    [ObservableProperty]
    private MonitoringStackerWorkDto _current = new() { CraneNo = 1 };

    [ObservableProperty]
    private string _locationDisplay = "-";

    [ObservableProperty]
    private string _positionDisplay = "-";

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(CanInteract))]
    private bool _isBusy;

    [ObservableProperty]
    private string _statusMessage = "조회 대기 중";

    public bool CanInteract => !IsBusy;

    public void Initialize(int craneNo)
    {
        ValidateCraneNo(craneNo);
        SelectedCraneNo = craneNo;
        ClearCurrent(craneNo);
        StatusMessage = $"{craneNo}호기 조회 대기 중";
    }

    public Task LoadAsync() => SearchAsync();

    partial void OnSelectedCraneNoChanged(int value)
    {
        ClearCurrent(value);
        StatusMessage = $"{value}호기를 조회해 주세요.";
    }

    [RelayCommand]
    private async Task SearchAsync()
    {
        if (IsBusy)
            return;

        var craneNo = SelectedCraneNo;
        IsBusy = true;
        StatusMessage = $"{craneNo}호기 조회 중...";

        try
        {
            var item = await _api.GetStackerWorkAsync(craneNo);
            if (item is null)
            {
                ClearCurrent(craneNo);
                StatusMessage = $"{craneNo}호기 상태 정보가 없습니다.";
                _dialog.ShowMessage(StatusMessage, "조회 결과");
                return;
            }

            Apply(item);
            StatusMessage = $"{craneNo}호기 조회 완료";
        }
        catch (Exception ex)
        {
            StatusMessage = $"{craneNo}호기 조회 실패";
            _dialog.ShowMessage($"스태커 크레인 상태 조회에 실패했습니다.\n{ex.Message}", "오류");
        }
        finally
        {
            IsBusy = false;
        }
    }

    [RelayCommand]
    private async Task ReissueAsync(Window? owner)
    {
        if (IsBusy)
            return;

        const string message =
            "S/C Fork에 제품이 있습니까?\n\n" +
            "[예] 제품 있음    [아니요] 제품 없음    [취소] 작업 취소";

        var result = owner is null
            ? MessageBox.Show(
                message,
                "재지시 확인",
                MessageBoxButton.YesNoCancel,
                MessageBoxImage.Question,
                MessageBoxResult.Cancel)
            : MessageBox.Show(
                owner,
                message,
                "재지시 확인",
                MessageBoxButton.YesNoCancel,
                MessageBoxImage.Question,
                MessageBoxResult.Cancel);

        if (result == MessageBoxResult.Cancel)
            return;

        await RunActionAsync(
            "재지시",
            () => _api.ReissueStackerAsync(
                SelectedCraneNo,
                result == MessageBoxResult.Yes));
    }

    [RelayCommand]
    private async Task CompleteAsync()
    {
        if (IsBusy || !_dialog.ShowConfirm(
                $"{SelectedCraneNo}호기 작업을 완료 처리하시겠습니까?",
                "작업완료 확인"))
        {
            return;
        }

        await RunActionAsync(
            "작업완료",
            () => _api.CompleteStackerAsync(SelectedCraneNo));
    }

    [RelayCommand]
    private async Task ForceDeleteAsync()
    {
        if (IsBusy || !_dialog.ShowConfirm(
                $"{SelectedCraneNo}호기 작업 상태와 PLC 송신 버퍼를 강제로 초기화하시겠습니까?",
                "강제삭제 확인"))
        {
            return;
        }

        await RunActionAsync(
            "강제삭제",
            () => _api.ForceDeleteStackerAsync(SelectedCraneNo));
    }

    [RelayCommand]
    private async Task ClearErrorAsync()
    {
        if (IsBusy || !_dialog.ShowConfirm(
                $"{SelectedCraneNo}호기 에러를 해제하시겠습니까?",
                "에러해제 확인"))
        {
            return;
        }

        await RunActionAsync(
            "에러해제",
            () => _api.ClearStackerErrorAsync(SelectedCraneNo));
    }

    [RelayCommand]
    private void Close(Window? window) => window?.Close();

    private async Task RunActionAsync(string actionName, Func<Task> action)
    {
        if (IsBusy)
            return;

        var craneNo = SelectedCraneNo;
        IsBusy = true;
        StatusMessage = $"{craneNo}호기 {actionName} 처리 중...";

        try
        {
            await action();

            var refreshed = await _api.GetStackerWorkAsync(craneNo);
            if (refreshed is null)
                ClearCurrent(craneNo);
            else
                Apply(refreshed);

            StatusMessage = $"{craneNo}호기 {actionName} 처리 완료";
        }
        catch (Exception ex)
        {
            StatusMessage = $"{craneNo}호기 {actionName} 처리 실패";
            _dialog.ShowMessage(
                $"{actionName} 처리에 실패했습니다.\n{ex.Message}",
                "오류");
        }
        finally
        {
            IsBusy = false;
        }
    }

    private void Apply(MonitoringStackerWorkDto item)
    {
        Current = item;
        LocationDisplay = FormatLocation(item.Location);
        PositionDisplay = FormatPosition(item.PositionBay, item.PositionLevel);
    }

    private void ClearCurrent(int craneNo)
    {
        Current = new MonitoringStackerWorkDto { CraneNo = craneNo };
        LocationDisplay = "-";
        PositionDisplay = "-";
    }

    private static string FormatLocation(string? value)
    {
        var location = value?.Trim() ?? string.Empty;
        return location.Length == 6 && location.All(char.IsDigit)
            ? $"{location[..2]}-{location.Substring(2, 2)}-{location[4..]}"
            : string.IsNullOrEmpty(location) ? "-" : location;
    }

    private static string FormatPosition(string? bay, string? level)
    {
        var normalizedBay = bay?.Trim() ?? string.Empty;
        var normalizedLevel = level?.Trim() ?? string.Empty;

        if (normalizedBay.Length == 0 && normalizedLevel.Length == 0)
            return "-";

        return $"{DashIfEmpty(normalizedBay)}연 / {DashIfEmpty(normalizedLevel)}단";
    }

    private static string DashIfEmpty(string value) =>
        string.IsNullOrWhiteSpace(value) ? "-" : value;

    private static void ValidateCraneNo(int craneNo)
    {
        if (craneNo is < 1 or > 7)
            throw new ArgumentOutOfRangeException(
                nameof(craneNo),
                craneNo,
                "스태커 크레인 호기는 1~7만 허용됩니다.");
    }
}
