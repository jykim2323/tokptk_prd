using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.UI.Services.Api.Controls;

public interface IScChannelApi
{
    Task<IReadOnlyList<ScChannelDto>> GetChannelsAsync(
        int scNo,
        CancellationToken cancellationToken = default);

    Task UpdateChannelGroupAsync(
        int scNo,
        string sr,
        ScChannelUpdateGroup group,
        ScChannelUpdateDto values,
        CancellationToken cancellationToken = default);
}

/// <summary>스태커 크레인 PLC 통신 버퍼 조회·부분 수정 API.</summary>
public class ScChannelApiClient(HttpClient http) : IScChannelApi
{
    public async Task<IReadOnlyList<ScChannelDto>> GetChannelsAsync(
        int scNo,
        CancellationToken cancellationToken = default)
    {
        if (scNo is < 1 or > 7)
            throw new ArgumentOutOfRangeException(nameof(scNo), "호기 번호는 1~7이어야 합니다.");

        return await http.GetFromJsonAsync<List<ScChannelDto>>(
                   $"api/sc-channels/{scNo}", cancellationToken)
               ?? [];
    }

    public async Task UpdateChannelGroupAsync(
        int scNo,
        string sr,
        ScChannelUpdateGroup group,
        ScChannelUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        if (scNo is < 1 or > 7)
            throw new ArgumentOutOfRangeException(nameof(scNo), "호기 번호는 1~7이어야 합니다.");

        var normalizedSr = (sr ?? string.Empty).Trim().ToUpperInvariant();
        if (normalizedSr is not ("R" or "S"))
            throw new ArgumentException("송·수신 구분은 R 또는 S여야 합니다.", nameof(sr));

        var groupPath = group.ToString().ToLowerInvariant();
        using var response = await http.PutAsJsonAsync(
            $"api/sc-channels/{scNo}/{normalizedSr}/{groupPath}",
            values,
            cancellationToken);
        response.EnsureSuccessStatusCode();
    }
}
