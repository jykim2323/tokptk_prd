using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Windows;
using System.Windows.Media;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.UI.Configuration;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Controls;
using TOK.WMS.UI.Services.Api.Monitoring;
using TOK.WMS.UI.Services.Interfaces.Popup;
using TOK.WMS.UI.ViewModels.Base;
using TOK.WMS.UI.ViewModels.Base.Interfaces;
using TOK.WMS.UI.Views.Monitoring.Models;

namespace TOK.WMS.UI.ViewModels.MainMenus.Monitoring;

public partial class MonitoringViewModel : DocumentViewModelBase, IRefreshable
{
    private const double CraneRailTop = 322d;
    private const double Sc1BayPitch = 49.5d;
    private const double ProductCraneBayPitch = 32d;
    private const double DefaultCraneTop = 544d;
    private const double DefaultRgvCanvasLeft = 363d;
    private const string Bank2ModeDirection = "R";
    private const int Bank2ModeGridNo = 4;
    private const int Bank2ModeBitIndex = 11;

    // Delphi/VCL 범례 색상을 WPF RGB로 옮긴 값입니다.
    private static readonly Brush ManualBrush = SystemColors.ActiveBorderBrush;
    private static readonly Brush StoppedBrush = SystemColors.ControlBrush;
    private static readonly Brush ReadyBrush = CreateBrush(0x00, 0xFF, 0x00);
    private static readonly Brush WorkingBrush = CreateBrush(0xFF, 0xFF, 0x00);
    private static readonly Brush ErrorBrush = CreateBrush(0xFF, 0x00, 0x00);
    private static readonly Brush BcrEnabledBrush = CreateBrush(0x00, 0x00, 0xFF);
    private static readonly Brush BcrDisabledBrush = CreateBrush(0xFF, 0x00, 0x00);

    private static readonly Brush LightTextBrush = CreateBrush(0xFF, 0xFF, 0xFF);
    private static readonly Brush DarkTextBrush = CreateBrush(0x17, 0x2B, 0x4D);

    private static readonly Brush OperatorAutoBrush = CreateBrush(0x17, 0x17, 0xED);
    private static readonly Brush RackProhibitedBrush = CreateBrush(0x00, 0x00, 0x00);
    private static readonly Brush RackDoubleStorageBrush = CreateBrush(0x80, 0x00, 0x80);
    private static readonly Brush RackEmptyRetrievalBrush = CreateBrush(0xFF, 0x00, 0xFF);
    private static readonly Brush RackInboundBrush = CreateBrush(0x00, 0xFF, 0xFF);
    private static readonly Brush RackOutboundBrush = CreateBrush(0x00, 0x00, 0xFF);
    private static readonly Brush RackNormalBrush = CreateBrush(0xFF, 0xFF, 0xFF);

    // 화면에는 09·10·59가 없고 25·82는 RGV 대차로 표시됩니다.
    private static readonly int[] DisplayedTrackNumbers = Enumerable.Range(1, 84)
        .Where(trackNo => trackNo is not 9 and not 10 and not 59)
        .ToArray();

    private readonly ISc1LineApi _api;
    private readonly IConveyorSignalApi _conveyorSignalApi;
    private readonly UiSettings _settings;
    private readonly IDialogService _dialog;
    private readonly IWindowService _windowService;
    private readonly object _lifecycleSync = new();
    private readonly SemaphoreSlim _refreshGate = new(1, 1);
    private readonly SemaphoreSlim _positionRefreshGate = new(1, 1);
    private readonly SemaphoreSlim _bcrToggleGate = new(1, 1);
    private readonly SemaphoreSlim _bank2ModeToggleGate = new(1, 1);

    private CancellationTokenSource? _activationCts;
    private Task? _pollingTask;
    private Task? _positionPollingTask;
    private bool _disposed;

    // XAML의 Command="{Binding ToggleBcrCommand}"가 직접 참조하는 명령입니다.
    // 자동 생성에 숨기지 않고 명시적으로 선언해 클릭 흐름을 바로 찾을 수 있게 합니다.
    public IAsyncRelayCommand<string?> ToggleBcrCommand { get; }
    public IAsyncRelayCommand ToggleBank2ModeCommand { get; }

    public MonitoringViewModel(
        ISc1LineApi api,
        IConveyorSignalApi conveyorSignalApi,
        UiSettings settings,
        IDialogService dialog,
        IWindowService windowService)
    {
        _api = api;
        _conveyorSignalApi = conveyorSignalApi;
        _settings = settings;
        _dialog = dialog;
        _windowService = windowService;
        ToggleBcrCommand = new AsyncRelayCommand<string?>(ToggleBcrAsync);
        ToggleBank2ModeCommand = new AsyncRelayCommand(ToggleBank2ModeAsync);

        Title = "모니터링";
        ContentId = DocumentKeys.Mornitor;
    }

    public void OpenTrackingInfo(int trackNo) =>
        _windowService.ShowTrackingInfo(trackNo.ToString("00", CultureInfo.InvariantCulture));

    public void OpenStackerWork(int craneNo) =>
        _windowService.ShowStackerWork(craneNo);

    public void OpenRackOverview(int bank, int selectedBay) =>
        _windowService.ShowRackOverview(bank, selectedBay);

    [ObservableProperty] private bool _isMonitorConnected;
    [ObservableProperty] private bool _isMonitorBusy;
    [ObservableProperty] private string _monitorStatusMessage = "조회 대기 중";
    [ObservableProperty] private string _monitorLastUpdatedText = "-";
    [ObservableProperty] private string _monitorErrorMessage = string.Empty;

    [ObservableProperty]
    private IReadOnlyDictionary<string, CraneMonitorState> _craneStates =
        CreateEmptyCraneStates();

    [ObservableProperty]
    private IReadOnlyDictionary<string, bool> _stationReadyStates =
        CreateEmptyStationReadyStates();

    [ObservableProperty]
    private IReadOnlyDictionary<string, TrackingMonitorState> _trackStates =
        CreateEmptyTrackStates();

    [ObservableProperty]
    private IReadOnlyDictionary<string, RgvMonitorState> _rgvStates =
        CreateEmptyRgvStates();

    [ObservableProperty]
    private IReadOnlyDictionary<string, MonitorPointState> _bcrStates =
        CreateEmptyBcrStates();

    [ObservableProperty]
    private IReadOnlyDictionary<string, MonitorPointState> _operatorStates =
        CreateEmptyOperatorStates();

    [ObservableProperty]
    private IReadOnlyDictionary<string, InventoryMonitorState> _inventoryStates =
        CreateEmptyInventoryStates();

    [ObservableProperty]
    private InventoryMonitorState _inventoryTotal = InventoryMonitorState.Empty;

    [ObservableProperty]
    private InventoryMonitorState _inventoryGoods = InventoryMonitorState.Empty;

    [ObservableProperty]
    private InventoryMonitorState _inventoryProducts = InventoryMonitorState.Empty;

    [ObservableProperty] private string _sc1ModeStatus = "1열/2열 모드 조회 대기";
    [ObservableProperty] private string _sc1ModeToolTip = "SC1 라인 모드를 조회하지 않았습니다.";
    [ObservableProperty] private string _bank1ModeStatus = "-";
    [ObservableProperty] private string _bank2ModeStatus = "-";
    [ObservableProperty] private bool _isBank1InboundAllowed;
    [ObservableProperty] private bool _isBank1OutboundAllowed;
    [ObservableProperty] private bool _isBank2InboundAllowed;
    [ObservableProperty] private bool _isBank2OutboundAllowed;
    [ObservableProperty] private Visibility _bank1OutboundArrowVisibility = Visibility.Collapsed;
    [ObservableProperty] private Visibility _bank2InboundArrowVisibility = Visibility.Collapsed;
    [ObservableProperty] private Visibility _bank2OutboundArrowVisibility = Visibility.Collapsed;
    [ObservableProperty] private string _bank2AvailabilityText = "입고 가능";
    [ObservableProperty] private Visibility _bank2AvailabilityVisibility = Visibility.Visible;

    [ObservableProperty]
    private ObservableCollection<Sc1OutboundReservationRow> _sc1OutboundReservations = [];

    [ObservableProperty]
    private ObservableCollection<Sc1TrackingRow> _sc1TrackingItems = [];

    [ObservableProperty]
    private IReadOnlyList<Sc1RackBaySummaryDto> _sc1RackBaySummaries = [];

    [ObservableProperty]
    private IReadOnlyDictionary<string, MonitorPointState> _rackBayStates =
        CreateEmptyRackBayStates();

    /// <summary>화면 Loaded 시 즉시 1회 조회한 뒤 설정된 간격으로 계속 갱신합니다.</summary>
    public Task ActivateAsync()
    {
        CancellationToken token;

        lock (_lifecycleSync)
        {
            ObjectDisposedException.ThrowIf(_disposed, this);

            if (_activationCts is not null)
                return Task.CompletedTask;

            _activationCts = new CancellationTokenSource();
            token = _activationCts.Token;
            _pollingTask = PollAsync(token);
            _positionPollingTask = PollPositionsAsync(token);
        }

        return RefreshAllAsync(token, waitForCurrent: true);
    }

    /// <summary>화면을 벗어나면 진행 중 요청과 다음 주기 조회를 함께 중단합니다.</summary>
    public void Deactivate()
    {
        CancellationTokenSource? cts;
        Task? pollingTask;
        Task? positionPollingTask;

        lock (_lifecycleSync)
        {
            cts = _activationCts;
            pollingTask = _pollingTask;
            positionPollingTask = _positionPollingTask;
            _activationCts = null;
            _pollingTask = null;
            _positionPollingTask = null;
        }

        if (cts is null)
            return;

        cts.Cancel();
        _ = DisposeAfterStopAsync(cts, pollingTask, positionPollingTask);
    }

    public void Refresh()
    {
        CancellationToken token;
        lock (_lifecycleSync)
        {
            if (_disposed || _activationCts is null)
                return;

            token = _activationCts.Token;
        }

        _ = RefreshAllAsync(token);
    }

    /// <summary>
    /// Delphi BCRnLblClick과 동일하게 해당 BCR 판독 사용 여부를 1 ↔ 0으로 전환합니다.
    /// 리딩 결과 문구는 이 값이 아니라 T2TBTRAK의 INDEX/FLAG로 별도 표시됩니다.
    /// </summary>
    private async Task ToggleBcrAsync(string? bcrNoText)
    {
        if (!int.TryParse(bcrNoText, NumberStyles.Integer,
                CultureInfo.InvariantCulture, out var bcrNo) || bcrNo is < 1 or > 4)
            return;

        if (!await _bcrToggleGate.WaitAsync(0))
            return;

        var token = GetActiveToken();
        try
        {
            IsMonitorBusy = true;
            var result = await _api.ToggleBcrAsync(bcrNo, token);
            MonitorStatusMessage =
                $"BCR #{bcrNo} 판독을 {(result.IsEnabled ? "사용" : "미사용")}으로 변경했습니다.";
            MonitorErrorMessage = string.Empty;

            await RefreshAsync(token, waitForCurrent: true);
        }
        catch (OperationCanceledException) when (token.IsCancellationRequested)
        {
        }
        catch (Exception ex)
        {
            IsMonitorConnected = false;
            MonitorErrorMessage = ex.Message;
            MonitorStatusMessage = $"BCR #{bcrNo} 변경 실패: {ex.Message}";
        }
        finally
        {
            IsMonitorBusy = false;
            _bcrToggleGate.Release();
        }
    }

    /// <summary>
    /// T2TBCVC1.R.CH04의 12번째 비트(BIT11)를 확인한 뒤
    /// 0=입고 모드, 1=출고 모드로 전환합니다.
    /// </summary>
    private async Task ToggleBank2ModeAsync()
    {
        if (!await _bank2ModeToggleGate.WaitAsync(0))
            return;

        var token = GetActiveToken();
        try
        {
            IsMonitorBusy = true;

            var signals = await _conveyorSignalApi.GetAsync(token);
            var modeSignal = signals.SingleOrDefault(signal =>
                string.Equals(
                    signal.Direction,
                    Bank2ModeDirection,
                    StringComparison.OrdinalIgnoreCase)
                && signal.GridNo == Bank2ModeGridNo)
                ?? throw new InvalidOperationException(
                    "T2TBCVC1.R.CH04(PLC → COM Grid 4) 신호를 찾을 수 없습니다.");

            var bits = modeSignal.Bits?.Trim() ?? string.Empty;
            if (bits.Length != 16 || bits.Any(bit => bit is not ('0' or '1')))
            {
                throw new InvalidOperationException(
                    "T2TBCVC1.R.CH04 신호가 정상적인 16 BIT 값이 아닙니다.");
            }

            var isCurrentlyOutbound = bits[Bank2ModeBitIndex] == '1';
            var changeToOutbound = !isCurrentlyOutbound;
            var confirmMessage = changeToOutbound
                ? "출고 모드로 변경 하시겠습니까?"
                : "입고 모드로 변경 하시겠습니까?";

            if (!_dialog.ShowConfirm(confirmMessage, "2열 운전 모드 변경"))
            {
                MonitorStatusMessage = "2열 운전 모드 변경을 취소했습니다.";
                return;
            }

            await _conveyorSignalApi.UpdateBitAsync(
                Bank2ModeDirection,
                Bank2ModeGridNo,
                Bank2ModeBitIndex,
                new ConveyorSignalBitUpdateDto { IsActive = changeToOutbound },
                token);

            MonitorErrorMessage = string.Empty;

            await RefreshAsync(token, waitForCurrent: true);
            if (IsMonitorConnected)
            {
                MonitorStatusMessage = changeToOutbound
                    ? "2열을 출고 모드로 변경했습니다."
                    : "2열을 입고 모드로 변경했습니다.";
            }
        }
        catch (OperationCanceledException) when (token.IsCancellationRequested)
        {
        }
        catch (Exception ex)
        {
            IsMonitorConnected = false;
            MonitorErrorMessage = ex.Message;
            MonitorStatusMessage = $"2열 운전 모드 변경 실패: {ex.Message}";
        }
        finally
        {
            IsMonitorBusy = false;
            _bank2ModeToggleGate.Release();
        }
    }

    private async Task PollAsync(CancellationToken cancellationToken)
    {
        var interval = TimeSpan.FromMilliseconds(Math.Max(500, _settings.MonitorPollMs));

        try
        {
            using var timer = new PeriodicTimer(interval);
            while (await timer.WaitForNextTickAsync(cancellationToken))
                await RefreshAsync(cancellationToken);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
        }
    }

    private async Task PollPositionsAsync(CancellationToken cancellationToken)
    {
        // 통신 프로그램이 250ms(4Hz)마다 값을 기록해도 같은 주기의 위상 차이로
        // 놓치지 않도록 위치는 조금 더 빠른 기본 200ms 주기로 조회합니다.
        var interval = TimeSpan.FromMilliseconds(Math.Max(100, _settings.PositionPollMs));

        try
        {
            using var timer = new PeriodicTimer(interval);
            while (await timer.WaitForNextTickAsync(cancellationToken))
                await RefreshPositionsAsync(cancellationToken);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
        }
    }

    private Task RefreshAllAsync(
        CancellationToken cancellationToken,
        bool waitForCurrent = false) =>
        Task.WhenAll(
            RefreshAsync(cancellationToken, waitForCurrent),
            RefreshPositionsAsync(cancellationToken, waitForCurrent));

    private async Task RefreshAsync(
        CancellationToken cancellationToken,
        bool waitForCurrent = false)
    {
        if (waitForCurrent)
        {
            try
            {
                await _refreshGate.WaitAsync(cancellationToken);
            }
            catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
            {
                return;
            }
        }
        else if (!_refreshGate.Wait(0))
        {
            return;
        }

        IsMonitorBusy = true;
        try
        {
            var snapshot = await _api.GetSnapshotAsync(cancellationToken);
            cancellationToken.ThrowIfCancellationRequested();

            ApplySnapshot(snapshot);
            IsMonitorConnected = true;
            MonitorErrorMessage = string.Empty;
            MonitorLastUpdatedText = $"{snapshot.RetrievedAt:yyyy-MM-dd HH:mm:ss}";
            MonitorStatusMessage = "전체 창고 모니터링 신호 정상 수신";
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
        }
        catch (Exception ex)
        {
            IsMonitorConnected = false;
            MonitorErrorMessage = ex.Message;
            MonitorStatusMessage = $"모니터링 조회 실패: {ex.Message}";
        }
        finally
        {
            IsMonitorBusy = false;
            _refreshGate.Release();
        }
    }

    private async Task RefreshPositionsAsync(
        CancellationToken cancellationToken,
        bool waitForCurrent = false)
    {
        if (waitForCurrent)
        {
            try
            {
                await _positionRefreshGate.WaitAsync(cancellationToken);
            }
            catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
            {
                return;
            }
        }
        else if (!_positionRefreshGate.Wait(0))
        {
            // 이전 위치 요청이 끝나지 않았으면 요청을 쌓지 않고 이번 회차를 건너뜁니다.
            return;
        }

        try
        {
            var positions = await _api.GetEquipmentPositionsAsync(cancellationToken);
            cancellationToken.ThrowIfCancellationRequested();
            ApplyEquipmentPositions(positions);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
        }
        catch (Exception ex)
        {
            IsMonitorConnected = false;
            MonitorErrorMessage = $"설비 위치 조회 실패: {ex.Message}";
            MonitorStatusMessage = "S/C·RGV 위치 신호를 받지 못했습니다.";
        }
        finally
        {
            _positionRefreshGate.Release();
        }
    }

    private void ApplySnapshot(Sc1LineSnapshotDto snapshot)
    {
        IReadOnlyCollection<Sc1CraneStatusDto> cranes = snapshot.Cranes is { Count: > 0 }
            ? snapshot.Cranes
            : [snapshot.Crane];
        IReadOnlyCollection<Sc1BcrStatusDto> bcrs = snapshot.Bcrs is { Count: > 0 }
            ? snapshot.Bcrs
            : [snapshot.Bcr];
        IReadOnlyCollection<Sc1ConveyorSignalsDto> controllers =
            snapshot.ConveyorControllers is { Count: > 0 }
                ? snapshot.ConveyorControllers
                : [snapshot.ConveyorSignals];
        IReadOnlyCollection<Sc1InventorySummaryDto> inventories =
            snapshot.InventorySummaries is { Count: > 0 }
                ? snapshot.InventorySummaries
                : [snapshot.InventorySummary];

        // 위치는 별도의 고속 조회가 전담합니다. 전체 조회의 오래된 좌표가
        // 최신 위치를 되돌리지 않도록 여기서는 상태와 색상만 적용합니다.
        ApplyCranes(cranes, updatePosition: false);
        ApplyLineMode(snapshot.LineMode);
        ApplyBcrs(bcrs);
        ApplyOperators(controllers);
        ApplyStationReadyStates(controllers);
        ApplyRgvs(snapshot.Rgvs ?? [], snapshot.Tracks ?? [], updatePosition: false);
        ApplyTracks(snapshot.Tracks ?? []);
        ApplyInventory(inventories, snapshot.TotalInventorySummary);
        ApplyRackBays(snapshot.RackBays ?? []);

        Sc1OutboundReservations = new ObservableCollection<Sc1OutboundReservationRow>(
            (snapshot.OutboundSchedules ?? [])
            .OrderBy(item => Clean(item.InstructionDate))
            .ThenBy(item => Clean(item.InstructionTime))
            .ThenBy(item => ToText(item.Sequence))
            .Select(item => new Sc1OutboundReservationRow(
                ToText(item.Sequence),
                ToText(item.CraneNo),
                Clean(item.Location),
                Clean(item.WorkStation),
                item.IsEmergency ? "긴급" : string.Empty,
                Clean(item.InstructionDate),
                Clean(item.InstructionTime),
                Clean(item.PalletNo),
                Clean(item.JobType))));
    }

    private void ApplyEquipmentPositions(EquipmentPositionSnapshotDto snapshot)
    {
        var craneStates = CraneStates.ToDictionary(
            item => item.Key, item => item.Value, StringComparer.Ordinal);
        var craneChanged = false;

        foreach (var crane in (snapshot.Cranes ?? []).Where(
                     item => item.CraneNo is >= 1 and <= 7))
        {
            var key = $"{crane.CraneNo:00}";
            if (!craneStates.TryGetValue(key, out var previous))
                continue;

            var top = ResolveCraneCanvasTop(crane.CraneNo, crane.PositionBay);
            if (!top.HasValue || Math.Abs(previous.CanvasTop - top.Value) < 0.01d)
                continue;

            craneStates[key] = previous with { CanvasTop = top.Value };
            craneChanged = true;
        }

        if (craneChanged)
            CraneStates = craneStates;

        var rgvStates = RgvStates.ToDictionary(
            item => item.Key, item => item.Value, StringComparer.Ordinal);
        var rgvChanged = false;

        foreach (var rgv in (snapshot.Rgvs ?? []).Where(item => item.RgvNo is 1 or 2))
        {
            var key = $"{rgv.RgvNo:00}";
            if (!rgvStates.TryGetValue(key, out var previous))
                continue;

            var positionNo = ParseRgvPositionNumber(rgv.CurrentPosition);
            var left = ResolveRgvCanvasLeft(rgv.RgvNo, positionNo);
            if (!left.HasValue || Math.Abs(previous.CanvasLeft - left.Value) < 0.01d)
                continue;

            rgvStates[key] = previous with { CanvasLeft = left.Value };
            rgvChanged = true;
        }

        if (rgvChanged)
            RgvStates = rgvStates;
    }

    private void ApplyCranes(
        IReadOnlyCollection<Sc1CraneStatusDto> cranes,
        bool updatePosition = true)
    {
        var states = CreateEmptyCraneStates().ToDictionary(
            item => item.Key, item => item.Value, StringComparer.Ordinal);

        foreach (var crane in cranes.Where(item => item.CraneNo is >= 1 and <= 7))
        {
            var key = $"{crane.CraneNo:00}";
            var previousTop = CraneStates.TryGetValue(key, out var previous)
                ? previous.CanvasTop
                : DefaultCraneTop;
            states[key] = BuildCraneState(crane, previousTop, updatePosition);
        }

        CraneStates = states;
    }

    private void ApplyStationReadyStates(
        IReadOnlyCollection<Sc1ConveyorSignalsDto> controllers)
    {
        var states = CreateEmptyStationReadyStates().ToDictionary(
            item => item.Key, item => item.Value, StringComparer.Ordinal);
        var firstFloor = controllers.FirstOrDefault(item => item.ControllerNo == 1);
        var readyBits = firstFloor?.ReceiveCh06;

        // 평택 상품 링크 D5005 = T2TBCVC1.R.CH06
        // BIT00~06: SC01~07 입고 Ready / BIT09~15: SC01~07 출고 Ready
        for (var craneNo = 1; craneNo <= 7; craneNo++)
        {
            if (craneNo == 1)
            {
                states["01"] = IsBitOn(readyBits, 9);
                states["08"] = IsBitOn(readyBits, 0);
                continue;
            }

            var inboundTrack = 28 + ((craneNo - 2) * 6);
            states[$"{inboundTrack:00}"] = IsBitOn(readyBits, craneNo - 1);

            // 7호기는 14열 바깥쪽 출고 트래킹(59번)이 없는 구조입니다.
            if (craneNo < 7)
                states[$"{inboundTrack + 1:00}"] = IsBitOn(readyBits, craneNo + 8);
        }

        StationReadyStates = states;
    }

    private static CraneMonitorState BuildCraneState(
        Sc1CraneStatusDto crane,
        double previousTop,
        bool updatePosition)
    {
        var resolvedTop = ResolveCraneCanvasTop(crane.CraneNo, crane.PositionBay);
        var canvasTop = updatePosition && resolvedTop.HasValue
            ? resolvedTop.Value
            : previousTop;

        var (background, status) = crane switch
        {
            { HasError: true } => (ErrorBrush, "에러"),
            { IsOnline: false } => (StoppedBrush, "오프라인"),
            { IsReady: true } => (ReadyBrush, "READY"),
            _ => (WorkingBrush, "작업 중/대기 아님")
        };

        var toolTip = string.Join(Environment.NewLine,
            $"SC #{crane.CraneNo} · {status}",
            $"Cycle: {Clean(crane.Cycle)} · 작업: {Clean(crane.JobType)}",
            $"위치: {Clean(crane.Location)} (연 {crane.PositionBay}, 단 {crane.PositionLevel})",
            $"Station: {Clean(crane.WorkStation)} · Pallet: {Clean(crane.PalletNo)}",
            $"Online {OnOff(crane.IsOnline)} / Manual {OnOff(crane.IsManual)} / Ready {OnOff(crane.IsReady)} / Working {OnOff(crane.IsWorking)}",
            $"Home {OnOff(crane.IsHome)} / Fork Center {OnOff(crane.IsForkCentered)} / Pallet {OnOff(crane.HasPallet)}",
            $"Loading 완료 {OnOff(crane.IsLoadingComplete)} / Unloading 완료 {OnOff(crane.IsUnloadingComplete)}",
            crane.HasError
                ? $"오류: {Clean(crane.ErrorCode)} · {Clean(crane.ErrorDescription)}"
                : "오류 없음");

        return new CraneMonitorState(
            canvasTop,
            background,
            crane.HasPallet,
            crane.IsLoadingComplete,
            status,
            toolTip);
    }

    private void ApplyLineMode(Sc1LineModeDto mode)
    {
        IsBank1InboundAllowed = mode.Bank1CanInbound;
        IsBank1OutboundAllowed = mode.Bank1CanOutbound;
        IsBank2InboundAllowed = mode.Bank2CanInbound;
        IsBank2OutboundAllowed = mode.Bank2CanOutbound;

        Bank1ModeStatus = FormatMode(
            mode.Bank1ModeCode, mode.Bank1ModeDescription,
            mode.Bank1CanInbound, mode.Bank1CanOutbound);
        Bank2ModeStatus = FormatMode(
            mode.Bank2ModeCode, mode.Bank2ModeDescription,
            mode.Bank2CanInbound, mode.Bank2CanOutbound);

        Sc1ModeStatus = $"1열 {Bank1ModeStatus} / 2열 {Bank2ModeStatus}";
        Sc1ModeToolTip = string.Join(Environment.NewLine,
            $"SC1 라인 모드: {Sc1ModeStatus}",
            $"1열 입고 {Allowed(mode.Bank1CanInbound)}, 출고 {Allowed(mode.Bank1CanOutbound)}",
            $"2열 입고 {Allowed(mode.Bank2CanInbound)}, 출고 {Allowed(mode.Bank2CanOutbound)}",
            "2열 기준: T2TBCVC1.R.CH04 BIT11(12번째 비트)",
            "BIT11 값: 0=입고 / 1=출고",
            "문구를 클릭하면 반대 모드로 변경할 수 있습니다.");

        Bank1OutboundArrowVisibility = ToVisibility(mode.Bank1CanOutbound);
        Bank2InboundArrowVisibility = ToVisibility(mode.Bank2CanInbound);
        Bank2OutboundArrowVisibility = ToVisibility(mode.Bank2CanOutbound);

        Bank2AvailabilityText = mode.Bank2CanOutbound
            ? "출고 가능"
            : "입고 가능";
        Bank2AvailabilityVisibility = Visibility.Visible;
    }

    private void ApplyBcrs(IReadOnlyCollection<Sc1BcrStatusDto> bcrs)
    {
        var states = CreateEmptyBcrStates().ToDictionary(
            item => item.Key, item => item.Value, StringComparer.Ordinal);

        foreach (var bcr in bcrs.Where(item => item.BcrNo is >= 1 and <= 4))
        {
            var enabledText = bcr.IsEnabled ? "판독 사용" : "판독 미사용";
            var resultText = string.IsNullOrWhiteSpace(bcr.Message)
                ? string.Empty
                : bcr.Message.Trim();
            var background = bcr.IsEnabled ? BcrEnabledBrush : BcrDisabledBrush;

            states[$"{bcr.BcrNo:00}"] = new MonitorPointState(
                background,
                resultText,
                string.Join(Environment.NewLine,
                    $"BCR #{bcr.BcrNo} · {enabledText}",
                    $"리딩 결과: {(resultText.Length == 0 ? "대기" : resultText)}",
                    $"결과 트래킹: {Clean(bcr.ResultTrackNo)} · Flag: {Clean(bcr.ResultStatusCode)}",
                    "BCR 번호를 클릭하면 판독 사용/미사용이 전환됩니다."),
                bcr.IsEnabled ? 1d : 0.55d,
                Foreground: background);
        }

        BcrStates = states;
    }

    private void ApplyOperators(IReadOnlyCollection<Sc1ConveyorSignalsDto> controllers)
    {
        var byController = controllers
            .Where(item => item.ControllerNo is 1 or 2)
            .GroupBy(item => item.ControllerNo)
            .ToDictionary(group => group.Key, group => group.First());

        byController.TryGetValue(1, out var firstFloor);
        byController.TryGetValue(2, out var secondFloor);

        OperatorStates = new Dictionary<string, MonitorPointState>(StringComparer.Ordinal)
        {
            ["01"] = BuildOperatorState(1, IsBitOn(firstFloor?.ReceiveCh04, 13)),
            ["02"] = BuildOperatorState(2, IsBitOn(firstFloor?.ReceiveCh04, 14)),
            ["03"] = BuildOperatorState(3, IsBitOn(firstFloor?.ReceiveCh04, 15)),
            ["04"] = BuildOperatorState(4, IsBitOn(secondFloor?.ReceiveCh02, 0))
        };
    }

    private static MonitorPointState BuildOperatorState(int operatorNo, bool isAuto) => new(
        isAuto ? OperatorAutoBrush : ManualBrush,
        isAuto ? "자동" : "수동/정지",
        $"OP #{operatorNo} · {(isAuto ? "자동 운전" : "수동 또는 정지")}",
        isAuto ? 1d : 0.45d,
        Foreground: LightTextBrush);

    private void ApplyRgvs(
        IReadOnlyCollection<Sc1RgvStatusDto> rgvs,
        IReadOnlyCollection<Sc1TrackDto> tracks,
        bool updatePosition = true)
    {
        var states = CreateEmptyRgvStates().ToDictionary(
            item => item.Key, item => item.Value, StringComparer.Ordinal);
        var tracksByNumber = tracks
            .Select(item => (TrackNo: ParseTrackNo(item.TrackNo), Item: item))
            .Where(item => item.TrackNo is >= 1 and <= 84)
            .GroupBy(item => item.TrackNo)
            .ToDictionary(group => group.Key, group => group.First().Item);

        foreach (var rgv in rgvs.Where(item => item.RgvNo is 1 or 2))
        {
            var key = $"{rgv.RgvNo:00}";
            var previous = RgvStates.TryGetValue(key, out var current)
                ? current
                : CreateEmptyRgvState(rgv.RgvNo);
            states[key] = BuildRgvState(
                rgv, previous, tracksByNumber, updatePosition);
        }

        RgvStates = states;
    }

    private static RgvMonitorState BuildRgvState(
        Sc1RgvStatusDto rgv,
        RgvMonitorState previous,
        IReadOnlyDictionary<int, Sc1TrackDto> tracks,
        bool updatePosition)
    {
        var positionNo = ParseRgvPositionNumber(rgv.CurrentPosition);
        var positionLeft = ResolveRgvCanvasLeft(rgv.RgvNo, positionNo);
        var canvasLeft = updatePosition && positionLeft.HasValue
            ? positionLeft.Value
            : previous.CanvasLeft;
        // 유피케미컬 AS-IS의 표시 우선순위(에러→수동→Ready→작업중)를 사용하되,
        // 구형 소스의 ONLINE/AUTO 비트 혼용은 평택 LINK 정의에 맞게 분리한다.
        var (visualState, status) = rgv switch
        {
            { IsSignalValid: false } => (RgvVisualState.Unknown, "조회 대기"),
            { HasError: true } => (RgvVisualState.Error, "에러"),
            { IsOnline: false } => (RgvVisualState.Manual, "오프라인"),
            { IsAuto: false } => (RgvVisualState.Manual, "수동 상태"),
            { IsReady: true } => (RgvVisualState.Ready, "준비 완료"),
            _ => (RgvVisualState.Working, "작업 중")
        };

        var defaultTrackNo = rgv.RgvNo == 1 ? 25 : 82;
        tracks.TryGetValue(defaultTrackNo, out var track);

        var toolTipLines = new List<string>
        {
            $"RGV #{rgv.RgvNo} · {status}",
            $"현재 위치: {FormatRgvPosition(rgv.CurrentPosition)} · 지령: {FormatRgvPosition(rgv.FromPosition)} → {FormatRgvPosition(rgv.ToPosition)}",
            $"Online {OnOff(rgv.IsOnline)} / Auto {OnOff(rgv.IsAuto)} / Ready {OnOff(rgv.IsReady)} / ACK {OnOff(rgv.IsAcknowledged)}",
            $"Pallet {OnOff(rgv.HasPallet)} / Loading 완료 {OnOff(rgv.IsLoadingComplete)} / Unloading 완료 {OnOff(rgv.IsUnloadingComplete)}",
            rgv.HasError
                ? $"오류: {Clean(rgv.ErrorCode)} · {Clean(rgv.ErrorDescription)}"
                : "오류 없음",
            $"신호: {Clean(rgv.ReceiveBits)}",
            $"상태 원본: {Clean(rgv.StatusSource)}"
        };

        if (track is not null)
        {
            toolTipLines.Add(
                $"PLT{defaultTrackNo:00} Tracking · Index: {ToText(track.Index)} · Flag: {Clean(track.Flag)}");
        }

        return new RgvMonitorState(
            canvasLeft,
            previous.DisplayNo,
            visualState,
            rgv.HasPallet,
            rgv.IsLoadingComplete,
            track?.HasTrackingData == true,
            status,
            string.Join(Environment.NewLine, toolTipLines));
    }

    private void ApplyTracks(IReadOnlyCollection<Sc1TrackDto> tracks)
    {
        var byTrackNo = tracks
            .Select(item => (TrackNo: ParseTrackNo(item.TrackNo), Item: item))
            .Where(item => item.TrackNo is >= 1 and <= 84)
            .GroupBy(item => item.TrackNo)
            .ToDictionary(group => group.Key, group => group.First().Item);

        var states = new Dictionary<string, TrackingMonitorState>(StringComparer.Ordinal);
        foreach (var trackNo in DisplayedTrackNumbers)
            states[$"{trackNo:00}"] = BuildTrackState(
                trackNo, byTrackNo.GetValueOrDefault(trackNo));

        TrackStates = states;

        Sc1TrackingItems = new ObservableCollection<Sc1TrackingRow>(
            tracks
                .Where(item => item.HasPhysicalPallet || item.HasTrackingData)
                .OrderBy(item => ParseTrackNo(item.TrackNo))
                .Select(item => new Sc1TrackingRow(
                    ToText(item.Index),
                    Clean(item.Location),
                    Clean(item.JobType),
                    Clean(item.Date),
                    Clean(item.Time),
                    ParseTrackNo(item.TrackNo),
                    Clean(item.From),
                    Clean(item.To),
                    Clean(item.Flag),
                    item.HasPhysicalPallet,
                    item.HasTrackingData)));
    }

    private static TrackingMonitorState BuildTrackState(int trackNo, Sc1TrackDto? track)
    {
        if (track is null)
            return EmptyTrackState(trackNo);

        var (visualState, status) =
            (track.HasPhysicalPallet, track.HasTrackingData) switch
            {
                (true, true) => (TrackingVisualState.PalletAndData, "팔레트 유 + 데이터 유"),
                (true, false) => (TrackingVisualState.PalletOnly, "팔레트 유"),
                (false, true) => (TrackingVisualState.DataOnly, "데이터 유"),
                _ => (TrackingVisualState.Empty, "비어 있음")
            };

        return new TrackingMonitorState(
            visualState,
            status,
            string.Join(Environment.NewLine,
                $"PLT{trackNo:00} · {status}",
                $"Index: {ToText(track.Index)} · 작업: {Clean(track.JobType)}",
                $"위치: {Clean(track.Location)} · Station: {Clean(track.WorkStation)}",
                $"From: {Clean(track.From)} → To: {Clean(track.To)}",
                $"Flag: {Clean(track.Flag)} · {Clean(track.Date)} {Clean(track.Time)}"));
    }

    private void ApplyInventory(
        IReadOnlyCollection<Sc1InventorySummaryDto> inventories,
        Sc1InventorySummaryDto total)
    {
        var states = CreateEmptyInventoryStates().ToDictionary(
            item => item.Key, item => item.Value, StringComparer.Ordinal);

        foreach (var inventory in inventories.Where(item => item.CraneNo is >= 1 and <= 7))
            states[$"{inventory.CraneNo:00}"] = BuildInventoryState(inventory);

        InventoryStates = states;
        InventoryGoods = states["01"];
        InventoryProducts = AggregateInventory(
            Enumerable.Range(2, 6).Select(craneNo => states[$"{craneNo:00}"]));
        InventoryTotal = BuildInventoryState(total);
    }

    private static InventoryMonitorState BuildInventoryState(Sc1InventorySummaryDto inventory) => new(
        inventory.TotalCells,
        inventory.UsedCells,
        inventory.EmptyCells,
        inventory.ProhibitedCells,
        inventory.AvailableCells,
        Convert.ToDouble(inventory.OccupancyRate, CultureInfo.InvariantCulture));

    private static InventoryMonitorState AggregateInventory(
        IEnumerable<InventoryMonitorState> inventories)
    {
        var rows = inventories.ToArray();
        var totalCells = rows.Sum(item => item.TotalCells);
        var usedCells = rows.Sum(item => item.UsedCells);
        var emptyCells = rows.Sum(item => item.EmptyCells);
        var prohibitedCells = rows.Sum(item => item.ProhibitedCells);
        var availableCells = rows.Sum(item => item.AvailableCells);
        var usableCells = Math.Max(0, totalCells - prohibitedCells);
        var occupancyRate = usableCells == 0
            ? 0d
            : (double)Math.Round(usedCells * 100m / usableCells, 1);

        return new InventoryMonitorState(
            totalCells,
            usedCells,
            emptyCells,
            prohibitedCells,
            availableCells,
            occupancyRate);
    }

    private void ApplyRackBays(IReadOnlyCollection<Sc1RackBaySummaryDto> rackBays)
    {
        Sc1RackBaySummaries = rackBays.ToArray();

        var states = CreateEmptyRackBayStates().ToDictionary(
            item => item.Key, item => item.Value, StringComparer.Ordinal);

        foreach (var rackBay in rackBays)
        {
            var bank = ParseNumber(rackBay.Bank);
            var bay = ParseNumber(rackBay.Bay);
            var key = $"{bank:00}{bay:00}";
            if (!states.ContainsKey(key))
                continue;

            var (background, status) = rackBay switch
            {
                { ProhibitedCells: > 0 } => (RackProhibitedBrush, "금지 셀"),
                { DoubleStorageCells: > 0 } => (RackDoubleStorageBrush, "이중격납"),
                { EmptyRetrievalCells: > 0 } => (RackEmptyRetrievalBrush, "공출고"),
                { InboundCells: > 0 } => (RackInboundBrush, "입고 작업"),
                { OutboundCells: > 0 } => (RackOutboundBrush, "출고 작업"),
                _ => (RackNormalBrush, "정상")
            };

            states[key] = new MonitorPointState(
                background,
                status,
                string.Join(Environment.NewLine,
                    $"Rack {bank:00}-{bay:00} · {status}",
                    $"전체 {rackBay.TotalCells} / 사용 {rackBay.UsedCells} / 빈 셀 {rackBay.EmptyCells}",
                    $"입고 {rackBay.InboundCells} / 출고 {rackBay.OutboundCells}",
                    $"이중격납 {rackBay.DoubleStorageCells} / 공출고 {rackBay.EmptyRetrievalCells} / 금지 {rackBay.ProhibitedCells}"));
        }

        RackBayStates = states;
    }

    private static TrackingMonitorState EmptyTrackState(int trackNo) => new(
        TrackingVisualState.Unknown,
        "조회 대기",
        $"PLT{trackNo:00} 상태를 조회하지 않았습니다.");

    private static IReadOnlyDictionary<string, CraneMonitorState> CreateEmptyCraneStates()
    {
        var states = new Dictionary<string, CraneMonitorState>(StringComparer.Ordinal);
        for (var craneNo = 1; craneNo <= 7; craneNo++)
        {
            states[$"{craneNo:00}"] = new CraneMonitorState(
                DefaultCraneTop,
                ManualBrush,
                false,
                false,
                "조회 대기",
                $"SC #{craneNo} 상태를 조회하지 않았습니다.");
        }

        return states;
    }

    private static IReadOnlyDictionary<string, bool> CreateEmptyStationReadyStates() =>
        new Dictionary<string, bool>(StringComparer.Ordinal)
        {
            ["01"] = false,
            ["08"] = false,
            ["28"] = false,
            ["29"] = false,
            ["34"] = false,
            ["35"] = false,
            ["40"] = false,
            ["41"] = false,
            ["46"] = false,
            ["47"] = false,
            ["52"] = false,
            ["53"] = false,
            ["58"] = false
        };

    private static IReadOnlyDictionary<string, TrackingMonitorState> CreateEmptyTrackStates()
    {
        var states = new Dictionary<string, TrackingMonitorState>(StringComparer.Ordinal);
        foreach (var trackNo in DisplayedTrackNumbers)
            states[$"{trackNo:00}"] = EmptyTrackState(trackNo);
        return states;
    }

    private static IReadOnlyDictionary<string, RgvMonitorState> CreateEmptyRgvStates() =>
        new Dictionary<string, RgvMonitorState>(StringComparer.Ordinal)
        {
            ["01"] = CreateEmptyRgvState(1),
            ["02"] = CreateEmptyRgvState(2)
        };

    private static RgvMonitorState CreateEmptyRgvState(int rgvNo) => new(
        DefaultRgvCanvasLeft,
        rgvNo == 1 ? "25" : "82",
        RgvVisualState.Unknown,
        false,
        false,
        false,
        "조회 대기",
        $"RGV #{rgvNo} 상태를 조회하지 않았습니다.");

    private static IReadOnlyDictionary<string, MonitorPointState> CreateEmptyBcrStates()
    {
        var states = new Dictionary<string, MonitorPointState>(StringComparer.Ordinal);
        for (var bcrNo = 1; bcrNo <= 4; bcrNo++)
        {
            states[$"{bcrNo:00}"] = new MonitorPointState(
                BcrDisabledBrush,
                string.Empty,
                $"BCR #{bcrNo} 상태를 조회하지 않았습니다.",
                0.35d,
                Foreground: BcrDisabledBrush);
        }

        return states;
    }

    private static IReadOnlyDictionary<string, MonitorPointState> CreateEmptyOperatorStates()
    {
        var states = new Dictionary<string, MonitorPointState>(StringComparer.Ordinal);
        for (var operatorNo = 1; operatorNo <= 4; operatorNo++)
        {
            states[$"{operatorNo:00}"] = new MonitorPointState(
                ManualBrush,
                "조회 대기",
                $"OP #{operatorNo} 상태를 조회하지 않았습니다.",
                0.35d,
                Foreground: LightTextBrush);
        }

        return states;
    }

    private static IReadOnlyDictionary<string, InventoryMonitorState> CreateEmptyInventoryStates()
    {
        var states = new Dictionary<string, InventoryMonitorState>(StringComparer.Ordinal);
        for (var craneNo = 1; craneNo <= 7; craneNo++)
            states[$"{craneNo:00}"] = InventoryMonitorState.Empty;
        return states;
    }

    private static IReadOnlyDictionary<string, MonitorPointState> CreateEmptyRackBayStates()
    {
        var states = new Dictionary<string, MonitorPointState>(StringComparer.Ordinal);
        for (var bank = 1; bank <= 14; bank++)
        {
            var firstBay = bank is >= 3 and <= 13 ? 2 : 1;
            var lastBay = bank <= 2 ? 9 : 15;
            for (var bay = firstBay; bay <= lastBay; bay++)
            {
                var key = $"{bank:00}{bay:00}";
                states[key] = new MonitorPointState(
                    RackNormalBrush,
                    "조회 대기",
                    $"Rack {bank:00}-{bay:00} 상태를 조회하지 않았습니다.",
                    0.65d);
            }
        }

        return states;
    }

    private CancellationToken GetActiveToken()
    {
        lock (_lifecycleSync)
            return _activationCts?.Token ?? CancellationToken.None;
    }

    private static string FormatMode(
        string? code, string? description, bool canInbound, bool canOutbound)
    {
        var text = Clean(description);
        if (text == "-")
        {
            text = (canInbound, canOutbound) switch
            {
                (true, true) => "입출고",
                (true, false) => "입고",
                (false, true) => "출고",
                _ => "사용 불가"
            };
        }

        var cleanCode = Clean(code);
        return cleanCode == "-" ? text : $"{text}({cleanCode})";
    }

    private static bool IsBitOn(string? bits, int index)
    {
        var value = bits?.Trim();
        return value is not null && index >= 0 && index < value.Length && value[index] == '1';
    }

    private static int ParseTrackNo(string? value) => ParseNumber(value);

    private static double? ResolveCraneCanvasTop(int craneNo, int positionBay)
    {
        if (craneNo is < 1 or > 7)
            return null;

        var lastBay = craneNo == 1 ? 9 : 15;
        if (positionBay < 1 || positionBay > lastBay)
            return null;

        var bayPitch = craneNo == 1 ? Sc1BayPitch : ProductCraneBayPitch;
        return CraneRailTop + ((lastBay - positionBay) * bayPitch);
    }

    private static double? ResolveRgvCanvasLeft(int rgvNo, int positionNo)
    {
        // 하부 RGV #1은 11~58, 상부 RGV #2는 60~84 구간에서만 움직인다.
        // 잘못된 호기/구간 조합은 직전 위치를 유지하도록 null을 반환한다.
        if ((rgvNo == 1 && positionNo is not (>= 11 and <= 58)) ||
            (rgvNo == 2 && positionNo is not (>= 60 and <= 84)) ||
            rgvNo is < 1 or > 2)
        {
            return null;
        }

        // 참조 Delphi의 `현재 위치와 같은 PLT 컨트롤을 찾아 이동` 규칙을
        // 현재 WPF 도면 좌표로 옮긴 값입니다. 같은 세로 라인의 구간은 같은 X를 사용합니다.
        var trackLeft = positionNo switch
        {
            11 or 12 => 212d,
            13 => 181d,
            14 or 15 or 26 or 27 or 28 or 60 or 61 => 150d,
            16 => 244d,
            17 or 24 => 275d,
            18 => 306d,
            19 or 20 => 337d,
            21 => 368d,
            22 or 23 => 399d,
            29 or 30 or 31 or 62 or 63 => 216d,
            32 or 33 or 34 or 64 or 65 => 250d,
            35 or 36 or 37 or 66 or 67 => 316d,
            38 or 39 or 40 or 68 or 69 or 83 => 350d,
            41 or 42 or 43 or 70 or 71 or 84 => 416d,
            44 or 45 or 46 or 72 or 73 => 450d,
            47 or 48 or 49 or 74 or 75 => 516d,
            50 or 51 or 52 or 76 or 77 => 550d,
            53 or 54 or 55 or 78 or 79 => 616d,
            56 or 57 or 58 or 80 or 81 => 650d,
            25 or 82 => DefaultRgvCanvasLeft + 14d,
            _ => double.NaN
        };

        // PLT 셀(30)과 RGV 대차(58)의 중심을 맞춘다.
        return double.IsNaN(trackLeft) ? null : trackLeft - 14d;
    }

    private static string FormatRgvPosition(string? value)
    {
        var number = ParseRgvPositionNumber(value);
        return number > 0
            ? number.ToString("00", CultureInfo.InvariantCulture)
            : "-";
    }

    private static int ParseRgvPositionNumber(string? value)
    {
        var text = value?.Trim();
        if (string.IsNullOrEmpty(text))
            return 0;

        // AS-IS는 CH02의 첫 문자를 설비/층 구분으로 보고 뒤 3자리를 위치번호로 사용한다.
        // 0014, 1014, A014 형식을 모두 평택 트래킹 14번으로 해석한다.
        var digits = new string(text.Where(char.IsDigit).ToArray());
        if (digits.Length >= 3 &&
            int.TryParse(digits[^3..], NumberStyles.Integer,
                CultureInfo.InvariantCulture, out var trailingNumber))
        {
            return trailingNumber;
        }

        return ParseNumber(text);
    }

    private static int ParseNumber(string? value)
        => int.TryParse(value?.Trim(), NumberStyles.Integer,
            CultureInfo.InvariantCulture, out var number)
            ? number
            : 0;

    private static string Clean(string? value)
        => string.IsNullOrWhiteSpace(value) ? "-" : value.Trim();

    private static string ToText(object? value)
        => Convert.ToString(value, CultureInfo.InvariantCulture)?.Trim() ?? string.Empty;

    private static string OnOff(bool value) => value ? "ON" : "OFF";
    private static string Allowed(bool value) => value ? "허용" : "금지";
    private static Visibility ToVisibility(bool value)
        => value ? Visibility.Visible : Visibility.Collapsed;

    private static Brush CreateBrush(byte red, byte green, byte blue)
    {
        var brush = new SolidColorBrush(Color.FromRgb(red, green, blue));
        brush.Freeze();
        return brush;
    }

    private static async Task DisposeAfterStopAsync(
        CancellationTokenSource cts, params Task?[] pollingTasks)
    {
        try
        {
            var activeTasks = pollingTasks.OfType<Task>().ToArray();
            if (activeTasks.Length > 0)
                await Task.WhenAll(activeTasks);
        }
        catch (OperationCanceledException)
        {
        }
        finally
        {
            cts.Dispose();
        }
    }

    public override void Dispose()
    {
        lock (_lifecycleSync)
        {
            if (_disposed)
                return;
            _disposed = true;
        }

        Deactivate();
        base.Dispose();
    }
}
