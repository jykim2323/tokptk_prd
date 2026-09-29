namespace TOK.WMS.UI.Views.Monitoring.Models;

/// <summary>
/// 스태커 크레인별 적재 현황 표시값입니다.
/// </summary>
public sealed record InventoryMonitorState(
    int TotalCells,
    int UsedCells,
    int EmptyCells,
    int ProhibitedCells,
    int AvailableCells,
    double OccupancyRate)
{
    public static InventoryMonitorState Empty { get; } = new(0, 0, 0, 0, 0, 0d);
}
