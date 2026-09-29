using System.Data;
using System.Globalization;
using Dapper;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Controls;

/// <summary>dbo.T2TISCHE의 스태커 작업 예약을 조회·수정·삭제한다.</summary>
public sealed class ScReservationRepository(DbConnectionFactory db) : IScReservationRepository
{
    private const int MaximumSequenceLength = 20;

    public async Task<IReadOnlyList<ScReservationDto>> GetAsync(
        ScReservationQueryDto query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var craneNo = ValidateOptionalCraneNo(query.CraneNo);
        var (startDate, endDate) = NormalizeDateRange(query.StartDate, query.EndDate);
        var jobCode = NormalizeOptionalJobCode(query.JobCode);
        var sequence = NormalizeOptionalSequence(query.Sequence);

        const string sql = """
                           SELECT
                               TRY_CONVERT(int, SCHE_SC) AS CraneNo,
                               LTRIM(RTRIM(SCHE_INDEX)) AS Sequence,
                               LTRIM(RTRIM(COALESCE(SCHE_JOBGUBUN, ''))) AS JobCode,
                               LTRIM(RTRIM(COALESCE(SCHE_LOCA, ''))) AS Location,
                               LTRIM(RTRIM(COALESCE(SCHE_WSNO, ''))) AS WorkStation,
                               LTRIM(RTRIM(COALESCE(SCHE_EMER, ''))) AS EmergencyCode,
                               LTRIM(RTRIM(COALESCE(SCHE_DATE, ''))) AS InstructionDate,
                               LTRIM(RTRIM(COALESCE(SCHE_TIME, ''))) AS InstructionTime,
                               LTRIM(RTRIM(COALESCE(SCHE_PLTNO, ''))) AS PalletNo
                           FROM dbo.T2TISCHE
                           WHERE TRY_CONVERT(int, SCHE_SC) BETWEEN 1 AND 7
                             AND (@CraneNo IS NULL OR TRY_CONVERT(int, SCHE_SC) = @CraneNo)
                             AND (
                                 (@StartDate IS NULL AND @EndDate IS NULL)
                                 OR (
                                     LEN(LTRIM(RTRIM(COALESCE(SCHE_DATE, '')))) = 8
                                     AND (@StartDate IS NULL OR SCHE_DATE >= @StartDate)
                                     AND (@EndDate IS NULL OR SCHE_DATE <= @EndDate)
                                 )
                             )
                             AND (
                                 @JobCode IS NULL
                                 OR UPPER(LTRIM(RTRIM(COALESCE(SCHE_JOBGUBUN, '')))) = @JobCode
                             )
                             AND (
                                 @Sequence IS NULL
                                 OR LTRIM(RTRIM(SCHE_INDEX)) = @Sequence
                             )
                           ORDER BY SCHE_INDEX;
                           """;

        using var connection = db.Create();
        var command = new CommandDefinition(
            sql,
            new
            {
                CraneNo = craneNo,
                StartDate = startDate,
                EndDate = endDate,
                JobCode = jobCode,
                Sequence = sequence
            },
            cancellationToken: cancellationToken);

        var rows = (await connection.QueryAsync<ScReservationRow>(command)).AsList();
        return rows.Select(MapReservation).ToArray();
    }

    public async Task UpdateWorkStationAsync(
        int craneNo,
        string sequence,
        ScReservationWorkStationUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(values);

        var normalizedCraneNo = ValidateCraneNo(craneNo);
        var normalizedSequence = NormalizeRequiredSequence(sequence);
        var workStation = NormalizeWorkStation(values.WorkStation);

        const string sql = """
                           UPDATE dbo.T2TISCHE
                           SET SCHE_WSNO = @WorkStation
                           WHERE SCHE_SC = @CraneNo
                             AND SCHE_INDEX = @Sequence;
                           """;

        using var connection = db.Create();
        var affectedRows = await connection.ExecuteAsync(
            new CommandDefinition(
                sql,
                new
                {
                    CraneNo = normalizedCraneNo.ToString(CultureInfo.InvariantCulture),
                    Sequence = normalizedSequence,
                    WorkStation = workStation
                },
                cancellationToken: cancellationToken));

        EnsureSingleReservationAffected(
            affectedRows,
            normalizedCraneNo,
            normalizedSequence,
            "수정");
    }

    public async Task DeleteAsync(
        int craneNo,
        string sequence,
        CancellationToken cancellationToken = default)
    {
        var normalizedCraneNo = ValidateCraneNo(craneNo);
        var normalizedSequence = NormalizeRequiredSequence(sequence);
        var key = new
        {
            CraneNo = normalizedCraneNo.ToString(CultureInfo.InvariantCulture),
            Sequence = normalizedSequence
        };

        const string locationSql = """
                                   SELECT LTRIM(RTRIM(COALESCE(SCHE_LOCA, ''))) AS Location
                                   FROM dbo.T2TISCHE WITH (UPDLOCK, HOLDLOCK)
                                   WHERE SCHE_SC = @CraneNo
                                     AND SCHE_INDEX = @Sequence;
                                   """;

        const string restoreRackSql = """
                                      UPDATE dbo.T2MILSTK
                                      SET LSTK_FLAG = '1'
                                      WHERE LSTK_LOCA = @Location;
                                      """;

        const string stockCountSql = """
                                     SELECT COUNT(*)
                                     FROM dbo.T2MISUBK WITH (UPDLOCK, HOLDLOCK)
                                     WHERE SUBK_LOCA = @Location;
                                     """;

        const string restoreStockSql = """
                                       UPDATE dbo.T2MISUBK
                                       SET SUBK_FLAG = '1',
                                           SUBK_RWGT = 0
                                       WHERE SUBK_LOCA = @Location;
                                       """;

        const string deleteReservationSql = """
                                            DELETE FROM dbo.T2TISCHE
                                            WHERE SCHE_SC = @CraneNo
                                              AND SCHE_INDEX = @Sequence;
                                            """;

        using var connection = db.Create();
        connection.Open();
        using var transaction = connection.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            var locationRow = await connection.QuerySingleOrDefaultAsync<ReservationLocationRow>(
                new CommandDefinition(
                    locationSql,
                    key,
                    transaction,
                    cancellationToken: cancellationToken));

            if (locationRow is null)
                throw ReservationNotFound(normalizedCraneNo, normalizedSequence);

            var location = (locationRow.Location ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(location))
            {
                throw new InvalidOperationException(
                    $"스태커 {normalizedCraneNo}호기 예약 {normalizedSequence}의 저장위치가 비어 있어 삭제할 수 없습니다.");
            }

            var locationParameter = new { Location = location };
            var restoredRackRows = await connection.ExecuteAsync(
                new CommandDefinition(
                    restoreRackSql,
                    locationParameter,
                    transaction,
                    cancellationToken: cancellationToken));
            if (restoredRackRows != 1)
            {
                throw new InvalidOperationException(
                    $"저장위치 {location}의 랙 상태를 1개 행만 원복해야 하지만 " +
                    $"{restoredRackRows}개 행이 변경되었습니다.");
            }

            var expectedStockRows = await connection.QuerySingleAsync<int>(
                new CommandDefinition(
                    stockCountSql,
                    locationParameter,
                    transaction,
                    cancellationToken: cancellationToken));
            var restoredStockRows = await connection.ExecuteAsync(
                new CommandDefinition(
                    restoreStockSql,
                    locationParameter,
                    transaction,
                    cancellationToken: cancellationToken));
            if (restoredStockRows != expectedStockRows)
            {
                throw new InvalidOperationException(
                    $"저장위치 {location}의 재고 {expectedStockRows}개 행을 원복해야 하지만 " +
                    $"{restoredStockRows}개 행이 변경되었습니다.");
            }

            var deletedRows = await connection.ExecuteAsync(
                new CommandDefinition(
                    deleteReservationSql,
                    key,
                    transaction,
                    cancellationToken: cancellationToken));
            EnsureSingleReservationAffected(
                deletedRows,
                normalizedCraneNo,
                normalizedSequence,
                "삭제");

            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    private static ScReservationDto MapReservation(ScReservationRow row)
    {
        var jobCode = (row.JobCode ?? string.Empty).Trim().ToUpperInvariant();
        var emergencyCode = (row.EmergencyCode ?? string.Empty).Trim().ToUpperInvariant();
        var instructionDate = (row.InstructionDate ?? string.Empty).Trim();
        var instructionTime = (row.InstructionTime ?? string.Empty).Trim();

        return new ScReservationDto
        {
            CraneNo = row.CraneNo,
            Sequence = (row.Sequence ?? string.Empty).Trim(),
            JobCode = jobCode,
            JobDisplayName = GetJobDisplayName(jobCode),
            Location = (row.Location ?? string.Empty).Trim(),
            WorkStation = (row.WorkStation ?? string.Empty).Trim(),
            EmergencyCode = emergencyCode,
            IsEmergency = emergencyCode.Equals("E", StringComparison.OrdinalIgnoreCase),
            InstructionDate = instructionDate,
            InstructionDateDisplay = FormatDate(instructionDate),
            InstructionTime = instructionTime,
            InstructionTimeDisplay = FormatTime(instructionTime),
            PalletNo = (row.PalletNo ?? string.Empty).Trim()
        };
    }

    private static string GetJobDisplayName(string jobCode) => jobCode switch
    {
        "I" => "정상입고",
        "R" => "재입고",
        "A" => "보충입고",
        "T" => "정상출고(전체)",
        "P" => "피킹출고",
        "U" => "추가출고",
        "O" => "출고",
        "M" => "랙간이동",
        _ => jobCode
    };

    private static string FormatDate(string value)
        => DateTime.TryParseExact(
            value,
            "yyyyMMdd",
            CultureInfo.InvariantCulture,
            DateTimeStyles.None,
            out var date)
            ? date.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)
            : value;

    private static string FormatTime(string value)
        => DateTime.TryParseExact(
            value,
            "HHmmss",
            CultureInfo.InvariantCulture,
            DateTimeStyles.None,
            out var time)
            ? time.ToString("HH:mm:ss", CultureInfo.InvariantCulture)
            : value;

    private static int? ValidateOptionalCraneNo(int? craneNo)
        => craneNo is null ? null : ValidateCraneNo(craneNo.Value);

    private static int ValidateCraneNo(int craneNo)
    {
        if (craneNo is < 1 or > 7)
        {
            throw new ArgumentOutOfRangeException(
                nameof(craneNo),
                craneNo,
                "스태커 호기는 1에서 7 사이여야 합니다.");
        }

        return craneNo;
    }

    private static (string? StartDate, string? EndDate) NormalizeDateRange(
        DateTime? startDate,
        DateTime? endDate)
    {
        var normalizedStart = startDate?.Date;
        var normalizedEnd = endDate?.Date;
        if (normalizedStart > normalizedEnd)
            throw new ArgumentException("조회 시작일은 종료일보다 늦을 수 없습니다.");

        return (
            normalizedStart?.ToString("yyyyMMdd", CultureInfo.InvariantCulture),
            normalizedEnd?.ToString("yyyyMMdd", CultureInfo.InvariantCulture));
    }

    private static string? NormalizeOptionalJobCode(string? jobCode)
    {
        var normalized = (jobCode ?? string.Empty).Trim().ToUpperInvariant();
        if (normalized.Length == 0)
            return null;

        if (normalized.Length != 1)
            throw new ArgumentException("작업구분 코드는 1자리여야 합니다.", nameof(jobCode));

        return normalized;
    }

    private static string? NormalizeOptionalSequence(string? sequence)
    {
        var normalized = (sequence ?? string.Empty).Trim();
        if (normalized.Length == 0)
            return null;

        ValidateSequenceLength(normalized, nameof(sequence));
        return normalized;
    }

    private static string NormalizeRequiredSequence(string? sequence)
    {
        var normalized = (sequence ?? string.Empty).Trim();
        if (normalized.Length == 0)
            throw new ArgumentException("입출고 순번이 필요합니다.", nameof(sequence));

        ValidateSequenceLength(normalized, nameof(sequence));
        return normalized;
    }

    private static void ValidateSequenceLength(string sequence, string parameterName)
    {
        if (sequence.Length > MaximumSequenceLength)
        {
            throw new ArgumentException(
                $"입출고 순번은 {MaximumSequenceLength}자 이하여야 합니다.",
                parameterName);
        }
    }

    private static string NormalizeWorkStation(string? workStation)
    {
        var normalized = (workStation ?? string.Empty).Trim();
        if (normalized is not ("1" or "2"))
        {
            throw new ArgumentException(
                "출고 ST는 1 또는 2여야 합니다.",
                nameof(workStation));
        }

        return normalized;
    }

    private static void EnsureSingleReservationAffected(
        int affectedRows,
        int craneNo,
        string sequence,
        string operation)
    {
        if (affectedRows == 0)
            throw ReservationNotFound(craneNo, sequence);

        if (affectedRows != 1)
        {
            throw new InvalidOperationException(
                $"스태커 {craneNo}호기 예약 {sequence}을 1개 행만 {operation}해야 하지만 " +
                $"{affectedRows}개 행이 변경되었습니다.");
        }
    }

    private static KeyNotFoundException ReservationNotFound(int craneNo, string sequence)
        => new($"스태커 {craneNo}호기에서 입출고 순번 {sequence} 예약을 찾을 수 없습니다.");

    private sealed class ScReservationRow
    {
        public int CraneNo { get; init; }
        public string? Sequence { get; init; }
        public string? JobCode { get; init; }
        public string? Location { get; init; }
        public string? WorkStation { get; init; }
        public string? EmergencyCode { get; init; }
        public string? InstructionDate { get; init; }
        public string? InstructionTime { get; init; }
        public string? PalletNo { get; init; }
    }

    private sealed class ReservationLocationRow
    {
        public string? Location { get; init; }
    }
}
