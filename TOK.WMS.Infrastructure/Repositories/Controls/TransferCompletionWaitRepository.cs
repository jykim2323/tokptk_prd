using System.Globalization;
using System.Text;
using Dapper;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Controls;

public sealed class TransferCompletionWaitRepository(DbConnectionFactory db)
    : ITransferCompletionWaitRepository
{
    private static readonly string[] InboundJobCodes = ["I", "R", "A"];
    private static readonly string[] OutboundJobCodes = ["O", "T", "P", "U"];

    public async Task<IReadOnlyList<TransferCompletionWaitDto>> GetAsync(
        TransferCompletionWaitQueryDto? query = null,
        CancellationToken cancellationToken = default)
    {
        var startDate = query?.StartDate?.Date;
        var endDate = query?.EndDate?.Date;
        if (startDate.HasValue && endDate.HasValue && startDate > endDate)
            throw new ArgumentException("조회 시작일은 종료일보다 늦을 수 없습니다.", nameof(query));

        var sequence = NormalizeSearchValue(query?.Sequence, 13, "작업 순번");
        var location = NormalizeSearchValue(query?.Location, 6, "작업 위치");
        var jobCodes = NormalizeJobCodes(query?.JobType);

        var sql = new StringBuilder(
            """
            SELECT
                normalized.Sequence,
                normalized.Location,
                normalized.JobCode,
                CASE UPPER(normalized.JobCode)
                    WHEN 'I' THEN N'정상입고'
                    WHEN 'R' THEN N'재입고'
                    WHEN 'A' THEN N'보충입고'
                    WHEN 'O' THEN N'출고'
                    WHEN 'T' THEN N'전량출고'
                    WHEN 'P' THEN N'피킹출고'
                    WHEN 'U' THEN N'추가출고'
                    ELSE normalized.JobCode
                END AS JobType,
                CASE
                    WHEN TRY_CONVERT(date, NULLIF(normalized.CompletionDateRaw, ''), 112) IS NOT NULL
                    THEN CONVERT(char(10),
                        TRY_CONVERT(date, normalized.CompletionDateRaw, 112), 23)
                    ELSE normalized.CompletionDateRaw
                END AS CompletionDate,
                CASE
                    WHEN TRY_CONVERT(time(0),
                        STUFF(STUFF(normalized.CompletionTimeRaw, 3, 0, ':'), 6, 0, ':'), 108) IS NOT NULL
                    THEN STUFF(STUFF(normalized.CompletionTimeRaw, 3, 0, ':'), 6, 0, ':')
                    ELSE normalized.CompletionTimeRaw
                END AS CompletionTime,
                normalized.PalletNo
            FROM dbo.T2TIUPDT AS wait WITH (NOLOCK)
            CROSS APPLY
            (
                VALUES
                (
                    LTRIM(RTRIM(COALESCE(wait.UPDT_INDEX, ''))),
                    LTRIM(RTRIM(COALESCE(wait.UPDT_LOCA, ''))),
                    LTRIM(RTRIM(COALESCE(wait.UPDT_JOB, ''))),
                    LTRIM(RTRIM(COALESCE(wait.UPDT_DATE, ''))),
                    LTRIM(RTRIM(COALESCE(wait.UPDT_TIME, ''))),
                    LTRIM(RTRIM(COALESCE(wait.UPDT_PLTNO, '')))
                )
            ) AS normalized
            (
                Sequence,
                Location,
                JobCode,
                CompletionDateRaw,
                CompletionTimeRaw,
                PalletNo
            )
            WHERE 1 = 1
            """);

        var parameters = new DynamicParameters();

        if (startDate.HasValue)
        {
            sql.AppendLine("  AND normalized.CompletionDateRaw >= @StartDate");
            parameters.Add(
                "StartDate",
                startDate.Value.ToString("yyyyMMdd", CultureInfo.InvariantCulture));
        }

        if (endDate.HasValue)
        {
            sql.AppendLine("  AND normalized.CompletionDateRaw <= @EndDate");
            parameters.Add(
                "EndDate",
                endDate.Value.ToString("yyyyMMdd", CultureInfo.InvariantCulture));
        }

        if (jobCodes is not null)
        {
            sql.AppendLine("  AND UPPER(normalized.JobCode) IN @JobCodes");
            parameters.Add("JobCodes", jobCodes);
        }

        if (sequence is not null)
        {
            sql.AppendLine("  AND CHARINDEX(@Sequence, normalized.Sequence) > 0");
            parameters.Add("Sequence", sequence);
        }

        if (location is not null)
        {
            sql.AppendLine("  AND CHARINDEX(@Location, normalized.Location) > 0");
            parameters.Add("Location", location);
        }

        sql.AppendLine("ORDER BY normalized.Sequence;");

        using var connection = db.Create();
        var command = new CommandDefinition(
            sql.ToString(),
            parameters,
            cancellationToken: cancellationToken);

        return (await connection.QueryAsync<TransferCompletionWaitDto>(command)).AsList();
    }

    public async Task<bool> DeleteAsync(
        string sequence,
        CancellationToken cancellationToken = default)
    {
        var normalizedSequence = NormalizeRequiredSequence(sequence);

        const string sql = """
                           DELETE FROM dbo.T2TIUPDT
                           WHERE UPDT_INDEX = @Sequence;
                           """;

        using var connection = db.Create();
        var command = new CommandDefinition(
            sql,
            new { Sequence = normalizedSequence },
            cancellationToken: cancellationToken);
        var affectedRows = await connection.ExecuteAsync(command);

        if (affectedRows is < 0 or > 1)
        {
            throw new InvalidOperationException(
                $"T2TIUPDT의 작업 순번 {normalizedSequence}을 한 건만 삭제해야 하지만 " +
                $"{affectedRows}건이 처리되었습니다.");
        }

        return affectedRows == 1;
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

    private static string[]? NormalizeJobCodes(string? value)
    {
        var normalized = value?.Trim();
        if (string.IsNullOrEmpty(normalized) || normalized == "전체")
            return null;

        if (normalized == "입고")
            return InboundJobCodes;

        if (normalized == "출고")
            return OutboundJobCodes;

        var rawCode = normalized.ToUpperInvariant();
        if (rawCode.Length == 1
            && (InboundJobCodes.Contains(rawCode) || OutboundJobCodes.Contains(rawCode)))
        {
            return [rawCode];
        }

        throw new ArgumentException(
            "작업 조건은 입고, 출고 또는 I/R/A/O/T/P/U 중 하나여야 합니다.",
            nameof(value));
    }

    private static string NormalizeRequiredSequence(string? sequence)
    {
        var normalized = sequence?.Trim();
        if (string.IsNullOrEmpty(normalized))
            throw new ArgumentException("삭제할 작업 순번은 필수입니다.", nameof(sequence));

        if (normalized.Length > 13)
            throw new ArgumentException("작업 순번은 13자를 초과할 수 없습니다.", nameof(sequence));

        if (normalized.Any(char.IsControl) || normalized.IndexOfAny(['/', '\\']) >= 0)
        {
            throw new ArgumentException(
                "작업 순번에 경로 문자나 제어 문자를 사용할 수 없습니다.",
                nameof(sequence));
        }

        return normalized;
    }
}
