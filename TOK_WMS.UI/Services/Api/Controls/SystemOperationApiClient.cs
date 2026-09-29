using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.UI.Services.Api.Controls;

public interface ISystemOperationApi
{
    Task<SystemOperationDto> GetAsync(CancellationToken cancellationToken = default);

    Task UpdateAsync(
        SystemOperationUpdateGroup group,
        SystemOperationUpdateDto values,
        CancellationToken cancellationToken = default);
}

/// <summary>시스템 운전 설정 조회·부분 수정 API.</summary>
public sealed class SystemOperationApiClient(HttpClient http) : ISystemOperationApi
{
    public async Task<SystemOperationDto> GetAsync(CancellationToken cancellationToken = default)
        => await http.GetFromJsonAsync<SystemOperationDto>(
               "api/system-operation",
               cancellationToken)
           ?? throw new InvalidOperationException("시스템 운전 설정 응답이 비어 있습니다.");

    public async Task UpdateAsync(
        SystemOperationUpdateGroup group,
        SystemOperationUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(values);

        if (!Enum.IsDefined(group))
            throw new ArgumentOutOfRangeException(nameof(group), group, "지원하지 않는 수정 영역입니다.");

        var groupPath = group.ToString().ToLowerInvariant();
        using var response = await http.PutAsJsonAsync(
            $"api/system-operation/{groupPath}",
            values,
            cancellationToken);
        response.EnsureSuccessStatusCode();
    }
}
