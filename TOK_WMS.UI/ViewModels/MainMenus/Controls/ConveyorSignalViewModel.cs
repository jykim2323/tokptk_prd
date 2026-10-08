using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using System.Windows.Threading;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.UI.Configuration;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Models.MainMenus.Controls;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Controls;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Controls;

public sealed record ConveyorSignalGridDefinition(
    string Title,
    string[] Labels,
    bool IsBitSignal = true,
    string ValueDescription = "");

public partial class ConveyorSignalGridData : ObservableObject
{
    private bool _isApplying;
    private long _editVersion;

    public ConveyorSignalGridData(
        int gridNo,
        string direction,
        ConveyorSignalGridDefinition definition)
    {
        GridNo = gridNo;
        Direction = direction;
        DisplayName = definition.Title;
        IsBitSignal = definition.IsBitSignal;
        ValueDescription = definition.ValueDescription;
        Bits = SignalBitItems.Create(definition.Labels);
        RawBits = IsBitSignal ? "0000000000000000" : "0000";

        foreach (var bit in Bits)
        {
            bit.PropertyChanged += (_, args) =>
            {
                if (_isApplying
                    || !CanSave
                    || args.PropertyName != nameof(SignalBitItem.IsActive))
                    return;

                RawBits = BuildBits();
                _editVersion++;
                HasPendingChanges = true;
            };
        }
    }

    public int GridNo { get; }
    public string Direction { get; }
    public string DisplayName { get; }
    public bool IsBitSignal { get; }
    public bool IsWordSignal => !IsBitSignal;
    public string ValueDescription { get; }
    public ObservableCollection<SignalBitItem> Bits { get; }

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(DisplayBits))]
    private string _rawBits = "0000000000000000";

    [ObservableProperty]
    private bool _hasPendingChanges;

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(DisplayBits))]
    [NotifyPropertyChangedFor(nameof(CanSave))]
    private bool _isMapped;

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(DisplayBits))]
    [NotifyPropertyChangedFor(nameof(CanSave))]
    private bool _isLoaded;

    public long EditVersion => _editVersion;
    public bool CanSave => IsLoaded && IsMapped;
    public string DisplayBits => !IsLoaded
        ? "조회 대기"
        : IsMapped
            ? RawBits
            : "미연결";

    public string BuildBits()
        => string.Concat(Bits
            .OrderBy(bit => bit.Index)
            .Select(bit => bit.IsActive ? '1' : '0'));

    public string BuildValue()
        => IsBitSignal
            ? BuildBits()
            : NormalizeWord(RawBits);

    public void ApplyFromServer(string? value, bool isMapped)
    {
        IsLoaded = true;
        IsMapped = isMapped;

        if (!isMapped)
        {
            ApplyValue(IsBitSignal ? "0000000000000000" : "0000");
            HasPendingChanges = false;
            return;
        }

        if (HasPendingChanges)
            return;

        ApplyValue(value);
    }

    public bool MarkSaved(long savedVersion, string savedValue)
    {
        // 저장 요청 중 사용자가 다시 수정했다면 새 수정값을 유지한다.
        if (_editVersion != savedVersion)
            return false;

        ApplyValue(savedValue);
        HasPendingChanges = false;
        return true;
    }

    partial void OnRawBitsChanged(string value)
    {
        if (_isApplying || IsBitSignal || !CanSave)
            return;

        _editVersion++;
        HasPendingChanges = true;
    }

    private void ApplyValue(string? value)
    {
        if (IsBitSignal)
            ApplyBits(value);
        else
            ApplyWord(value);
    }

    private void ApplyBits(string? value)
    {
        var normalized = NormalizeBits(value);

        _isApplying = true;
        try
        {
            RawBits = normalized;
            for (var index = 0; index < Bits.Count; index++)
                Bits[index].IsActive = normalized[index] == '1';
        }
        finally
        {
            _isApplying = false;
        }
    }

    private static string NormalizeBits(string? value)
    {
        var normalized = (value ?? string.Empty).Trim();
        if (normalized.Length != SignalBitItems.Count
            || normalized.Any(bit => bit is not ('0' or '1')))
        {
            throw new InvalidOperationException(
                "컨베이어 신호는 0과 1로 구성된 16자리 값이어야 합니다.");
        }

        return normalized;
    }

    private void ApplyWord(string? value)
    {
        var normalized = NormalizeWord(value);

        _isApplying = true;
        try
        {
            RawBits = normalized;
        }
        finally
        {
            _isApplying = false;
        }
    }

    private static string NormalizeWord(string? value)
    {
        var normalized = (value ?? string.Empty).Trim();
        if (normalized.Length > 4)
            normalized = normalized[^4..];

        return normalized.PadLeft(4, '0');
    }
}

public partial class ConveyorSignalViewModel : DocumentViewModelBase
{
    private readonly IConveyorSignalApi _api;
    private readonly UiSettings _settings;
    private readonly IDialogService _dialog;
    private DispatcherTimer? _timer;
    private bool _isViewActive;
    private bool _refreshPending;

    /*
     * 각 Grid는 제목과 BIT00~BIT15 라벨을 따로 가진다.
     * 한 Grid의 배열을 수정해도 다른 Grid에는 영향을 주지 않는다.
     */
    private static readonly ConveyorSignalGridDefinition[] ReceiveGridDefinitions =
    [
        new("D5000",
        [
            "01 구간 PLT 유", "02 구간 PLT 유", "03 구간 PLT 유", "04 구간 PLT 유",
            "05 구간 PLT 유", "06 구간 PLT 유", "07 구간 PLT 유", "08 구간 PLT 유",
            "09 구간 PLT 유(사용안함)", "10 구간 PLT 유(사용안함)", "11 구간 PLT 유", "12 구간 PLT 유",
            "13 구간 PLT 유", "14 구간 PLT 유", "15 구간 PLT 유", "16 구간 PLT 유"
        ]),
        new("D5001",
        [
            "17 구간 PLT 유", "18 구간 PLT 유", "19 구간 PLT 유", "20 구간 PLT 유",
            "21 구간 PLT 유", "22 구간 PLT 유", "23 구간 PLT 유", "24 구간 PLT 유",
            "25 구간 PLT 유", "26 구간 PLT 유", "27 구간 PLT 유", "28 구간 PLT 유",
            "29 구간 PLT 유", "30 구간 PLT 유", "31 구간 PLT 유", "32 구간 PLT 유"
        ]),
        new("D5002",
        [
            "33 구간 PLT 유", "34 구간 PLT 유", "35 구간 PLT 유", "36 구간 PLT 유",
            "37 구간 PLT 유", "38 구간 PLT 유", "39 구간 PLT 유", "40 구간 PLT 유",
            "41 구간 PLT 유", "42 구간 PLT 유", "43 구간 PLT 유", "44 구간 PLT 유",
            "45 구간 PLT 유", "46 구간 PLT 유", "47 구간 PLT 유", "48 구간 PLT 유"
        ]),
        new("D5003",
        [
            "49 구간 PLT 유", "50 구간 PLT 유", "51 구간 PLT 유", "52 구간 PLT 유",
            "53 구간 PLT 유", "54 구간 PLT 유", "55 구간 PLT 유", "56 구간 PLT 유",
            "57 구간 PLT 유", "58 구간 PLT 유", "", "2열 운전 모드 (0=입고 / 1=출고)",
            "", "OP#01", "OP#02", "OP#03"
        ]),
        new("D5004",
        [
            "06번 구간 직진 완료", "14번 구간 직진 완료", "20번 구간 직진 완료", "22번 구간 직진 완료",
            "", "", "12번 구간 분기 완료", "20번 구간 분기 완료",
            "", "", "", "12번 구간 이제완료(피킹/Full PLT)",
            "13구간 완료 보컨", "", "20번 구간 이제완료(피킹/Full PLT)", "21구간 완료 보컨"
        ]),
        new("D5005",
        [
            "1층 IN ST READY(#SC01)", "1층 IN ST READY(#SC02)", "1층 IN ST READY(#SC03)", "1층 IN ST READY(#SC04)",
            "1층 IN ST READY(#SC05)", "1층 IN ST READY(#SC06)", "1층 IN ST READY(#SC07)", "",
            "", "1층 OUT ST READY(#SC01)", "1층 OUT ST READY(#SC02)", "1층 OUT ST READY(#SC03)",
            "1층 OUT ST READY(#SC04)", "1층 OUT ST READY(#SC05)", "1층 OUT ST READY(#SC06)", "1층 OUT ST READY(#SC07)(사용안함))"
        ]),
        new("D5006",
        [
            "CV ERROR", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5007",
        [
            "RGV#1 ONLINE", "RGV#1 Auto", "RGV#1 Ready", "RGV#1 RGV Ack",
            "RGV#1 PLT Exist", "RGV#1 Loading 완료", "RGV#1 Unloading 완료", "RGV#1 에러",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5008",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ], false, "RGV #1 현재 위치"),
        new("D5009",
        [
            "RGV ERROR", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ], false, "RGV #1 에러 코드"),
        new("D5010",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5011",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ])
    ];

    private static readonly ConveyorSignalGridDefinition[] SendGridDefinitions =
    [
        new("D5100",
        [
            "06번 구간 직진 지시", "14번 구간 직진 지시", "20번 구간 직진 지시", "22번 구간 직진 지시",
            "", "", "12번 구간 분기 지시", "20번 구간 분기 지시",
            "", "", "", "12번 구간 이제완료 ACK",
            "13구간 완료 보턴 ACK", "", "20번 구간 이제완료 ACK", "21구간 완료 보턴 ACK"
        ]),
        new("D5101",
        [
            "BCR#1 Reading OK", "BCR#2 Reading OK", "BCR#3 Reading OK", "",
            "BCR#1 Reading Error", "BCR#2 Reading Error", "BCR#3 Reading Error", "",
            "", "", "12 FULL 출고 Lamp", "12 Picking 출고 Lamp",
            "20 FULL 출고 Lamp", "20 Picking 출고 Lamp", "", "통신상태"
        ]),
        new("D5102",
        [
            "RGV#1 RGV 지시 Strobe", "RGV#1 RGV Loading ACK", "RGV#1 RGV Unloading ACK", "",
            "홈복귀", "RGV#1 RGV Data Reset", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5103",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5104",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5105",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5106",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5107",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5108",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5109",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5110",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ]),
        new("D5111",
        [
            "", "", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ])
    ];

    public ConveyorSignalViewModel(
        IConveyorSignalApi api,
        UiSettings settings,
        IDialogService dialog)
    {
        _api = api;
        _settings = settings;
        _dialog = dialog;

        // 컨베이어 신호는 스태커 호기별이 아니라 하나의 CVC 전체를 표시한다.
        ReceiveGrids = BuildGrids("R", ReceiveGridDefinitions);
        SendGrids = BuildGrids("S", SendGridDefinitions);

        Title = "컨베이어 신호 관리";
        ContentId = DocumentKeys.Frm2500;
    }

    public ObservableCollection<ConveyorSignalGridData> ReceiveGrids { get; }
    public ObservableCollection<ConveyorSignalGridData> SendGrids { get; }

    [ObservableProperty] private bool _isAutoRefresh = true;
    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private bool _isConnected;
    [ObservableProperty] private string _statusMessage = "조회 대기 중";
    [ObservableProperty] private string _lastUpdatedText = "-";

    partial void OnIsAutoRefreshChanged(bool value)
    {
        if (!_isViewActive)
            return;

        if (value)
            StartTimer();
        else
            StopTimer();
    }

    public async Task ActivateAsync()
    {
        _isViewActive = true;
        await RefreshAsync();

        if (_isViewActive && IsAutoRefresh)
            StartTimer();
    }

    public void Deactivate()
    {
        _isViewActive = false;
        _refreshPending = false;
        StopTimer();
    }

    [RelayCommand]
    private Task Refresh() => RefreshAsync();

    [RelayCommand]
    private async Task SaveGrid(ConveyorSignalGridData? grid)
    {
        if (grid is null)
            return;

        if (!grid.CanSave)
        {
            StatusMessage = "이 Grid는 아직 조회되지 않았거나 DB 채널로 연결되지 않았습니다.";
            return;
        }

        if (IsBusy)
        {
            StatusMessage = "조회 또는 수정 작업이 끝난 뒤 다시 시도해 주세요.";
            return;
        }

        if (!_dialog.ShowConfirm("정말로 수정 하시겠습니까?", "확인"))
        {
            StatusMessage = "수정을 취소했습니다.";
            return;
        }

        var savedVersion = grid.EditVersion;
        var value = grid.BuildValue();
        var direction = grid.Direction == "R" ? "PLC → COM" : "COM → PLC";
        var gridName = string.IsNullOrWhiteSpace(grid.DisplayName)
            ? $"GRID #{grid.GridNo:00}"
            : grid.DisplayName;

        IsBusy = true;
        try
        {
            await _api.UpdateAsync(
                grid.Direction,
                grid.GridNo,
                new ConveyorSignalUpdateDto { Bits = value });

            var savedWithoutLaterEdit = grid.MarkSaved(savedVersion, value);
            IsConnected = true;
            LastUpdatedText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            StatusMessage = savedWithoutLaterEdit
                ? $"{direction} {gridName} 수정 완료"
                : $"{direction} {gridName} 수정 완료 (이후 편집값 유지 중)";

            try
            {
                Apply(await _api.GetAsync());
            }
            catch (Exception ex)
            {
                IsConnected = false;
                StatusMessage += $" (재조회 실패: {ex.Message})";
            }
        }
        catch (Exception ex)
        {
            IsConnected = false;
            StatusMessage = $"수정 실패: {ex.Message}";
            _dialog.ShowWarning(StatusMessage, "오류");
        }
        finally
        {
            IsBusy = false;
        }

        if (_isViewActive && _refreshPending)
        {
            _refreshPending = false;
            await RefreshAsync();
        }
    }

    private async Task RefreshAsync()
    {
        if (IsBusy)
        {
            _refreshPending = true;
            return;
        }

        IsBusy = true;
        try
        {
            Apply(await _api.GetAsync());
            IsConnected = true;
            LastUpdatedText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            StatusMessage = AllGrids.Any(grid => grid.HasPendingChanges)
                ? "컨베이어 신호 수신 (미저장 수정값 유지 중)"
                : "컨베이어 신호 정상 수신";
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

        if (_isViewActive && _refreshPending)
        {
            _refreshPending = false;
            await RefreshAsync();
        }
    }

    private IEnumerable<ConveyorSignalGridData> AllGrids
        => ReceiveGrids.Concat(SendGrids);

    private void Apply(IReadOnlyList<ConveyorSignalGridDto> values)
    {
        foreach (var value in values)
        {
            var grids = string.Equals(value.Direction, "R", StringComparison.OrdinalIgnoreCase)
                ? ReceiveGrids
                : string.Equals(value.Direction, "S", StringComparison.OrdinalIgnoreCase)
                    ? SendGrids
                    : null;

            if (grids is null || value.GridNo is < 1 or > 12)
                continue;

            grids[value.GridNo - 1].ApplyFromServer(value.Bits, value.IsMapped);
        }
    }

    private static ObservableCollection<ConveyorSignalGridData> BuildGrids(
        string direction,
        IReadOnlyList<ConveyorSignalGridDefinition> definitions)
        => new(definitions.Select((definition, index)
            => new ConveyorSignalGridData(index + 1, direction, definition)));

    private void StartTimer()
    {
        if (_timer is not null)
            return;

        _timer = new DispatcherTimer
        {
            Interval = TimeSpan.FromMilliseconds(Math.Max(500, _settings.SignalPollMs))
        };
        _timer.Tick += OnTimerTick;
        _timer.Start();
    }

    private void StopTimer()
    {
        if (_timer is null)
            return;

        _timer.Tick -= OnTimerTick;
        _timer.Stop();
        _timer = null;
    }

    private async void OnTimerTick(object? sender, EventArgs e)
        => await RefreshAsync();

    public override void Dispose()
        => Deactivate();
}
