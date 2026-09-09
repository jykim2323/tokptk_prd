using Dapper;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public class MastDispRepository(
    DbConnectionFactory db)
    : IMastDispRepository
{
    // =========================================================
    // 검색
    //
    // Delphi:
    // WHERE MAST_CODE LIKE '%검색어%'
    // =========================================================

    public async Task<IEnumerable<MastDispDto.ResDto>?> SearchAsync(
        MastDispDto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                A.MAST_CODE              AS MastCode,
                A.MAST_NAME              AS MastName,
                A.MAST_UNIT              AS MastUnit,
                ISNULL(A.MAST_WEIGHT, 0) AS MastWeight,

                B.GUBN1_NAME             AS Gubn1Name,
                C.GUBN2_NAME             AS Gubn2Name,
                D.GUBN3_NAME             AS Gubn3Name

            FROM MIMAST A WITH (NOLOCK)

            LEFT JOIN MIGUBN1 B WITH (NOLOCK)
                ON B.GUBN1_CODE = A.MAST_GUBN1

            LEFT JOIN MIGUBN2 C WITH (NOLOCK)
                ON C.GUBN2_CODE = A.MAST_GUBN2

            LEFT JOIN MIGUBN3 D WITH (NOLOCK)
                ON D.GUBN3_CODE = A.MAST_GUBN3

            WHERE A.MAST_CODE LIKE @SearchText

            ORDER BY A.MAST_CODE
        ";


        return await conn.QueryAsync<
            MastDispDto.ResDto>(
            sql,
            new
            {
                SearchText =
                    $"%{reqDto.SearchText?.Trim() ?? string.Empty}%"
            });
    }


    // =========================================================
    // 전체보기
    // =========================================================

    public async Task<IEnumerable<MastDispDto.ResDto>?> AllSearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                A.MAST_CODE              AS MastCode,
                A.MAST_NAME              AS MastName,
                A.MAST_UNIT              AS MastUnit,
                ISNULL(A.MAST_WEIGHT, 0) AS MastWeight,

                B.GUBN1_NAME             AS Gubn1Name,
                C.GUBN2_NAME             AS Gubn2Name,
                D.GUBN3_NAME             AS Gubn3Name

            FROM MIMAST A WITH (NOLOCK)

            LEFT JOIN MIGUBN1 B WITH (NOLOCK)
                ON B.GUBN1_CODE = A.MAST_GUBN1

            LEFT JOIN MIGUBN2 C WITH (NOLOCK)
                ON C.GUBN2_CODE = A.MAST_GUBN2

            LEFT JOIN MIGUBN3 D WITH (NOLOCK)
                ON D.GUBN3_CODE = A.MAST_GUBN3

            ORDER BY A.MAST_CODE
        ";


        return await conn.QueryAsync<
            MastDispDto.ResDto>(
            sql);
    }
}