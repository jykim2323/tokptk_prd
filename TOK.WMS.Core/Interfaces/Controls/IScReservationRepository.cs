using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.Core.Interfaces.Controls;

public interface IScReservationRepository
{
    Task<IReadOnlyList<ScReservationDto>> GetAsync(
        ScReservationQueryDto query,
        CancellationToken cancellationToken = default);

    Task UpdateWorkStationAsync(
        int craneNo,
        string sequence,
        ScReservationWorkStationUpdateDto values,
        CancellationToken cancellationToken = default);

    Task DeleteAsync(
        int craneNo,
        string sequence,
        CancellationToken cancellationToken = default);
}
