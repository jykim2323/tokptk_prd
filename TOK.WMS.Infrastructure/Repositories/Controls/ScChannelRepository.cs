using Dapper;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Controls;

public sealed class ScChannelRepository(DbConnectionFactory db) : IScChannelRepository
{
    public async Task<IReadOnlyList<ScChannelDto>> GetChannelsAsync(int scNo)
    {
        ValidateScNo(scNo);

        // 테이블/컬럼 이름은 SQL 파라미터로 전달할 수 없으므로,
        // 검증을 통과한 1~7 숫자로만 안전하게 조합한다.
        var tableName = $"dbo.T2TBSCC{scNo}";
        var columnPrefix = $"SCC{scNo}";

        // 현재 상품 운영 DB: CH01=16비트, CH02~05=4자리, CH06=16비트이며 CH07은 없다.
        var sql = $"""
                  SELECT
                      LTRIM(RTRIM({columnPrefix}_SR)) AS Sr,
                      COALESCE({columnPrefix}_CH01, '') AS Ch01,
                      COALESCE({columnPrefix}_CH02, '') AS Ch02,
                      COALESCE({columnPrefix}_CH03, '') AS Ch03,
                      COALESCE({columnPrefix}_CH04, '') AS Ch04,
                      COALESCE({columnPrefix}_CH05, '') AS Ch05,
                      COALESCE({columnPrefix}_CH06, '') AS Ch06
                  FROM {tableName} WITH (NOLOCK)
                  WHERE {columnPrefix}_SR IN ('R', 'S')
                  ORDER BY CASE {columnPrefix}_SR
                               WHEN 'R' THEN 0
                               WHEN 'S' THEN 1
                               ELSE 2
                           END;
                  """;

        using var connection = db.Create();
        var channels = (await connection.QueryAsync<ScChannelDto>(sql)).AsList();

        ValidateChannelRows(scNo, channels);
        return channels;
    }

    public async Task UpdateChannelGroupAsync(
        int scNo,
        string sr,
        ScChannelUpdateGroup group,
        ScChannelUpdateDto values)
    {
        ArgumentNullException.ThrowIfNull(values);
        ValidateScNo(scNo);

        var normalizedSr = NormalizeSr(sr);
        var tableName = $"dbo.T2TBSCC{scNo}";
        var columnPrefix = $"SCC{scNo}";
        var parameters = new DynamicParameters();
        parameters.Add("Sr", normalizedSr);

        string setClause;
        switch (group)
        {
            case ScChannelUpdateGroup.Ch01:
                setClause = $"{columnPrefix}_CH01 = @Ch01";
                parameters.Add("Ch01", ValidateBits(values.Ch01, "CH01"));
                break;

            case ScChannelUpdateGroup.Ch06:
                setClause = $"{columnPrefix}_CH06 = @Ch06";
                parameters.Add("Ch06", ValidateBits(values.Ch06, "CH06"));
                break;

            case ScChannelUpdateGroup.Words when normalizedSr == "R":
                setClause = $"""
                             {columnPrefix}_CH02 = @Ch02,
                             {columnPrefix}_CH03 = @Ch03,
                             {columnPrefix}_CH04 = @Ch04
                             """;
                parameters.Add("Ch02", ValidateWord(values.Ch02, "CH02"));
                parameters.Add("Ch03", ValidateWord(values.Ch03, "CH03"));
                parameters.Add("Ch04", ValidateWord(values.Ch04, "CH04"));
                break;

            case ScChannelUpdateGroup.Words:
                setClause = $"""
                             {columnPrefix}_CH02 = @Ch02,
                             {columnPrefix}_CH03 = @Ch03,
                             {columnPrefix}_CH04 = @Ch04,
                             {columnPrefix}_CH05 = @Ch05
                             """;
                parameters.Add("Ch02", ValidateWord(values.Ch02, "CH02"));
                parameters.Add("Ch03", ValidateWord(values.Ch03, "CH03"));
                parameters.Add("Ch04", ValidateWord(values.Ch04, "CH04"));
                parameters.Add("Ch05", ValidateWord(values.Ch05, "CH05"));
                break;

            default:
                throw new ArgumentOutOfRangeException(nameof(group), group, "지원하지 않는 수정 영역입니다.");
        }

        var sql = $"""
                  UPDATE {tableName}
                  SET {setClause}
                  WHERE {columnPrefix}_SR = @Sr;
                  """;

        using var connection = db.Create();
        var affectedRows = await connection.ExecuteAsync(sql, parameters);
        if (affectedRows != 1)
        {
            throw new InvalidOperationException(
                $"T2TBSCC{scNo}의 {normalizedSr} 신호 행을 하나만 수정해야 하지만 {affectedRows}개 행이 수정되었습니다.");
        }
    }

    private static void ValidateScNo(int scNo)
    {
        if (scNo is < 1 or > 7)
        {
            throw new ArgumentOutOfRangeException(
                nameof(scNo),
                scNo,
                "스태커 크레인 호기는 1에서 7 사이여야 합니다.");
        }
    }

    private static string NormalizeSr(string sr)
    {
        var normalized = (sr ?? string.Empty).Trim().ToUpperInvariant();
        if (normalized is not ("R" or "S"))
            throw new ArgumentException("송·수신 구분은 R 또는 S여야 합니다.", nameof(sr));

        return normalized;
    }

    private static string ValidateBits(string? value, string channel)
    {
        var normalized = (value ?? string.Empty).Trim();
        if (normalized.Length != 16 || normalized.Any(bit => bit is not ('0' or '1')))
        {
            throw new ArgumentException(
                $"{channel}은 0과 1로 구성된 16자리 값이어야 합니다.",
                channel);
        }

        return normalized;
    }

    private static string ValidateWord(string? value, string channel)
    {
        var normalized = (value ?? string.Empty).Trim();
        if (normalized.Length != 4)
        {
            throw new ArgumentException(
                $"{channel}은 4자리 값이어야 합니다.",
                channel);
        }

        return normalized;
    }

    private static void ValidateChannelRows(int scNo, IReadOnlyCollection<ScChannelDto> channels)
    {
        var hasReceive = channels.Count(channel => channel.Sr == "R") == 1;
        var hasSend = channels.Count(channel => channel.Sr == "S") == 1;

        if (channels.Count != 2 || !hasReceive || !hasSend)
        {
            throw new InvalidOperationException(
                $"T2TBSCC{scNo}에는 R/S 신호 행이 각각 하나씩 있어야 합니다.");
        }
    }
}
