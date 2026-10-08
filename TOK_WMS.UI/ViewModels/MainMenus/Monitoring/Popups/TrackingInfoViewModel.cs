using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Windows;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Monitoring;

namespace TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

public partial class TrackingInfoViewModel : ObservableObject
{
    private readonly ISc1LineApi _api;
    private readonly IDialogService _dialog;
    private readonly SemaphoreSlim _loadGate = new(1, 1);

    public TrackingInfoViewModel(ISc1LineApi api, IDialogService dialog)
    {
        _api = api;
        _dialog = dialog;
    }

    public IReadOnlyList<string> TrackNumbers { get; } =
        Enumerable.Range(1, 84).Select(number => number.ToString("00")).ToArray();

    public bool IsNotBusy => !IsBusy;

    [ObservableProperty] private string _selectedTrackNo = "01";
    [ObservableProperty] private string _index = string.Empty;
    [ObservableProperty] private string _jobType = string.Empty;
    [ObservableProperty] private string _location = string.Empty;
    [ObservableProperty] private string _workStation = string.Empty;
    [ObservableProperty] private string _from = string.Empty;
    [ObservableProperty] private string _to = string.Empty;
    [ObservableProperty] private string _flag = string.Empty;
    [ObservableProperty] private string _date = string.Empty;
    [ObservableProperty] private string _time = string.Empty;
    [ObservableProperty] private bool _isMoveTargetVisible;
    [ObservableProperty] private string? _moveTargetTrackNo;
    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private string _statusMessage = "조회 대기 중";

    public void Initialize(string trackNo)
    {
        SelectedTrackNo = NormalizeTrackNo(trackNo);
        ClearDetail();
        StatusMessage = $"{SelectedTrackNo} 구간 조회 대기 중";
    }

    public async Task LoadAsync()
    {
        var requestedTrackNo = NormalizeTrackNo(SelectedTrackNo);
        await _loadGate.WaitAsync();

        try
        {
            IsBusy = true;
            StatusMessage = $"{requestedTrackNo} 구간을 조회하는 중입니다.";

            var item = await _api.GetTrackAsync(requestedTrackNo);
            if (!string.Equals(requestedTrackNo, SelectedTrackNo, StringComparison.Ordinal))
                return;

            if (item is null)
            {
                ClearDetail();
                StatusMessage = $"{requestedTrackNo} 구간에 등록된 트렉킹 정보가 없습니다.";
                return;
            }

            ApplyDetail(item);
            StatusMessage = $"{requestedTrackNo} 구간 조회 완료";
        }
        catch (Exception ex)
        {
            StatusMessage = $"{requestedTrackNo} 구간 조회 실패";
            _dialog.ShowWarning($"트렉킹 정보 조회 실패: {ex.Message}", "오류");
        }
        finally
        {
            IsBusy = false;
            _loadGate.Release();
        }
    }

    [RelayCommand]
    private Task Search() => LoadAsync();

    [RelayCommand]
    private void BeginMove()
    {
        if (IsBusy)
            return;

        MoveTargetTrackNo = null;
        IsMoveTargetVisible = true;
        StatusMessage = $"{SelectedTrackNo} 구간 데이터를 이동할 대상 구간을 선택해 주세요.";
    }

    [RelayCommand]
    private void CancelMove()
    {
        MoveTargetTrackNo = null;
        IsMoveTargetVisible = false;
        StatusMessage = $"{SelectedTrackNo} 구간 이동을 취소했습니다.";
    }

    public async Task<bool> MoveToAsync(string? destinationTrackNo)
    {
        if (IsBusy || !IsMoveTargetVisible || string.IsNullOrWhiteSpace(destinationTrackNo))
            return false;

        string sourceTrackNo;
        string targetTrackNo;

        try
        {
            sourceTrackNo = NormalizeTrackNo(SelectedTrackNo);
            targetTrackNo = NormalizeTrackNo(destinationTrackNo);
        }
        catch (ArgumentOutOfRangeException ex)
        {
            _dialog.ShowWarning(ex.Message, "이동 구간 확인");
            MoveTargetTrackNo = null;
            return false;
        }

        if (string.Equals(sourceTrackNo, targetTrackNo, StringComparison.Ordinal))
        {
            _dialog.ShowWarning("현재 구간과 다른 이동 대상 구간을 선택해 주세요.", "이동 구간 확인");
            MoveTargetTrackNo = null;
            return false;
        }

        if (!_dialog.ShowConfirm(
                $"{sourceTrackNo} 구간의 데이터를 {targetTrackNo} 구간으로 이동하시겠습니까?",
                "트렉킹 정보 이동"))
        {
            MoveTargetTrackNo = null;
            return false;
        }

        await _loadGate.WaitAsync();
        IsBusy = true;

        try
        {
            await _api.MoveTrackAsync(sourceTrackNo, new MonitoringTrackMoveRequest
            {
                DestinationTrackNo = targetTrackNo
            });

            MoveTargetTrackNo = null;
            IsMoveTargetVisible = false;
            StatusMessage = $"{sourceTrackNo} → {targetTrackNo} 구간 이동 완료";
            return true;
        }
        catch (Exception ex)
        {
            StatusMessage = $"{sourceTrackNo} → {targetTrackNo} 구간 이동 실패";
            _dialog.ShowWarning($"트렉킹 정보 이동 실패: {ex.Message}", "오류");
            MoveTargetTrackNo = null;
            return false;
        }
        finally
        {
            IsBusy = false;
            _loadGate.Release();
        }
    }

    [RelayCommand]
    private async Task Save(Window? window)
    {
        if (IsBusy || !ValidateInputs())
            return;

        var trackNo = NormalizeTrackNo(SelectedTrackNo);
        if (!_dialog.ShowConfirm(
                $"{trackNo} 구간의 데이터를 등록하시겠습니까?",
                "트렉킹 정보 등록"))
        {
            return;
        }

        IsBusy = true;
        try
        {
            await _api.SaveTrackAsync(trackNo, new MonitoringTrackUpdateRequest
            {
                Index = Clean(Index),
                JobType = Clean(JobType).ToUpperInvariant(),
                Location = Clean(Location),
                WorkStation = Clean(WorkStation),
                From = Clean(From),
                To = Clean(To),
                Flag = Clean(Flag).ToUpperInvariant(),
                Date = Clean(Date),
                Time = Clean(Time)
            });

            StatusMessage = $"{trackNo} 구간 등록 완료";
            window?.Close();
        }
        catch (Exception ex)
        {
            StatusMessage = $"{trackNo} 구간 등록 실패";
            _dialog.ShowWarning($"트렉킹 정보 등록 실패: {ex.Message}", "오류");
        }
        finally
        {
            IsBusy = false;
        }
    }

    [RelayCommand]
    private async Task Delete(Window? window)
    {
        if (IsBusy)
            return;

        var trackNo = NormalizeTrackNo(SelectedTrackNo);
        if (!_dialog.ShowConfirm(
                $"{trackNo} 구간의 데이타를 삭제 하겠습니까?",
                "트렉킹 정보 삭제"))
        {
            return;
        }

        IsBusy = true;
        try
        {
            await _api.DeleteTrackAsync(trackNo);
            ClearDetail();
            StatusMessage = $"{trackNo} 구간 삭제 완료";
            window?.Close();
        }
        catch (Exception ex)
        {
            StatusMessage = $"{trackNo} 구간 삭제 실패";
            _dialog.ShowWarning($"트렉킹 정보 삭제 실패: {ex.Message}", "오류");
        }
        finally
        {
            IsBusy = false;
        }
    }

    [RelayCommand]
    private void Close(Window? window) => window?.Close();

    partial void OnIsBusyChanged(bool value) => OnPropertyChanged(nameof(IsNotBusy));

    private void ApplyDetail(MonitoringTrackDetailDto item)
    {
        Index = Clean(item.Index);
        JobType = Clean(item.JobType);
        Location = Clean(item.Location);
        WorkStation = Clean(item.WorkStation);
        From = Clean(item.From);
        To = Clean(item.To);
        Flag = Clean(item.Flag);
        Date = Clean(item.Date);
        Time = Clean(item.Time);
    }

    private void ClearDetail()
    {
        Index = string.Empty;
        JobType = string.Empty;
        Location = string.Empty;
        WorkStation = string.Empty;
        From = string.Empty;
        To = string.Empty;
        Flag = string.Empty;
        Date = string.Empty;
        Time = string.Empty;
    }

    private bool ValidateInputs()
    {
        string? error = null;

        if (Clean(Index).Length > 20)
            error = "입/출고 순번은 최대 20자리입니다.";
        else if (Clean(JobType).Length > 1)
            error = "구분은 최대 1자리입니다.";
        else if (!IsOptionalDigits(Location, 6))
            error = "저장위치는 비워 두거나 숫자 6자리(BBYYLL)로 입력해 주세요.";
        else if (Clean(WorkStation).Length > 1)
            error = "작업 위치는 최대 1자리입니다.";
        else if (Clean(From).Length > 2 || Clean(To).Length > 2)
            error = "FROM과 TO는 각각 최대 2자리입니다.";
        else if (Clean(Flag).Length > 1)
            error = "Flag는 최대 1자리입니다.";
        else if (!IsOptionalDigits(Date, 8))
            error = "일자는 비워 두거나 YYYYMMDD 숫자 8자리로 입력해 주세요.";
        else if (!IsOptionalDigits(Time, 6))
            error = "시간은 비워 두거나 HHMMSS 숫자 6자리로 입력해 주세요.";

        if (error is null)
            return true;

        _dialog.ShowWarning(error, "입력 확인");
        return false;
    }

    private static bool IsOptionalDigits(string? value, int length)
    {
        var normalized = Clean(value);
        return normalized.Length == 0 ||
               (normalized.Length == length && normalized.All(char.IsDigit));
    }

    private static string NormalizeTrackNo(string? trackNo)
    {
        if (!int.TryParse(trackNo?.Trim(), out var number) || number is < 1 or > 84)
            throw new ArgumentOutOfRangeException(nameof(trackNo), "트렉킹 번호는 01~84 사이여야 합니다.");

        return number.ToString("00");
    }

    private static string Clean(string? value) => value?.Trim() ?? string.Empty;
}
