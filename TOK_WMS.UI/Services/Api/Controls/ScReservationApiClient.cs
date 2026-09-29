using System.Globalization;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.UI.Services.Api.Controls;

public interface IScReservationApi
{
    Task<IReadOnlyList<ScReservationDto>> GetAsync(
        ScReservationQueryDto? query = null,
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

/// <summary>스태커 크레인 작업 예약 조회·출고 ST 수정·삭제 API.</summary>
public sealed class ScReservationApiClient(HttpClient http) : IScReservationApi
{
    public async Task<IReadOnlyList<ScReservationDto>> GetAsync(
        ScReservationQueryDto? query = null,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.GetAsync(BuildGetPath(query), cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);

        return await response.Content.ReadFromJsonAsync<List<ScReservationDto>>(
                   cancellationToken: cancellationToken)
               ?? throw new InvalidOperationException("스태커 예약 조회 응답이 비어 있습니다.");
    }

    public async Task UpdateWorkStationAsync(
        int craneNo,
        string sequence,
        ScReservationWorkStationUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(values);

        var path = BuildReservationPath(craneNo, sequence) + "/work-station";
        using var response = await http.PutAsJsonAsync(path, values, cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    public async Task DeleteAsync(
        int craneNo,
        string sequence,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.DeleteAsync(
            BuildReservationPath(craneNo, sequence),
            cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    private static string BuildGetPath(ScReservationQueryDto? query)
    {
        const string path = "api/sc-reservations";
        if (query is null)
            return path;

        var parameters = new List<string>();
        AddQueryParameter(parameters, "craneNo", query.CraneNo?.ToString(CultureInfo.InvariantCulture));
        AddQueryParameter(
            parameters,
            "startDate",
            query.StartDate?.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture));
        AddQueryParameter(
            parameters,
            "endDate",
            query.EndDate?.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture));
        AddQueryParameter(parameters, "jobCode", query.JobCode);
        AddQueryParameter(parameters, "sequence", query.Sequence);

        return parameters.Count == 0 ? path : $"{path}?{string.Join('&', parameters)}";
    }

    private static string BuildReservationPath(int craneNo, string sequence)
    {
        var normalizedSequence = (sequence ?? string.Empty).Trim();
        if (normalizedSequence.Length == 0)
            throw new ArgumentException("입출고 순번이 필요합니다.", nameof(sequence));

        return $"api/sc-reservations/{craneNo}/{Uri.EscapeDataString(normalizedSequence)}";
    }

    private static void AddQueryParameter(
        ICollection<string> parameters,
        string name,
        string? value)
    {
        var normalized = (value ?? string.Empty).Trim();
        if (normalized.Length == 0)
            return;

        parameters.Add($"{Uri.EscapeDataString(name)}={Uri.EscapeDataString(normalized)}");
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
