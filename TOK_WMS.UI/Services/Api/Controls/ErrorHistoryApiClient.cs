using System.Globalization;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.UI.Services.Api.Controls;

public interface IErrorHistoryApi
{
    Task<IReadOnlyList<ErrorHistoryDto>> SearchAsync(
        DateTime startDate,
        DateTime endDate,
        string? craneNo = null,
        CancellationToken cancellationToken = default);

    Task DeleteAsync(
        string occurredAtRaw,
        string craneNo,
        CancellationToken cancellationToken = default);
}

/// <summary>상품/제품 창고(T2) 에러 이력 조회·삭제 API.</summary>
public sealed class ErrorHistoryApiClient(HttpClient http) : IErrorHistoryApi
{
    public async Task<IReadOnlyList<ErrorHistoryDto>> SearchAsync(
        DateTime startDate,
        DateTime endDate,
        string? craneNo = null,
        CancellationToken cancellationToken = default)
    {
        var normalizedStartDate = startDate.Date;
        var normalizedEndDate = endDate.Date;
        if (normalizedStartDate > normalizedEndDate)
            throw new ArgumentException("시작일은 종료일보다 늦을 수 없습니다.", nameof(startDate));

        var normalizedCraneNo = NormalizeOptionalCraneNo(craneNo);
        var path =
            $"api/error-histories?startDate={normalizedStartDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)}" +
            $"&endDate={normalizedEndDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)}";

        if (normalizedCraneNo is not null)
            path += $"&craneNo={Uri.EscapeDataString(normalizedCraneNo)}";

        return await http.GetFromJsonAsync<List<ErrorHistoryDto>>(path, cancellationToken) ?? [];
    }

    public async Task DeleteAsync(
        string occurredAtRaw,
        string craneNo,
        CancellationToken cancellationToken = default)
    {
        var normalizedOccurredAt = NormalizeOccurredAt(occurredAtRaw);
        var normalizedCraneNo = NormalizeRequiredCraneNo(craneNo);

        using var response = await http.DeleteAsync(
            $"api/error-histories/{normalizedOccurredAt}/{normalizedCraneNo}",
            cancellationToken);
        response.EnsureSuccessStatusCode();
    }

    private static string? NormalizeOptionalCraneNo(string? craneNo)
        => string.IsNullOrWhiteSpace(craneNo)
            ? null
            : NormalizeRequiredCraneNo(craneNo);

    private static string NormalizeRequiredCraneNo(string? craneNo)
    {
        var normalized = (craneNo ?? string.Empty).Trim();
        if (normalized.Length != 1 || normalized[0] is < '1' or > '7')
            throw new ArgumentException("호기는 비어 있거나 1에서 7 사이여야 합니다.", nameof(craneNo));

        return normalized;
    }

    private static string NormalizeOccurredAt(string? occurredAtRaw)
    {
        var normalized = (occurredAtRaw ?? string.Empty).Trim();
        if (!DateTime.TryParseExact(
                normalized,
                "yyyyMMddHHmmss",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out _))
        {
            throw new ArgumentException(
                "발생일시는 yyyyMMddHHmmss 형식이어야 합니다.",
                nameof(occurredAtRaw));
        }

        return normalized;
    }
}
