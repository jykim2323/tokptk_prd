using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.Core.Interfaces.Controls;

public interface ISystemOperationRepository
{
    Task<SystemOperationDto> GetAsync(CancellationToken cancellationToken = default);

    Task UpdateAsync(
        SystemOperationUpdateGroup group,
        SystemOperationUpdateDto values,
        CancellationToken cancellationToken = default);
}
