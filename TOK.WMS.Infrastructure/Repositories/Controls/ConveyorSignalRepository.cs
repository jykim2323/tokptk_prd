using Dapper;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Controls;

public sealed class ConveyorSignalRepository(DbConnectionFactory db) : IConveyorSignalRepository
{
    public async Task<IReadOnlyList<ConveyorSignalGridDto>> GetAsync(
        CancellationToken cancellationToken = default)
    {
        const string sql = """
                           SELECT
                               LTRIM(RTRIM(CVC1_SR)) AS Direction,
                               channel.GridNo,
                               COALESCE(
                                   NULLIF(LTRIM(RTRIM(channel.SignalValue)), ''),
                                   channel.DefaultValue) AS Bits,
                               CAST(1 AS bit) AS IsMapped
                           FROM dbo.T2TBCVC1
                           CROSS APPLY (VALUES
                               (1, CVC1_CH01, '0000000000000000'),
                               (2, CVC1_CH02, '0000000000000000'),
                               (3, CVC1_CH03, '0000000000000000'),
                               (4, CVC1_CH04, '0000000000000000'),
                               (5, CVC1_CH05, '0000000000000000'),
                               (6, CVC1_CH06, '0000000000000000')
                           ) channel(GridNo, SignalValue, DefaultValue)
                           WHERE CVC1_SR IN ('R', 'S')

                           UNION ALL

                           SELECT
                               LTRIM(RTRIM(CVC2_SR)) AS Direction,
                               channel.GridNo,
                               COALESCE(
                                   NULLIF(LTRIM(RTRIM(channel.SignalValue)), ''),
                                   channel.DefaultValue) AS Bits,
                               CAST(1 AS bit) AS IsMapped
                           FROM dbo.T2TBCVC2
                           CROSS APPLY (VALUES
                               (7, CVC2_CH01, '0000000000000000'),
                               (8, CVC2_CH02, '0000000000000000'),
                               (9, CVC2_CH03, '0000000000000000'),
                               (10, CVC2_CH04, '0000000000000000'),
                               (11, CVC2_CH05, '0000000000000000'),
                               (12, CVC2_CH06, '0000000000000000')
                           ) channel(GridNo, SignalValue, DefaultValue)
                           WHERE CVC2_SR IN ('R', 'S')
                             AND NOT (CVC2_SR = 'R' AND channel.GridNo IN (8, 9, 10))

                           UNION ALL

                           SELECT
                               'R' AS Direction,
                               channel.GridNo,
                               COALESCE(
                                   NULLIF(LTRIM(RTRIM(channel.SignalValue)), ''),
                                   channel.DefaultValue) AS Bits,
                               CAST(1 AS bit) AS IsMapped
                           FROM dbo.T2TBRGV1
                           CROSS APPLY (VALUES
                               (8, RGV1_CH01, '0000000000000000'),
                               (9, RGV1_CH02, '0000'),
                               (10, RGV1_CH03, '0000')
                           ) channel(GridNo, SignalValue, DefaultValue)
                           WHERE RGV1_SR = 'R'

                           ORDER BY Direction, GridNo;
                           """;

        using var connection = db.Create();
        var command = new CommandDefinition(sql, cancellationToken: cancellationToken);
        var signals = (await connection.QueryAsync<ConveyorSignalGridDto>(command)).AsList();

        return CompleteSignalRows(signals);
    }

    public async Task UpdateAsync(
        string direction,
        int gridNo,
        ConveyorSignalUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(values);

        var normalizedDirection = NormalizeDirection(direction);
        var target = ResolveTarget(normalizedDirection, gridNo);
        var normalizedBits = ValidateValue(values.Bits, target, nameof(values.Bits));

        // 테이블과 컬럼은 검증된 Grid 번호로만 선택하고, 값은 SQL 파라미터로 전달한다.
        var sql = $"""
                   UPDATE {target.TableName}
                   SET {target.ColumnName} = @Bits
                   WHERE {target.DirectionColumn} = @Direction;
                   """;

        using var connection = db.Create();
        var command = new CommandDefinition(
            sql,
            new { Bits = normalizedBits, Direction = normalizedDirection },
            cancellationToken: cancellationToken);
        var affectedRows = await connection.ExecuteAsync(command);
        if (affectedRows != 1)
        {
            throw new InvalidOperationException(
                $"컨베이어 {normalizedDirection} Grid {gridNo} 신호를 하나만 수정해야 하지만 " +
                $"{affectedRows}개 행이 수정되었습니다.");
        }
    }

    public async Task UpdateBitAsync(
        string direction,
        int gridNo,
        int bitIndex,
        ConveyorSignalBitUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(values);

        if (bitIndex is < 0 or > 15)
        {
            throw new ArgumentOutOfRangeException(
                nameof(bitIndex),
                bitIndex,
                "컨베이어 신호 BIT 번호는 0에서 15 사이여야 합니다.");
        }

        var normalizedDirection = NormalizeDirection(direction);
        var target = ResolveTarget(normalizedDirection, gridNo);
        if (!target.IsBitSignal)
        {
            throw new InvalidOperationException(
                $"컨베이어 {normalizedDirection} Grid {gridNo}은 16 BIT 신호가 아니라 " +
                $"{target.ValueLength}자리 값입니다.");
        }

        var bitValue = values.IsActive ? "1" : "0";

        // 현재 DB 값을 기준으로 지정 BIT만 바꾼다. 통신 중 다른 BIT가 갱신되어도
        // 화면에서 읽었던 오래된 16 BIT 전체 값으로 덮어쓰지 않는다.
        var sql = $"""
                   UPDATE {target.TableName} WITH (UPDLOCK, ROWLOCK)
                   SET {target.ColumnName} = STUFF(
                       LTRIM(RTRIM({target.ColumnName})),
                       @BitPosition,
                       1,
                       @BitValue)
                   WHERE {target.DirectionColumn} = @Direction
                     AND LEN(LTRIM(RTRIM(COALESCE({target.ColumnName}, '')))) = 16
                     AND LTRIM(RTRIM(COALESCE({target.ColumnName}, ''))) NOT LIKE '%[^01]%';
                   """;

        using var connection = db.Create();
        var command = new CommandDefinition(
            sql,
            new
            {
                BitPosition = bitIndex + 1,
                BitValue = bitValue,
                Direction = normalizedDirection
            },
            cancellationToken: cancellationToken);
        var affectedRows = await connection.ExecuteAsync(command);
        if (affectedRows != 1)
        {
            throw new InvalidOperationException(
                $"컨베이어 {normalizedDirection} Grid {gridNo}의 현재 신호가 " +
                "정상적인 16 BIT 값인지 확인해 주세요.");
        }
    }

    private static SignalTarget ResolveTarget(string direction, int gridNo)
    {
        if (gridNo is < 1 or > 12)
        {
            throw new ArgumentOutOfRangeException(
                nameof(gridNo),
                gridNo,
                "컨베이어 신호 Grid 번호는 1에서 12 사이여야 합니다.");
        }

        return TryResolveTarget(direction, gridNo)
               ?? throw new InvalidOperationException(
                   $"컨베이어 {direction} Grid {gridNo}은 DB 채널에 연결되지 않았습니다.");
    }

    private static SignalTarget? TryResolveTarget(string direction, int gridNo)
        => (direction, gridNo) switch
        {
            // PLC -> COM: D5007~D5009 (RGV #1)
            ("R", 8) => new SignalTarget(
                "dbo.T2TBRGV1", "RGV1_CH01", "RGV1_SR", 16, true),
            ("R", 9) => new SignalTarget(
                "dbo.T2TBRGV1", "RGV1_CH02", "RGV1_SR", 4, false),
            ("R", 10) => new SignalTarget(
                "dbo.T2TBRGV1", "RGV1_CH03", "RGV1_SR", 4, false),

            // 그 외 Grid는 변경 전 CVC 고정 매핑을 그대로 사용한다.
            (_, >= 1 and <= 6) => new SignalTarget(
                "dbo.T2TBCVC1", $"CVC1_CH{gridNo:00}", "CVC1_SR", 16, true),
            (_, >= 7 and <= 12) => new SignalTarget(
                "dbo.T2TBCVC2", $"CVC2_CH{gridNo - 6:00}", "CVC2_SR", 16, true),
            _ => null
        };

    private static string NormalizeDirection(string direction)
    {
        var normalized = (direction ?? string.Empty).Trim().ToUpperInvariant();
        if (normalized is not ("R" or "S"))
        {
            throw new ArgumentException(
                "송·수신 구분은 R 또는 S여야 합니다.",
                nameof(direction));
        }

        return normalized;
    }

    private static string ValidateValue(
        string? value,
        SignalTarget target,
        string parameterName)
    {
        var normalized = (value ?? string.Empty).Trim();
        if (normalized.Length != target.ValueLength)
        {
            throw new ArgumentException(
                $"신호 값은 정확히 {target.ValueLength}자리여야 합니다.",
                parameterName);
        }

        if (target.IsBitSignal && normalized.Any(bit => bit is not ('0' or '1')))
        {
            throw new ArgumentException(
                "16 BIT 신호 값은 0과 1로만 구성되어야 합니다.",
                parameterName);
        }

        return normalized;
    }

    private static IReadOnlyList<ConveyorSignalGridDto> CompleteSignalRows(
        IReadOnlyCollection<ConveyorSignalGridDto> signals)
    {
        var completed = new List<ConveyorSignalGridDto>(24);

        foreach (var direction in new[] { "R", "S" })
        {
            for (var gridNo = 1; gridNo <= 12; gridNo++)
            {
                var matches = signals.Where(signal =>
                    string.Equals(signal.Direction, direction, StringComparison.OrdinalIgnoreCase)
                    && signal.GridNo == gridNo).ToList();
                var target = TryResolveTarget(direction, gridNo);
                if (target is null)
                {
                    if (matches.Count != 0)
                    {
                        throw new InvalidOperationException(
                            $"컨베이어 {direction} Grid {gridNo}에 예상하지 않은 신호 행이 조회되었습니다.");
                    }

                    completed.Add(new ConveyorSignalGridDto
                    {
                        Direction = direction,
                        GridNo = gridNo,
                        Bits = "0000000000000000",
                        IsMapped = false
                    });
                    continue;
                }

                if (matches.Count != 1)
                {
                    throw new InvalidOperationException(
                        $"컨베이어 {direction} Grid {gridNo}의 DB 신호 행은 하나여야 합니다.");
                }

                var signal = matches[0];
                signal.Direction = direction;
                signal.Bits = ValidateValue(
                    signal.Bits,
                    target,
                    $"{direction} Grid {gridNo}");
                signal.IsMapped = true;
                completed.Add(signal);
            }
        }

        return completed;
    }

    private sealed record SignalTarget(
        string TableName,
        string ColumnName,
        string DirectionColumn,
        int ValueLength,
        bool IsBitSignal);
}
