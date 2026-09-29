namespace TOK.WMS.Core.DTOs.Monitoring;

/// <summary>
/// 모니터링 설비의 위치만 빠르게 갱신하기 위한 경량 응답입니다.
/// 상태·재고·트래킹 전체 조회와 분리해 짧은 주기로 호출합니다.
/// </summary>
public sealed class EquipmentPositionSnapshotDto
{
    public DateTimeOffset RetrievedAt { get; set; }
    public IReadOnlyList<ScCranePositionDto> Cranes { get; set; } = [];
    public IReadOnlyList<RgvPositionDto> Rgvs { get; set; } = [];
}

public sealed class ScCranePositionDto
{
    public int CraneNo { get; set; }
    public int PositionBay { get; set; }
    public int PositionLevel { get; set; }
}

public sealed class RgvPositionDto
{
    public int RgvNo { get; set; }
    public string CurrentPosition { get; set; } = string.Empty;
}
