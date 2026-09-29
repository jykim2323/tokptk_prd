using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Controls;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Controls;

public partial class CraneOperationModeItem(int floorNo, int craneNo) : ObservableObject
{
    public int FloorNo { get; } = floorNo;
    public int CraneNo { get; } = craneNo;
    public string DisplayName { get; } = $"{craneNo}번 SCC 상태";
    public string GroupName { get; } = $"Floor{floorNo}Crane{craneNo}";

    [ObservableProperty]
    private int _selectedMode = 3;

    public bool IsInboundAvailable
    {
        get => SelectedMode == 1;
        set { if (value) SelectedMode = 1; }
    }

    public bool IsOutboundAvailable
    {
        get => SelectedMode == 2;
        set { if (value) SelectedMode = 2; }
    }

    public bool IsBothAvailable
    {
        get => SelectedMode == 3;
        set { if (value) SelectedMode = 3; }
    }

    public bool IsDisabled
    {
        get => SelectedMode == 0;
        set { if (value) SelectedMode = 0; }
    }

    partial void OnSelectedModeChanged(int value)
    {
        OnPropertyChanged(nameof(IsInboundAvailable));
        OnPropertyChanged(nameof(IsOutboundAvailable));
        OnPropertyChanged(nameof(IsBothAvailable));
        OnPropertyChanged(nameof(IsDisabled));
    }
}

public sealed class FloorOperationSettingItem
{
    public FloorOperationSettingItem(int floorNo, int craneCount)
    {
        FloorNo = floorNo;
        Cranes = new(Enumerable.Range(1, craneCount)
            .Select(craneNo => new CraneOperationModeItem(floorNo, craneNo)));
    }

    public int FloorNo { get; }
    public string DisplayName => $"{FloorNo}층 설정";
    public ObservableCollection<CraneOperationModeItem> Cranes { get; }
}

public partial class WorkSequenceSetting : ObservableObject
{
    [ObservableProperty] private string _inboundSequence = "1";
    [ObservableProperty] private string _outboundSequence = "1";
    [ObservableProperty] private string _reInboundSequence = "1";
    [ObservableProperty] private string _emptyPalletSequence = "1";
}

public partial class SystemOperationViewModel : DocumentViewModelBase
{
    private readonly ISystemOperationApi _api;
    private readonly IDialogService _dialog;

    public SystemOperationViewModel(
        ISystemOperationApi api,
        IDialogService dialog)
    {
        _api = api;
        _dialog = dialog;

        // 현재는 1층만 운영한다. 2층 DB 구조가 확정되면 여기에 추가한다.
        FloorSettings = [new FloorOperationSettingItem(1, 7)];

        Title = "시스템운전 설정";
        ContentId = DocumentKeys.Frm2100;
    }

    public ObservableCollection<FloorOperationSettingItem> FloorSettings { get; }
    public WorkSequenceSetting WorkSequences { get; } = new();

    [ObservableProperty] private string _inboundCrane = "1";
    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private bool _isConnected;
    [ObservableProperty] private string _statusMessage = "조회 대기 중";
    [ObservableProperty] private string _lastUpdatedText = "-";

    public Task ActivateAsync() => RefreshAsync();

    [RelayCommand]
    private Task Refresh() => RefreshAsync();

    [RelayCommand]
    private async Task SaveFloor(FloorOperationSettingItem? floor)
    {
        if (floor is null || floor.FloorNo != 1)
            return;

        if (!_dialog.ShowConfirm("정말로 수정 하시겠습니까?", "확인"))
        {
            StatusMessage = "수정을 취소했습니다.";
            return;
        }

        var modes = floor.Cranes
            .OrderBy(crane => crane.CraneNo)
            .Select(crane => crane.SelectedMode)
            .ToArray();

        await UpdateAsync(
            SystemOperationUpdateGroup.Modes,
            new SystemOperationUpdateDto { CraneModes = modes },
            "1층 SCC 운전모드");
    }

    [RelayCommand]
    private async Task SaveSequences()
    {
        if (!TryReadSequence(WorkSequences.InboundSequence, "입고순번", out var inbound)
            || !TryReadSequence(WorkSequences.OutboundSequence, "출고순번", out var outbound)
            || !TryReadSequence(WorkSequences.ReInboundSequence, "재입고순번", out var reInbound)
            || !TryReadSequence(WorkSequences.EmptyPalletSequence, "공파레트순번", out var emptyPallet))
        {
            return;
        }

        if (!_dialog.ShowConfirm("정말로 수정 하시겠습니까?", "확인"))
        {
            StatusMessage = "수정을 취소했습니다.";
            return;
        }

        await UpdateAsync(
            SystemOperationUpdateGroup.Sequences,
            new SystemOperationUpdateDto
            {
                InboundSequence = inbound,
                OutboundSequence = outbound,
                ReInboundSequence = reInbound,
                EmptyPalletSequence = emptyPallet
            },
            "작업순번");
    }

    [RelayCommand]
    private async Task SaveInboundCrane()
    {
        if (!int.TryParse(InboundCrane.Trim(), out var inboundCrane)
            || inboundCrane is < 1 or > 7)
        {
            _dialog.ShowMessage("입고호기는 1에서 7 사이로 입력해 주세요.", "입력 확인");
            return;
        }

        if (!_dialog.ShowConfirm("정말로 수정 하시겠습니까?", "확인"))
        {
            StatusMessage = "수정을 취소했습니다.";
            return;
        }

        await UpdateAsync(
            SystemOperationUpdateGroup.InboundCrane,
            new SystemOperationUpdateDto { InboundCrane = inboundCrane },
            "입고호기");
    }

    private async Task RefreshAsync()
    {
        if (IsBusy)
            return;

        IsBusy = true;
        try
        {
            var state = await _api.GetAsync();
            Apply(state);
            IsConnected = true;
            LastUpdatedText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            StatusMessage = "시스템 운전 설정 조회 완료";
        }
        catch (Exception ex)
        {
            IsConnected = false;
            StatusMessage = $"조회 실패: {ex.Message}";
        }
        finally
        {
            IsBusy = false;
        }
    }

    private async Task UpdateAsync(
        SystemOperationUpdateGroup group,
        SystemOperationUpdateDto values,
        string description)
    {
        if (IsBusy)
            return;

        IsBusy = true;
        try
        {
            await _api.UpdateAsync(group, values);
            var state = await _api.GetAsync();
            Apply(state);
            IsConnected = true;
            LastUpdatedText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            StatusMessage = $"{description} 수정 완료";
        }
        catch (Exception ex)
        {
            IsConnected = false;
            StatusMessage = $"수정 실패: {ex.Message}";
            _dialog.ShowMessage(StatusMessage, "오류");
        }
        finally
        {
            IsBusy = false;
        }
    }

    private void Apply(SystemOperationDto state)
    {
        var floor = FloorSettings[0];
        for (var index = 0; index < floor.Cranes.Count; index++)
        {
            var mode = index < state.CraneModes.Length
                ? state.CraneModes[index]
                : 3;
            floor.Cranes[index].SelectedMode = mode is >= 0 and <= 3 ? mode : 3;
        }

        WorkSequences.InboundSequence = state.InboundSequence.ToString();
        WorkSequences.OutboundSequence = state.OutboundSequence.ToString();
        WorkSequences.ReInboundSequence = state.ReInboundSequence.ToString();
        WorkSequences.EmptyPalletSequence = state.EmptyPalletSequence.ToString();
        InboundCrane = state.InboundCrane.ToString();
    }

    private bool TryReadSequence(string text, string label, out long value)
    {
        value = 0;
        var normalized = (text ?? string.Empty).Trim();
        if (normalized.Length is < 1 or > 18
            || !long.TryParse(normalized, out value)
            || value < 0)
        {
            _dialog.ShowMessage($"{label}은 0 이상 18자리 이하의 숫자로 입력해 주세요.", "입력 확인");
            return false;
        }

        return true;
    }
}
