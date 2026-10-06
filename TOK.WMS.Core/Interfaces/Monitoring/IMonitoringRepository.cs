using TOK.WMS.Core.DTOs.Monitoring;

namespace TOK.WMS.Core.Interfaces.Monitoring;

public interface IMonitoringRepository
{
    Task<Sc1LineSnapshotDto> GetSc1LineSnapshotAsync(
        CancellationToken cancellationToken = default);

    Task<EquipmentPositionSnapshotDto> GetEquipmentPositionsAsync(
        CancellationToken cancellationToken = default);

    Task<BcrToggleResultDto> ToggleBcrAsync(
        int bcrNo,
        CancellationToken cancellationToken = default);

    Task<MonitoringTrackDetailDto?> GetTrackAsync(
        string trackNo,
        CancellationToken cancellationToken = default);

    Task SaveTrackAsync(
        string trackNo,
        MonitoringTrackUpdateRequest request,
        CancellationToken cancellationToken = default);

    Task DeleteTrackAsync(
        string trackNo,
        CancellationToken cancellationToken = default);

    Task MoveTrackAsync(
        string sourceTrackNo,
        string destinationTrackNo,
        CancellationToken cancellationToken = default);

    Task<MonitoringStackerWorkDto?> GetStackerWorkAsync(
        int craneNo,
        CancellationToken cancellationToken = default);

    Task ReissueStackerAsync(
        int craneNo,
        bool hasForkPallet,
        CancellationToken cancellationToken = default);

    Task CompleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken = default);

    Task ForceDeleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken = default);

    Task ClearStackerErrorAsync(
        int craneNo,
        CancellationToken cancellationToken = default);

    Task<IReadOnlyList<MonitoringRackCellDto>> GetRackCellsAsync(
        int bank,
        CancellationToken cancellationToken = default);

    Task<MonitoringRackCellDetailDto?> GetRackCellDetailAsync(
        string location,
        CancellationToken cancellationToken = default);

    Task SetRackCellUsageAsync(
        string location,
        bool isProhibited,
        CancellationToken cancellationToken = default);

    Task AddRackInventoryAsync(
        string location,
        MonitoringRackInventorySaveRequest request,
        CancellationToken cancellationToken = default);

    Task UpdateRackInventoryAsync(
        string location,
        MonitoringRackInventorySaveRequest request,
        CancellationToken cancellationToken = default);

    Task DeleteRackInventoryAsync(
        string location,
        MonitoringRackInventoryDeleteRequest request,
        CancellationToken cancellationToken = default);
}
