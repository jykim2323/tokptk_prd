namespace TOK.WMS.Core.DTOs.Monitoring;

public sealed class Sc1LineSnapshotDto
{
    public DateTimeOffset RetrievedAt { get; set; }
    public Sc1CraneStatusDto Crane { get; set; } = new();
    public IReadOnlyList<Sc1CraneStatusDto> Cranes { get; set; } = [];
    public Sc1LineModeDto LineMode { get; set; } = new();
    public Sc1BcrStatusDto Bcr { get; set; } = new();
    public IReadOnlyList<Sc1BcrStatusDto> Bcrs { get; set; } = [];
    public Sc1ConveyorSignalsDto ConveyorSignals { get; set; } = new();
    public IReadOnlyList<Sc1ConveyorSignalsDto> ConveyorControllers { get; set; } = [];
    public IReadOnlyList<Sc1RgvStatusDto> Rgvs { get; set; } = [];
    public IReadOnlyList<Sc1TrackDto> Tracks { get; set; } = [];
    public IReadOnlyList<Sc1RackBaySummaryDto> RackBays { get; set; } = [];
    public Sc1InventorySummaryDto InventorySummary { get; set; } = new();
    public IReadOnlyList<Sc1InventorySummaryDto> InventorySummaries { get; set; } = [];
    public Sc1InventorySummaryDto TotalInventorySummary { get; set; } = new();
    public IReadOnlyList<Sc1OutboundScheduleDto> OutboundSchedules { get; set; } = [];
}

public sealed class Sc1CraneStatusDto
{
    public int CraneNo { get; set; } = 1;
    public string Cycle { get; set; } = string.Empty;
    public bool IsOnline { get; set; }
    public bool IsReady { get; set; }
    public bool IsManual { get; set; }
    public bool IsWorking { get; set; }
    public bool IsHome { get; set; }
    public string Location { get; set; } = string.Empty;
    public bool IsForkCentered { get; set; }
    public bool IsAcknowledged { get; set; }
    public bool CanLoad { get; set; }
    public bool CanUnload { get; set; }
    public bool HasPallet { get; set; }
    public bool IsLoadingComplete { get; set; }
    public bool IsUnloadingComplete { get; set; }
    public int PositionBay { get; set; }
    public int PositionLevel { get; set; }
    public bool HasError { get; set; }
    public string ErrorCode { get; set; } = string.Empty;
    public string PalletNo { get; set; } = string.Empty;
    public string JobIndex { get; set; } = string.Empty;
    public string JobType { get; set; } = string.Empty;
    public string WorkStation { get; set; } = string.Empty;
    public string ErrorDescription { get; set; } = string.Empty;
}

public sealed class Sc1LineModeDto
{
    public string Bank1ModeCode { get; set; } = "O";
    public string Bank1ModeDescription { get; set; } = "출고 전용";
    public bool Bank1CanInbound { get; set; }
    public bool Bank1CanOutbound { get; set; } = true;
    public string Bank2ModeCode { get; set; } = string.Empty;
    public string Bank2ModeDescription { get; set; } = "상태 확인 불가";
    public bool Bank2CanInbound { get; set; }
    public bool Bank2CanOutbound { get; set; }
}

public sealed class Sc1BcrStatusDto
{
    public int BcrNo { get; set; } = 1;
    public int InstalledBank { get; set; } = 2;
    public string StatusCode { get; set; } = string.Empty;
    public bool IsEnabled { get; set; }
    public bool IsNormal { get; set; }
    public string ResultTrackNo { get; set; } = string.Empty;
    public string ResultStatusCode { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
}

public sealed class Sc1ConveyorSignalsDto
{
    public int ControllerNo { get; set; } = 1;
    public string ReceiveCh01 { get; set; } = string.Empty;
    public string ReceiveCh02 { get; set; } = string.Empty;
    public string ReceiveCh03 { get; set; } = string.Empty;
    public string ReceiveCh04 { get; set; } = string.Empty;
    public string ReceiveCh05 { get; set; } = string.Empty;
    public string ReceiveCh06 { get; set; } = string.Empty;
    public string ReceiveCh07 { get; set; } = string.Empty;
    public string SendCh01 { get; set; } = string.Empty;
    public string SendCh02 { get; set; } = string.Empty;
    public string SendCh03 { get; set; } = string.Empty;
    public string SendCh04 { get; set; } = string.Empty;
    public string SendCh05 { get; set; } = string.Empty;
    public string SendCh06 { get; set; } = string.Empty;
    public string SendCh07 { get; set; } = string.Empty;
}

/// <summary>
/// RGV 링크 테이블의 수신/송신 상태를 모니터링 화면에서 사용할 형태로 정리한 값입니다.
/// </summary>
public sealed class Sc1RgvStatusDto
{
    public int RgvNo { get; set; }
    public bool IsSignalValid { get; set; }
    public bool IsOnline { get; set; }
    public bool IsAuto { get; set; }
    public bool IsReady { get; set; }
    public bool IsAcknowledged { get; set; }
    public bool HasPallet { get; set; }
    public bool IsLoadingComplete { get; set; }
    public bool IsUnloadingComplete { get; set; }
    public bool HasError { get; set; }
    public string CurrentPosition { get; set; } = string.Empty;
    public string ErrorCode { get; set; } = string.Empty;
    public string ErrorDescription { get; set; } = string.Empty;
    public string FromPosition { get; set; } = string.Empty;
    public string ToPosition { get; set; } = string.Empty;
    public string ReceiveBits { get; set; } = string.Empty;
    public string SendBits { get; set; } = string.Empty;
    public string StatusSource { get; set; } = string.Empty;
}

public sealed class Sc1TrackDto
{
    public string TrackNo { get; set; } = string.Empty;
    public string Index { get; set; } = string.Empty;
    public string JobType { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string WorkStation { get; set; } = string.Empty;
    public string From { get; set; } = string.Empty;
    public string To { get; set; } = string.Empty;
    public string Flag { get; set; } = string.Empty;
    public string Date { get; set; } = string.Empty;
    public string Time { get; set; } = string.Empty;
    public bool HasPhysicalPallet { get; set; }
    public bool HasTrackingData { get; set; }
}

public sealed class Sc1RackBaySummaryDto
{
    public string Bank { get; set; } = string.Empty;
    public string Bay { get; set; } = string.Empty;
    public int TotalCells { get; set; }
    public int UsedCells { get; set; }
    public int EmptyCells { get; set; }
    public int InboundCells { get; set; }
    public int OutboundCells { get; set; }
    public int DoubleStorageCells { get; set; }
    public int EmptyRetrievalCells { get; set; }
    public int ProhibitedCells { get; set; }
}

public sealed class Sc1InventorySummaryDto
{
    public int CraneNo { get; set; }
    public int TotalCells { get; set; }
    public int UsedCells { get; set; }
    public int EmptyCells { get; set; }
    public int ProhibitedCells { get; set; }
    public int AvailableCells { get; set; }
    public decimal OccupancyRate { get; set; }
}

public sealed class BcrToggleResultDto
{
    public int BcrNo { get; set; }
    public string StatusCode { get; set; } = string.Empty;
    public bool IsEnabled { get; set; }
}

public sealed class Sc1OutboundScheduleDto
{
    public string Sequence { get; set; } = string.Empty;
    public int CraneNo { get; set; } = 1;
    public string Location { get; set; } = string.Empty;
    public string WorkStation { get; set; } = string.Empty;
    public bool IsEmergency { get; set; }
    public string InstructionDate { get; set; } = string.Empty;
    public string InstructionTime { get; set; } = string.Empty;
    public string PalletNo { get; set; } = string.Empty;
    public string JobType { get; set; } = string.Empty;
}
