using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.UI.Services.Api.Controls;

public interface ITransferCompletionWaitApi
{
    Task<IReadOnlyList<TransferCompletionWaitDto>> GetAsync(
        TransferCompletionWaitQueryDto? query = null,
        CancellationToken cancellationToken = default);

    Task DeleteAsync(
        string sequence,
        CancellationToken cancellationToken = default);
}

/// <summary>T2TIUPDT 입출고 완료 대기 항목 조회·삭제 API.</summary>
public sealed class TransferCompletionWaitApiClient(HttpClient http)
    : ITransferCompletionWaitApi
{
    private static readonly HashSet<string> SupportedRawJobCodes =
        new(StringComparer.OrdinalIgnoreCase) { "I", "R", "A", "O", "T", "P", "U" };

    public async Task<IReadOnlyList<TransferCompletionWaitDto>> GetAsync(
        TransferCompletionWaitQueryDto? query = null,
        CancellationToken cancellationToken = default)
    {
        var requestUri = BuildRequestUri(query);
        using var response = await http.GetAsync(requestUri, cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);

        return await response.Content.ReadFromJsonAsync<List<TransferCompletionWaitDto>>(
                   cancellationToken: cancellationToken)
               ?? [];
    }

    public async Task DeleteAsync(
        string sequence,
        CancellationToken cancellationToken = default)
    {
        var normalizedSequence = NormalizeDeleteSequence(sequence);
        using var response = await http.DeleteAsync(
            $"api/transfer-completion-waits/{Uri.EscapeDataString(normalizedSequence)}",
            cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    private static string BuildRequestUri(TransferCompletionWaitQueryDto? query)
    {
        const string path = "api/transfer-completion-waits";
        if (query is null)
            return path;

        var startDate = query.StartDate?.Date;
        var endDate = query.EndDate?.Date;
        if (startDate.HasValue && endDate.HasValue && startDate > endDate)
            throw new ArgumentException("조회 시작일은 종료일보다 늦을 수 없습니다.", nameof(query));

        var jobType = NormalizeJobType(query.JobType);
        var sequence = NormalizeSearchValue(query.Sequence, 13, "작업 순번");
        var location = NormalizeSearchValue(query.Location, 6, "작업 위치");
        var values = new List<string>();

        Add(values, "startDate", startDate?.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture));
        Add(values, "endDate", endDate?.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture));
        Add(values, "jobType", jobType);
        Add(values, "sequence", sequence);
        Add(values, "location", location);

        return values.Count == 0 ? path : $"{path}?{string.Join('&', values)}";
    }

    private static void Add(ICollection<string> values, string name, string? value)
    {
        if (!string.IsNullOrEmpty(value))
            values.Add($"{name}={Uri.EscapeDataString(value)}");
    }

    private static string? NormalizeJobType(string? value)
    {
        var normalized = value?.Trim();
        if (string.IsNullOrEmpty(normalized) || normalized == "전체")
            return null;

        if (normalized is "입고" or "출고")
            return normalized;

        var rawCode = normalized.ToUpperInvariant();
        if (SupportedRawJobCodes.Contains(rawCode))
            return rawCode;

        throw new ArgumentException(
            "작업 조건은 입고, 출고 또는 I/R/A/O/T/P/U 중 하나여야 합니다.",
            nameof(value));
    }

    private static string? NormalizeSearchValue(
        string? value,
        int maxLength,
        string displayName)
    {
        var normalized = value?.Trim();
        if (string.IsNullOrEmpty(normalized))
            return null;

        if (normalized.Length > maxLength)
        {
            throw new ArgumentException(
                $"{displayName} 검색값은 {maxLength}자를 초과할 수 없습니다.",
                displayName);
        }

        if (normalized.Any(char.IsControl))
            throw new ArgumentException($"{displayName}에 제어 문자를 사용할 수 없습니다.", displayName);

        return normalized;
    }

    private static string NormalizeDeleteSequence(string? sequence)
    {
        var normalized = sequence?.Trim();
        if (string.IsNullOrEmpty(normalized))
            throw new ArgumentException("삭제할 작업 순번은 필수입니다.", nameof(sequence));

        if (normalized.Length > 13)
            throw new ArgumentException("작업 순번은 13자를 초과할 수 없습니다.", nameof(sequence));

        if (normalized.Any(char.IsControl) || normalized.IndexOfAny(['/', '\\']) >= 0)
            throw new ArgumentException("작업 순번에 경로 문자나 제어 문자를 사용할 수 없습니다.", nameof(sequence));

        return normalized;
    }

    private static async Task EnsureSuccessAsync(
        HttpResponseMessage response,
        CancellationToken cancellationToken)
    {
        if (response.IsSuccessStatusCode)
            return;

        ApiProblem? problem = null;
        try
        {
            problem = await response.Content.ReadFromJsonAsync<ApiProblem>(
                cancellationToken: cancellationToken);
        }
        catch (Exception ex) when (ex is JsonException or NotSupportedException)
        {
            // 프록시나 서버가 ProblemDetails 이외의 본문을 반환해도 HTTP 상태를 보존한다.
        }

        var message = problem?.Detail
                      ?? problem?.Title
                      ?? $"API 요청에 실패했습니다. ({(int)response.StatusCode})";

        if (response.StatusCode == HttpStatusCode.NotFound)
            throw new KeyNotFoundException(message);

        throw new HttpRequestException(message, null, response.StatusCode);
    }

    private sealed class ApiProblem
    {
        public string? Title { get; set; }
        public string? Detail { get; set; }
    }
}
