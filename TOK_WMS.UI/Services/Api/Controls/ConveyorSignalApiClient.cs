using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.UI.Services.Api.Controls;

public interface IConveyorSignalApi
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

/// <summary>CVC 전체의 PLC 통신 신호 조회·Grid 단위 수정 API.</summary>
public class ConveyorSignalApiClient(HttpClient http) : IConveyorSignalApi
{
    public async Task<IReadOnlyList<ConveyorSignalGridDto>> GetAsync(
        CancellationToken cancellationToken = default)
    {
        using var response = await http.GetAsync(
            "api/conveyor-signals",
            cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);

        var values = await response.Content.ReadFromJsonAsync<List<ConveyorSignalGridDto>>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("컨베이어 신호 응답이 비어 있습니다.");

        if (values.Count != 24
            || values.Count(value => value.Direction == "R") != 12
            || values.Count(value => value.Direction == "S") != 12)
        {
            throw new InvalidOperationException(
                "컨베이어 신호는 PLC → COM 12개와 COM → PLC 12개가 필요합니다.");
        }

        return values;
    }

    public async Task UpdateAsync(
        string direction,
        int gridNo,
        ConveyorSignalUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(values);

        var normalizedDirection = (direction ?? string.Empty).Trim().ToUpperInvariant();
        if (normalizedDirection is not ("R" or "S"))
            throw new ArgumentException("송·수신 구분은 R 또는 S여야 합니다.", nameof(direction));

        if (gridNo is < 1 or > 12)
        {
            throw new ArgumentOutOfRangeException(
                nameof(gridNo),
                gridNo,
                "컨베이어 신호 Grid 번호는 1에서 12 사이여야 합니다.");
        }

        using var response = await http.PutAsJsonAsync(
            $"api/conveyor-signals/{normalizedDirection}/{gridNo}",
            values,
            cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    public async Task UpdateBitAsync(
        string direction,
        int gridNo,
        int bitIndex,
        ConveyorSignalBitUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(values);

        var normalizedDirection = (direction ?? string.Empty).Trim().ToUpperInvariant();
        if (normalizedDirection is not ("R" or "S"))
            throw new ArgumentException("송·수신 구분은 R 또는 S여야 합니다.", nameof(direction));

        if (gridNo is < 1 or > 12)
        {
            throw new ArgumentOutOfRangeException(
                nameof(gridNo),
                gridNo,
                "컨베이어 신호 Grid 번호는 1에서 12 사이여야 합니다.");
        }

        if (bitIndex is < 0 or > 15)
        {
            throw new ArgumentOutOfRangeException(
                nameof(bitIndex),
                bitIndex,
                "컨베이어 신호 BIT 번호는 0에서 15 사이여야 합니다.");
        }

        using var request = new HttpRequestMessage(
            HttpMethod.Patch,
            $"api/conveyor-signals/{normalizedDirection}/{gridNo}/bits/{bitIndex}")
        {
            Content = JsonContent.Create(values)
        };
        using var response = await http.SendAsync(request, cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    private static async Task EnsureSuccessAsync(
        HttpResponseMessage response,
        CancellationToken cancellationToken)
    {
        if (response.IsSuccessStatusCode)
            return;

        var fallback = $"API 요청 실패 ({(int)response.StatusCode} {response.ReasonPhrase})";
        var body = await response.Content.ReadAsStringAsync(cancellationToken);
        if (string.IsNullOrWhiteSpace(body))
            throw new HttpRequestException(fallback, null, response.StatusCode);

        try
        {
            using var document = JsonDocument.Parse(body);
            if (document.RootElement.TryGetProperty("detail", out var detailElement)
                && !string.IsNullOrWhiteSpace(detailElement.GetString()))
            {
                throw new HttpRequestException(
                    detailElement.GetString(),
                    null,
                    response.StatusCode);
            }
        }
        catch (JsonException)
        {
            // ProblemDetails가 아닌 응답은 아래의 HTTP 상태 문구로 표시한다.
        }

        throw new HttpRequestException(fallback, null, response.StatusCode);
    }
}
