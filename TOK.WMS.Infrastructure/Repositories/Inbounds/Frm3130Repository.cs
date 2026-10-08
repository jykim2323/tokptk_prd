using Dapper;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inbounds;

public class Frm3130Repository(DbConnectionFactory db) : IFrm3130Repository
{
    // =========================================================
    // PLT 조회
    // =========================================================

    public async Task<IEnumerable<Frm3130Dto.ResDto>?> SearchAsync(
        Frm3130Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        if (string.IsNullOrWhiteSpace(reqDto.SubkPltno))
            return [];

        const string sql = @"
            SELECT
                A.SUBK_LOCA    AS SubkLoca,
                A.SUBK_PLTNO   AS SubkPltno,
                A.SUBK_CODE    AS SubkCode,
                B.MAST_NAME    AS MastName,
                B.MAST_UNIT    AS MastUnit,
                A.SUBK_LOTNO   AS SubkLotno,
                A.SUBK_FLAG    AS SubkFlag,
                A.SUBK_GUBUN   AS SubkGubun,
                A.SUBK_WGT     AS SubkWgt,
                A.SUBK_RWGT    AS SubkRwgt,
                A.SUBK_BOXNO   AS SubkBoxno,
                A.SUBK_REMARK  AS SubkRemark,
                A.SUBK_INDATE  AS SubkIndate,
                A.SUBK_INTIME  AS SubkIntime

            FROM T2MISUBK A WITH (NOLOCK)

            LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                ON A.SUBK_CODE = B.MAST_CODE

            WHERE A.SUBK_PLTNO = @SubkPltno

            ORDER BY
                A.SUBK_CODE,
                A.SUBK_LOTNO
        ";

        return await conn.QueryAsync<Frm3130Dto.ResDto>(
            sql,
            new
            {
                SubkPltno = reqDto.SubkPltno
            });
    }


    // =========================================================
    // PLT 상태 체크
    //
    // Tracking
    // T2MILSTK
    // 바닥/위치 재고
    // Block Flag
    // =========================================================

    public async Task<Frm3130Dto.PltCheckDto?> PltCheckAsync(
        string pltNo)
    {
        using var conn = db.Create();

        const string sql = $@"
            SELECT

                (
                    {PalletTrackingSql.CountByPallet}
                ) AS TrackingCount,

                (
                    SELECT COUNT(*)
                    FROM T2MILSTK WITH (NOLOCK)
                    WHERE LSTK_PLTNO = @PltNo
                ) AS LstkCount,

                (
                    SELECT COUNT(*)
                    FROM T2MISUBK WITH (NOLOCK)
                    WHERE SUBK_PLTNO = @PltNo
                      AND ISNULL(SUBK_LOCA, '') <> ''
                ) AS LocatedSubkCount,

                (
                    SELECT TOP 1 SUBK_FLAG
                    FROM T2MISUBK WITH (NOLOCK)
                    WHERE SUBK_PLTNO = @PltNo
                      AND SUBK_FLAG IN ('X','1','Y','M')
                ) AS BlockFlag,

                (
                    SELECT MAX(ISNULL(SUBK_LOCA, ''))
                    FROM T2MISUBK WITH (NOLOCK)
                    WHERE SUBK_PLTNO = @PltNo
                ) AS SubkLoca
        ";

        return await conn.QueryFirstOrDefaultAsync<
            Frm3130Dto.PltCheckDto>(
            sql,
            new
            {
                PltNo = pltNo
            });
    }


    // =========================================================
    // 일반 제품 등록
    // =========================================================

    public async Task<Frm3130Dto.InsertResultDto> InsertAsync(
        Frm3130Dto.InsertReqDto reqDto)
    {
        using var conn = db.Create();

        const string duplicateSql = @"
            SELECT COUNT(*)

            FROM T2MISUBK WITH (NOLOCK)

            WHERE SUBK_CODE = @SubkCode
              AND SUBK_LOTNO = @SubkLotno
              AND SUBK_PLTNO = @SubkPltno
        ";

        var duplicate =
            await conn.ExecuteScalarAsync<int>(
                duplicateSql,
                new
                {
                    reqDto.SubkCode,
                    SubkLotno = reqDto.SubkLotno ?? string.Empty,
                    reqDto.SubkPltno
                });


        if (duplicate > 0)
        {
            return new Frm3130Dto.InsertResultDto
            {
                Success = false,

                Message =
                    $"{reqDto.SubkPltno} / " +
                    $"{reqDto.SubkCode} / " +
                    $"{reqDto.SubkLotno}\n" +
                    "[T1MISUBK 등록 에러]\n이미 등록된 데이터입니다."
            };
        }


        const string insertSql = @"
            INSERT INTO T2MISUBK
            (
                SUBK_CODE,
                SUBK_LOTNO,
                SUBK_FLAG,
                SUBK_GUBUN,

                SUBK_WGT,
                SUBK_RWGT,

                SUBK_BOXNO,
                SUBK_REMARK,

                SUBK_INDATE,
                SUBK_INTIME,

                SUBK_PLTNO,
                SUBK_USERID
            )
            VALUES
            (
                @SubkCode,
                @SubkLotno,
                '0',
                '',

                @SubkWgt,
                0,

                @SubkBoxno,
                @SubkRemark,

                CONVERT(VARCHAR(8), GETDATE(), 112),
                REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', ''),

                @SubkPltno,
                @UserId
            )
        ";


        var result =
            await conn.ExecuteAsync(
                insertSql,
                new
                {
                    reqDto.SubkCode,
                    SubkLotno = reqDto.SubkLotno ?? string.Empty,
                    reqDto.SubkWgt,

                    SubkBoxno =
                        reqDto.SubkBoxno ?? string.Empty,

                    SubkRemark =
                        reqDto.SubkRemark ?? string.Empty,

                    reqDto.SubkPltno,

                    UserId =
                        reqDto.UserId ?? string.Empty
                });


        return new Frm3130Dto.InsertResultDto
        {
            Success = result > 0,

            Message =
                result > 0
                    ? "등록 완료"
                    : "등록 실패"
        };
    }


    // =========================================================
    // EMPTY 등록
    //
    // 기존 EMPTY 있으면 +1
    // 없으면 INSERT
    // =========================================================

    public async Task<Frm3130Dto.EmptyResultDto> EmptyInsertAsync(
        string pltNo,
        string userId)
    {
        using var conn = db.Create();

        conn.Open();

        using var transaction =
            conn.BeginTransaction();

        try
        {
            const string qtySql = @"
                SELECT ISNULL(
                    SUM(SUBK_WGT),
                    0
                )

                FROM T2MISUBK WITH (UPDLOCK, HOLDLOCK)

                WHERE SUBK_PLTNO = @PltNo
                  AND SUBK_CODE = 'EMPTY'
            ";

            var currentQty =
                await conn.ExecuteScalarAsync<decimal>(
                    qtySql,
                    new
                    {
                        PltNo = pltNo
                    },
                    transaction);


            var newQty =
                currentQty + 1;


            if (currentQty > 0)
            {
                const string updateSql = @"
                    UPDATE T2MISUBK

                    SET SUBK_WGT = @NewQty

                    WHERE SUBK_PLTNO = @PltNo
                      AND SUBK_CODE = 'EMPTY'
                ";

                await conn.ExecuteAsync(
                    updateSql,
                    new
                    {
                        PltNo = pltNo,
                        NewQty = newQty
                    },
                    transaction);
            }
            else
            {
                const string insertSql = @"
                    INSERT INTO T2MISUBK
                    (
                        SUBK_CODE,
                        SUBK_LOTNO,
                        SUBK_FLAG,
                        SUBK_GUBUN,

                        SUBK_WGT,
                        SUBK_RWGT,

                        SUBK_BOXNO,
                        SUBK_REMARK,

                        SUBK_INDATE,
                        SUBK_INTIME,

                        SUBK_PLTNO,
                        SUBK_USERID
                    )
                    VALUES
                    (
                        'EMPTY',
                        '',
                        '0',
                        '',

                        @NewQty,
                        0,

                        '',
                        '',

                        CONVERT(VARCHAR(8), GETDATE(), 112),
                        REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', ''),

                        @PltNo,
                        @UserId
                    )
                ";

                await conn.ExecuteAsync(
                    insertSql,
                    new
                    {
                        PltNo = pltNo,
                        NewQty = newQty,
                        UserId = userId
                    },
                    transaction);
            }


            const string nameSql = @"
                SELECT MAST_NAME

                FROM MIMAST WITH (NOLOCK)

                WHERE MAST_CODE = 'EMPTY'
            ";

            var mastName =
                await conn.QueryFirstOrDefaultAsync<string>(
                    nameSql,
                    transaction: transaction);


            transaction.Commit();


            return new Frm3130Dto.EmptyResultDto
            {
                Success = true,

                MastName =
                    mastName ?? "공파렛트",

                Qty =
                    newQty
            };
        }
        catch
        {
            transaction.Rollback();

            throw;
        }
    }


    // =========================================================
    // 단건 삭제
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm3130Dto.DeleteReqDto reqDto)
    {
        using var conn = db.Create();

        const string sql = @"
            DELETE FROM T2MISUBK

            WHERE SUBK_CODE = @SubkCode
              AND SUBK_LOTNO = @SubkLotno
              AND SUBK_PLTNO = @SubkPltno
        ";

        return await conn.ExecuteAsync(
            sql,
            new
            {
                reqDto.SubkCode,
                SubkLotno =
                    reqDto.SubkLotno ?? string.Empty,

                reqDto.SubkPltno
            });
    }


    // =========================================================
    // PLT 전체 삭제
    // =========================================================

    public async Task<int> DeleteAllAsync(
        string pltNo)
    {
        using var conn = db.Create();

        const string sql = @"
            DELETE FROM T2MISUBK

            WHERE SUBK_PLTNO = @PltNo
        ";

        return await conn.ExecuteAsync(
            sql,
            new
            {
                PltNo = pltNo
            });
    }
}