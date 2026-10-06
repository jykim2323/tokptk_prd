namespace TOK.WMS.Core.DTOs.Monitoring;

/// <summary>모니터링 화면의 트래킹 구간 상세 정보.</summary>
public sealed class MonitoringTrackDetailDto
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
}

/// <summary>T2TBTRAK 한 구간을 등록(갱신)할 때 사용하는 값.</summary>
public sealed class MonitoringTrackUpdateRequest
{
    public string Index { get; set; } = string.Empty;
    public string JobType { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string WorkStation { get; set; } = string.Empty;
    public string From { get; set; } = string.Empty;
    public string To { get; set; } = string.Empty;
    public string Flag { get; set; } = string.Empty;
    public string Date { get; set; } = string.Empty;
    public string Time { get; set; } = string.Empty;
}

/// <summary>T2TBTRAK의 데이터를 다른 트래킹 구간으로 이동할 때 사용하는 값.</summary>
public sealed class MonitoringTrackMoveRequest
{
    public string DestinationTrackNo { get; set; } = string.Empty;
}

/// <summary>스태커 크레인 작업관리 팝업에 표시하는 현재 작업 상태.</summary>
public sealed class MonitoringStackerWorkDto
{
    public int CraneNo { get; set; }
    public string Cycle { get; set; } = string.Empty;
    public string Online { get; set; } = string.Empty;
    public string Ready { get; set; } = string.Empty;
    public string Home { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string Centered { get; set; } = string.Empty;
    public string Acknowledged { get; set; } = string.Empty;
    public string LoadComplete { get; set; } = string.Empty;
    public string UnloadComplete { get; set; } = string.Empty;
    public string HasPallet { get; set; } = string.Empty;
    public string PositionBay { get; set; } = string.Empty;
    public string PositionLevel { get; set; } = string.Empty;
    public string Error { get; set; } = string.Empty;
    public string JobIndex { get; set; } = string.Empty;
    public string JobType { get; set; } = string.Empty;
    public string WorkStation { get; set; } = string.Empty;
    public string Height { get; set; } = string.Empty;
    public string ErrorDescription { get; set; } = string.Empty;
    public string PalletNo { get; set; } = string.Empty;
}

public sealed class MonitoringStackerReissueRequest
{
    public bool HasForkPallet { get; set; }
}

/// <summary>랙 한 셀의 요약 정보. 열별 셀 현황 팝업에서 사용한다.</summary>
public sealed class MonitoringRackCellDto
{
    public string Location { get; set; } = string.Empty;
    public string Bank { get; set; } = string.Empty;
    public string Bay { get; set; } = string.Empty;
    public string Level { get; set; } = string.Empty;
    public string Flag { get; set; } = string.Empty;
    public string StatusName { get; set; } = string.Empty;
    public string InDate { get; set; } = string.Empty;
    public string InTime { get; set; } = string.Empty;
    public string PalletNo { get; set; } = string.Empty;
}

/// <summary>셀에 들어 있는 품목 한 건.</summary>
public sealed class MonitoringRackInventoryDto
{
    public string Flag { get; set; } = string.Empty;
    public string PalletNo { get; set; } = string.Empty;
    public string ItemCode { get; set; } = string.Empty;
    public string ItemName { get; set; } = string.Empty;
    public string LotNo { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public decimal ReservedQuantity { get; set; }
    public string BoxNo { get; set; } = string.Empty;
    public string Remark { get; set; } = string.Empty;
    public string InDate { get; set; } = string.Empty;
    public string InTime { get; set; } = string.Empty;
}

/// <summary>셀 재고 등록·수정 값과 수정 전 조회한 원본.</summary>
public sealed class MonitoringRackInventorySaveRequest
{
    public MonitoringRackInventoryDto Item { get; set; } = new();
    public MonitoringRackInventoryDto? Original { get; set; }
    public string UserId { get; set; } = string.Empty;
}

/// <summary>셀 재고 삭제 전에 조회한 원본.</summary>
public sealed class MonitoringRackInventoryDeleteRequest
{
    public MonitoringRackInventoryDto Original { get; set; } = new();
}

/// <summary>셀 마스터와 그 셀의 실제 재고를 함께 내려 주는 상세 정보.</summary>
public sealed class MonitoringRackCellDetailDto
{
    public MonitoringRackCellDto Cell { get; set; } = new();
    public IReadOnlyList<MonitoringRackInventoryDto> InventoryItems { get; set; } = [];
}
