using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.Core.Interfaces.Controls;

public interface IConveyorSignalRepository
{
    Task<IReadOnlyList<ConveyorSignalGridDto>> GetAsync(
        CancellationToken cancellationToken = default);

    Task UpdateAsync(
        string direction,
        int gridNo,
        ConveyorSignalUpdateDto values,
        CancellationToken cancellationToken = default);

    Task UpdateBitAsync(
        string direction,
        int gridNo,
        int bitIndex,
        ConveyorSignalBitUpdateDto values,
        CancellationToken cancellationToken = default);
}
