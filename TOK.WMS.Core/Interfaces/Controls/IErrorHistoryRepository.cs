using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.Core.Interfaces.Controls;

public interface IErrorHistoryRepository
{
    Task<IReadOnlyList<ErrorHistoryDto>> SearchAsync(
        DateOnly startDate,
        DateOnly endDate,
        string? craneNo = null,
        CancellationToken cancellationToken = default);

    Task DeleteAsync(
        string occurredAtRaw,
        string craneNo,
        CancellationToken cancellationToken = default);
}
