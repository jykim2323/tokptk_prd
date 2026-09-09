using Dapper;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public class Frm1100Repository(
    DbConnectionFactory db)
    : IFrm1100Repository
{
    // =========================================================
    // 품목 조회
    // Delphi StartBitBtnClick
    // =========================================================

    public async Task<IEnumerable<Frm1100Dto.ResDto>?> SearchAsync(
        Frm1100Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                A.MAST_CODE      AS MastCode,
                A.MAST_BCODE     AS MastBcode,
                A.MAST_NAME      AS MastName,
                A.MAST_UNIT      AS MastUnit,

                ISNULL(
                    A.MAST_WEIGHT,
                    0
                )                AS MastWeight,

                A.MAST_GUBN1     AS MastGubn1,
                B.GUBN1_NAME     AS Gubn1Name,

                A.MAST_GUBN2     AS MastGubn2,
                C.GUBN2_NAME     AS Gubn2Name,

                A.MAST_GUBN3     AS MastGubn3,
                D.GUBN3_NAME     AS Gubn3Name,

                A.MAST_DATE      AS MastDate,
                A.MAST_REF1      AS MastRef1

            FROM MIMAST A WITH (NOLOCK)

            LEFT JOIN MIGUBN1 B WITH (NOLOCK)
                ON B.GUBN1_CODE =
                   A.MAST_GUBN1

            LEFT JOIN MIGUBN2 C WITH (NOLOCK)
                ON C.GUBN2_CODE =
                   A.MAST_GUBN2

            LEFT JOIN MIGUBN3 D WITH (NOLOCK)
                ON D.GUBN3_CODE =
                   A.MAST_GUBN3

            WHERE A.MAST_CODE >=
                  @ItemCode

            ORDER BY
                A.MAST_CODE
        ";


        return await conn.QueryAsync<
            Frm1100Dto.ResDto>(
            sql,
            new
            {
                ItemCode =
                    string.IsNullOrWhiteSpace(
                        reqDto.ItemCode)
                        ? "0"
                        : reqDto.ItemCode.Trim()
            });
    }


    // =========================================================
    // 구분1
    // =========================================================

    public async Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn1SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN1_CODE AS Code,
                GUBN1_NAME AS Name

            FROM MIGUBN1 WITH (NOLOCK)

            ORDER BY
                GUBN1_CODE
        ";


        return await conn.QueryAsync<
            Frm1100Dto.GubnDto>(
            sql);
    }


    // =========================================================
    // 구분2
    // =========================================================

    public async Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn2SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN2_CODE AS Code,
                GUBN2_NAME AS Name

            FROM MIGUBN2 WITH (NOLOCK)

            ORDER BY
                GUBN2_CODE
        ";


        return await conn.QueryAsync<
            Frm1100Dto.GubnDto>(
            sql);
    }


    // =========================================================
    // 구분3
    // =========================================================

    public async Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn3SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN3_CODE AS Code,
                GUBN3_NAME AS Name

            FROM MIGUBN3 WITH (NOLOCK)

            ORDER BY
                GUBN3_CODE
        ";


        return await conn.QueryAsync<
            Frm1100Dto.GubnDto>(
            sql);
    }
}