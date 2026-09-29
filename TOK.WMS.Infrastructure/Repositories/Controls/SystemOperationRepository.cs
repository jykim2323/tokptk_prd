using Dapper;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Controls;

/// <summary>
/// dbo.T2TBSTAT의 JPLS 행에서 1층 시스템 운전 설정을 조회·부분 수정한다.
/// </summary>
public sealed class SystemOperationRepository(DbConnectionFactory db) : ISystemOperationRepository
{
    private const long MaximumSequence = 999_999_999_999_999_999L;

    public async Task<SystemOperationDto> GetAsync(CancellationToken cancellationToken = default)
    {
        const string sql = """
                           SELECT
                               CONVERT(int, COALESCE(STAT_SC1IO, '3')) AS Sc1Mode,
                               CONVERT(int, COALESCE(STAT_SC2IO, '3')) AS Sc2Mode,
                               CONVERT(int, COALESCE(STAT_SC3IO, '3')) AS Sc3Mode,
                               CONVERT(int, COALESCE(STAT_SC4IO, '3')) AS Sc4Mode,
                               CONVERT(int, COALESCE(STAT_SC5IO, '3')) AS Sc5Mode,
                               CONVERT(int, COALESCE(STAT_SC6IO, '3')) AS Sc6Mode,
                               CONVERT(int, COALESCE(STAT_SC7IO, '3')) AS Sc7Mode,
                               CONVERT(bigint, COALESCE(STAT_IINDX, 1)) AS InboundSequence,
                               CONVERT(bigint, COALESCE(STAT_OINDX, 1)) AS OutboundSequence,
                               CONVERT(bigint, COALESCE(STAT_RINDX, 1)) AS ReInboundSequence,
                               CONVERT(bigint, COALESCE(STAT_EINDX, 1)) AS EmptyPalletSequence,
                               CONVERT(int, COALESCE(STAT_HOGI, 1)) AS InboundCrane
                           FROM dbo.T2TBSTAT WITH (NOLOCK)
                           WHERE STAT_PSWD = 'JPLS';
                           """;

        using var connection = db.Create();
        var row = await connection.QuerySingleOrDefaultAsync<SystemOperationRow>(
            new CommandDefinition(sql, cancellationToken: cancellationToken));

        if (row is null)
        {
            throw new InvalidOperationException(
                "T2TBSTAT에서 STAT_PSWD='JPLS' 시스템 설정 행을 찾을 수 없습니다.");
        }

        var craneModes = new[]
        {
            row.Sc1Mode,
            row.Sc2Mode,
            row.Sc3Mode,
            row.Sc4Mode,
            row.Sc5Mode,
            row.Sc6Mode,
            row.Sc7Mode
        };
        ValidateCraneModes(craneModes);

        return new SystemOperationDto
        {
            CraneModes = craneModes,
            InboundSequence = row.InboundSequence,
            OutboundSequence = row.OutboundSequence,
            ReInboundSequence = row.ReInboundSequence,
            EmptyPalletSequence = row.EmptyPalletSequence,
            InboundCrane = row.InboundCrane
        };
    }

    public async Task UpdateAsync(
        SystemOperationUpdateGroup group,
        SystemOperationUpdateDto values,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(values);

        var parameters = new DynamicParameters();
        string setClause;

        switch (group)
        {
            case SystemOperationUpdateGroup.Modes:
            {
                var modes = values.CraneModes
                    ?? throw new ArgumentException("호기별 운전모드 값이 필요합니다.", nameof(values));
                ValidateCraneModes(modes);

                setClause = """
                            STAT_SC1IO = @Sc1Mode,
                            STAT_SC2IO = @Sc2Mode,
                            STAT_SC3IO = @Sc3Mode,
                            STAT_SC4IO = @Sc4Mode,
                            STAT_SC5IO = @Sc5Mode,
                            STAT_SC6IO = @Sc6Mode,
                            STAT_SC7IO = @Sc7Mode
                            """;

                for (var index = 0; index < modes.Length; index++)
                    parameters.Add($"Sc{index + 1}Mode", modes[index].ToString());
                break;
            }

            case SystemOperationUpdateGroup.Sequences:
                var inbound = ValidateSequence(values.InboundSequence, "입고순번");
                var outbound = ValidateSequence(values.OutboundSequence, "출고순번");
                var reInbound = ValidateSequence(values.ReInboundSequence, "재입고순번");
                var emptyPallet = ValidateSequence(values.EmptyPalletSequence, "공팔레트순번");

                setClause = """
                            STAT_IINDX = @InboundSequence,
                            STAT_OINDX = @OutboundSequence,
                            STAT_RINDX = @ReInboundSequence,
                            STAT_EINDX = @EmptyPalletSequence
                            """;
                parameters.Add("InboundSequence", inbound);
                parameters.Add("OutboundSequence", outbound);
                parameters.Add("ReInboundSequence", reInbound);
                parameters.Add("EmptyPalletSequence", emptyPallet);
                break;

            case SystemOperationUpdateGroup.InboundCrane:
                var inboundCrane = values.InboundCrane
                    ?? throw new ArgumentException("입고 호기 값이 필요합니다.", nameof(values));
                if (inboundCrane is < 1 or > 7)
                {
                    throw new ArgumentOutOfRangeException(
                        nameof(values),
                        inboundCrane,
                        "입고 호기는 1에서 7 사이여야 합니다.");
                }

                setClause = "STAT_HOGI = @InboundCrane";
                parameters.Add("InboundCrane", inboundCrane);
                break;

            default:
                throw new ArgumentOutOfRangeException(nameof(group), group, "지원하지 않는 시스템 운전 설정 수정 영역입니다.");
        }

        var sql = $"""
                   UPDATE dbo.T2TBSTAT
                   SET {setClause}
                   WHERE STAT_PSWD = 'JPLS';
                   """;

        using var connection = db.Create();
        var affectedRows = await connection.ExecuteAsync(
            new CommandDefinition(sql, parameters, cancellationToken: cancellationToken));

        if (affectedRows != 1)
        {
            throw new InvalidOperationException(
                $"T2TBSTAT의 JPLS 시스템 설정 행을 하나만 수정해야 하지만 {affectedRows}개 행이 수정되었습니다.");
        }
    }

    private static void ValidateCraneModes(IReadOnlyCollection<int> modes)
    {
        if (modes.Count != 7)
            throw new ArgumentException("스태커 크레인 1~7호기의 운전모드 7개가 필요합니다.", nameof(modes));

        if (modes.Any(mode => mode is < 0 or > 3))
        {
            throw new ArgumentOutOfRangeException(
                nameof(modes),
                "운전모드는 0(입출고금지), 1(입고가능), 2(출고가능), 3(입출고가능) 중 하나여야 합니다.");
        }
    }

    private static long ValidateSequence(long? value, string label)
    {
        if (value is null)
            throw new ArgumentException($"{label} 값이 필요합니다.", nameof(value));

        if (value is < 0 or > MaximumSequence)
        {
            throw new ArgumentOutOfRangeException(
                nameof(value),
                value,
                $"{label}은 0부터 {MaximumSequence}까지 입력할 수 있습니다.");
        }

        return value.Value;
    }

    private sealed class SystemOperationRow
    {
        public int Sc1Mode { get; init; }
        public int Sc2Mode { get; init; }
        public int Sc3Mode { get; init; }
        public int Sc4Mode { get; init; }
        public int Sc5Mode { get; init; }
        public int Sc6Mode { get; init; }
        public int Sc7Mode { get; init; }
        public long InboundSequence { get; init; }
        public long OutboundSequence { get; init; }
        public long ReInboundSequence { get; init; }
        public long EmptyPalletSequence { get; init; }
        public int InboundCrane { get; init; }
    }
}
