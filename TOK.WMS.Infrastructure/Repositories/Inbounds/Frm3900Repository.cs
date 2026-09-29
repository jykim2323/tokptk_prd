using Dapper;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inbounds;

public class Frm3900Repository(DbConnectionFactory db) : IFrm3900Repository
{
    public async Task<IEnumerable<Frm3900Dto.ResDto>?> SearchAsync(
        Frm3900Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = new StringBuilder();

        sql.AppendLine(@"
            SELECT
                A.OUPT_DATE       AS OuptDate,
                A.OUPT_INDEX      AS OuptIndex,
                A.OUPT_SEQNO      AS OuptSeqno,

                A.OUPT_PLTNO      AS OuptPltno,
                A.OUPT_CODE       AS OuptCode,
                B.MAST_NAME       AS MastName,
                A.OUPT_LOTNO      AS OuptLotno,

                A.OUPT_WGT        AS OuptWgt,
                A.OUPT_OUT_WGT    AS OuptOutWgt,

                A.OUPT_BOXNO      AS OuptBoxno,
                A.OUPT_REMARK     AS OuptRemark,

                A.OUPT_LOCA       AS OuptLoca,
                A.OUPT_RLOCA      AS OuptRloca,
                A.OUPT_TIME       AS OuptTime,

                A.OUPT_RFLAG      AS OuptRflag,
                A.OUPT_JOB_FLAG   AS OuptJobFlag,

                A.OUPT_INDATE     AS OuptIndate,
                A.OUPT_INTIME     AS OuptIntime,

                CASE
                    WHEN C.SUBK_PLTNO IS NULL THEN '0'
                    WHEN ISNULL(C.SUBK_LOCA, '') = '' THEN '1'
                    ELSE '2'
                END AS StatusCode,

                ISNULL(C.SUBK_WGT, 0) AS CurrWgt

            FROM T2MIOUPT A WITH (NOLOCK)

            LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                ON A.OUPT_CODE = B.MAST_CODE

            LEFT OUTER JOIN
            (
                SELECT
                    SUBK_PLTNO,
                    MAX(SUBK_LOCA) AS SUBK_LOCA,
                    SUM(SUBK_WGT) AS SUBK_WGT

                FROM T2MISUBK WITH (NOLOCK)

                GROUP BY SUBK_PLTNO
            ) C
                ON A.OUPT_PLTNO = C.SUBK_PLTNO

            WHERE 1 = 1
              AND A.OUPT_DATE >= @FromDate
              AND A.OUPT_DATE <= @ToDate
        ");

        var param = new DynamicParameters();

        param.Add("FromDate", reqDto.FromDate);
        param.Add("ToDate", reqDto.ToDate);

        if (reqDto.Hogi == "1")
        {
            sql.AppendLine(
                " AND SUBSTRING(A.OUPT_LOCA, 1, 1) IN ('1','2') ");
        }
        else if (reqDto.Hogi == "2")
        {
            sql.AppendLine(
                " AND SUBSTRING(A.OUPT_LOCA, 1, 1) IN ('3','4') ");
        }
        else if (reqDto.Hogi == "3")
        {
            sql.AppendLine(
                " AND SUBSTRING(A.OUPT_LOCA, 1, 1) IN ('5','6') ");
        }

        var searchText = reqDto.SearchText?.Trim();

        if (!string.IsNullOrWhiteSpace(searchText))
        {
            switch (reqDto.SearchType)
            {
                case "PLTNO":

                    sql.AppendLine(
                        " AND A.OUPT_PLTNO LIKE @SearchText ");

                    param.Add(
                        "SearchText",
                        $"%{searchText}%");

                    break;

                case "CODE":

                    sql.AppendLine(
                        " AND A.OUPT_CODE = @SearchText ");

                    param.Add(
                        "SearchText",
                        searchText);

                    break;

                case "NAME":

                    sql.AppendLine(
                        " AND B.MAST_NAME LIKE @SearchText ");

                    param.Add(
                        "SearchText",
                        $"%{searchText}%");

                    break;

                case "LOTNO":

                    sql.AppendLine(
                        " AND A.OUPT_LOTNO LIKE @SearchText ");

                    param.Add(
                        "SearchText",
                        $"%{searchText}%");

                    break;
            }
        }

        sql.AppendLine(@"
            ORDER BY
                A.OUPT_DATE DESC,
                A.OUPT_TIME DESC,
                A.OUPT_PLTNO,
                A.OUPT_SEQNO
        ");

        return await conn.QueryAsync<Frm3900Dto.ResDto>(
            sql.ToString(),
            param);
    }

    public async Task<IEnumerable<Frm3900Dto.WorkDto>?> FloorStockSearchAsync(
    string pltNo)
    {
        using var conn = db.Create();

        const string sql = @"
            SELECT
                A.SUBK_PLTNO   AS SubkPltno,
                A.SUBK_CODE    AS SubkCode,
                B.MAST_NAME    AS MastName,
                A.SUBK_LOTNO   AS SubkLotno,

                A.SUBK_WGT     AS SubkWgt,
                A.SUBK_BOXNO   AS SubkBoxno,
                A.SUBK_REMARK  AS SubkRemark,

                A.SUBK_INDATE  AS SubkIndate,
                A.SUBK_INTIME  AS SubkIntime,

                '1' AS Status

            FROM T2MISUBK A WITH (NOLOCK)

            LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                ON A.SUBK_CODE = B.MAST_CODE

            WHERE A.SUBK_PLTNO = @PltNo

            ORDER BY
                A.SUBK_CODE,
                A.SUBK_LOTNO
        ";

        return await conn.QueryAsync<Frm3900Dto.WorkDto>(
            sql,
            new
            {
                PltNo = pltNo
            });
    }

    public async Task<Frm3900Dto.ItemDto?> ItemCheckAsync(
    string itemCode)
    {
        using var conn = db.Create();

        const string sql = @"
            SELECT
                MAST_CODE AS MastCode,
                MAST_NAME AS MastName,
                MAST_WEIGHT AS MastWeight

            FROM MIMAST WITH (NOLOCK)

            WHERE MAST_CODE = @ItemCode
        ";

        return await conn.QueryFirstOrDefaultAsync<Frm3900Dto.ItemDto>(
            sql,
            new
            {
                ItemCode = itemCode
            });
    }
    public async Task<Frm3900Dto.PltCheckDto?> PltCheckAsync(
    string pltNo)
    {
        using var conn = db.Create();

        const string sql = @"
            SELECT
                COUNT(*) AS Count,
                MAX(ISNULL(SUBK_LOCA, '')) AS SubkLoca

            FROM T2MISUBK WITH (NOLOCK)

            WHERE SUBK_PLTNO = @PltNo
        ";

        return await conn.QueryFirstOrDefaultAsync<Frm3900Dto.PltCheckDto>(
            sql,
            new
            {
                PltNo = pltNo
            });
    }

    public async Task<int> SaveAsync(
    Frm3900Dto.SaveReqDto reqDto)
    {
        using var conn = db.Create();

        conn.Open();

        using var transaction = conn.BeginTransaction();

        try
        {
            var affected = 0;

            const string deleteSql = @"
                DELETE FROM T2MISUBK

                WHERE SUBK_PLTNO = @SubkPltno
                  AND SUBK_CODE = @SubkCode
                  AND SUBK_LOTNO = @SubkLotno
            ";

            foreach (var item in reqDto.DeleteItems)
            {
                affected += await conn.ExecuteAsync(
                    deleteSql,
                    item,
                    transaction);
            }


            foreach (var item in reqDto.Items)
            {
                const string checkSql = @"
                    SELECT COUNT(*)

                    FROM T2MISUBK WITH (NOLOCK)

                    WHERE SUBK_PLTNO = @SubkPltno
                      AND SUBK_CODE = @SubkCode
                      AND SUBK_LOTNO = @SubkLotno
                ";

                var exists =
                    await conn.ExecuteScalarAsync<int>(
                        checkSql,
                        new
                        {
                            item.SubkPltno,
                            item.SubkCode,
                            item.SubkLotno
                        },
                        transaction);


                if (exists > 0)
                {
                    const string updateSql = @"
                        UPDATE T2MISUBK

                        SET
                            SUBK_WGT = @SubkWgt,
                            SUBK_RWGT = 0,
                            SUBK_BOXNO = @SubkBoxno,
                            SUBK_REMARK = @SubkRemark,
                            SUBK_FLAG = 'R',
                            SUBK_GUBUN = ''

                        WHERE SUBK_PLTNO = @SubkPltno
                          AND SUBK_CODE = @SubkCode
                          AND SUBK_LOTNO = @SubkLotno
                    ";

                    affected += await conn.ExecuteAsync(
                        updateSql,
                        item,
                        transaction);
                }
                else
                {
                    const string insertSql = @"
                        INSERT INTO T2MISUBK
                        (
                            SUBK_PLTNO,
                            SUBK_CODE,
                            SUBK_LOTNO,
                            SUBK_WGT,
                            SUBK_RWGT,
                            SUBK_BOXNO,
                            SUBK_REMARK,
                            SUBK_FLAG,
                            SUBK_GUBUN,
                            SUBK_INDATE,
                            SUBK_INTIME,
                            SUBK_USERID
                        )
                        VALUES
                        (
                            @SubkPltno,
                            @SubkCode,
                            @SubkLotno,
                            @SubkWgt,
                            0,
                            @SubkBoxno,
                            @SubkRemark,
                            'R',
                            '',
                            CONVERT(VARCHAR(8), GETDATE(), 112),
                            REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', ''),
                            @UserId
                        )
                    ";

                    affected += await conn.ExecuteAsync(
                        insertSql,
                        new
                        {
                            item.SubkPltno,
                            item.SubkCode,
                            item.SubkLotno,
                            item.SubkWgt,
                            item.SubkBoxno,
                            item.SubkRemark,
                            UserId = reqDto.UserId ?? string.Empty
                        },
                        transaction);
                }
            }

            transaction.Commit();

            return affected;
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }
}
