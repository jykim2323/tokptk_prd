using System.Data;
using System.Globalization;
using Dapper;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Controls;

/// <summary>상품/제품 창고(T2)의 dbo.TIMESG 에러 이력 조회·삭제.</summary>
public sealed class ErrorHistoryRepository(DbConnectionFactory db) : IErrorHistoryRepository
{
    private const string WarehouseCode = "T2";

    public async Task<IReadOnlyList<ErrorHistoryDto>> SearchAsync(
        DateOnly startDate,
        DateOnly endDate,
        string? craneNo = null,
        CancellationToken cancellationToken = default)
    {
        ValidateDateRange(startDate, endDate);
        var normalizedCraneNo = NormalizeOptionalCraneNo(craneNo);

        var fromKey = $"{startDate.ToString("yyyyMMdd", CultureInfo.InvariantCulture)}000000";
        var toExclusiveKey =
            $"{endDate.AddDays(1).ToString("yyyyMMdd", CultureInfo.InvariantCulture)}000000";

        const string sql = """
                           SELECT
                               MESG_DT AS OccurredAtRaw,
                               MESG_EHOGI AS CraneNo,
                               COALESCE(MESG_ELOCA, '') AS Location,
                               COALESCE(MESG_DESC, '') AS Description
                           FROM dbo.TIMESG
                           WHERE MESG_WH = @WarehouseCode
                             AND MESG_DT >= @FromKey
                             AND MESG_DT < @ToExclusiveKey
                             AND (@CraneNo IS NULL OR MESG_EHOGI = @CraneNo)
                           ORDER BY MESG_DT DESC;
                           """;

        var parameters = new DynamicParameters();
        parameters.Add("WarehouseCode", WarehouseCode, DbType.AnsiString, size: 2);
        parameters.Add("FromKey", fromKey, DbType.AnsiString, size: 14);
        parameters.Add("ToExclusiveKey", toExclusiveKey, DbType.AnsiString, size: 14);
        parameters.Add("CraneNo", normalizedCraneNo, DbType.AnsiString, size: 1);

        using var connection = db.Create();
        var rows = await connection.QueryAsync<ErrorHistoryDto>(
            new CommandDefinition(
                sql,
                parameters,
                cancellationToken: cancellationToken));

        return rows.AsList();
    }

    public async Task DeleteAsync(
        string occurredAtRaw,
        string craneNo,
        CancellationToken cancellationToken = default)
    {
        var normalizedOccurredAt = NormalizeOccurredAt(occurredAtRaw);
        var normalizedCraneNo = NormalizeRequiredCraneNo(craneNo);

        const string sql = """
                           DELETE FROM dbo.TIMESG
                           WHERE MESG_WH = @WarehouseCode
                             AND MESG_DT = @OccurredAtRaw
                             AND MESG_EHOGI = @CraneNo;
                           """;

        var parameters = new DynamicParameters();
        parameters.Add("WarehouseCode", WarehouseCode, DbType.AnsiString, size: 2);
        parameters.Add("OccurredAtRaw", normalizedOccurredAt, DbType.AnsiString, size: 14);
        parameters.Add("CraneNo", normalizedCraneNo, DbType.AnsiString, size: 1);

        using var connection = db.Create();
        var affectedRows = await connection.ExecuteAsync(
            new CommandDefinition(
                sql,
                parameters,
                cancellationToken: cancellationToken));

        if (affectedRows == 0)
        {
            throw new KeyNotFoundException(
                $"발생일시 {normalizedOccurredAt}, {normalizedCraneNo}호기 에러 이력을 찾을 수 없습니다.");
        }

        if (affectedRows != 1)
        {
            throw new InvalidOperationException(
                $"에러 이력 한 건만 삭제해야 하지만 {affectedRows}건이 삭제되었습니다.");
        }
    }

    private static void ValidateDateRange(DateOnly startDate, DateOnly endDate)
    {
        if (startDate > endDate)
            throw new ArgumentException("시작일은 종료일보다 늦을 수 없습니다.", nameof(startDate));

        if (endDate == DateOnly.MaxValue)
        {
            throw new ArgumentOutOfRangeException(
                nameof(endDate),
                endDate,
                "종료일은 9999-12-31보다 이전이어야 합니다.");
        }
    }

    private static string? NormalizeOptionalCraneNo(string? craneNo)
        => string.IsNullOrWhiteSpace(craneNo)
            ? null
            : NormalizeRequiredCraneNo(craneNo);

    private static string NormalizeRequiredCraneNo(string? craneNo)
    {
        var normalized = (craneNo ?? string.Empty).Trim();
        if (normalized.Length != 1 || normalized[0] is < '1' or > '7')
        {
            throw new ArgumentException(
                "호기는 비어 있거나 1에서 7 사이여야 합니다.",
                nameof(craneNo));
        }

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
