using Dapper;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Globalization;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inbounds;

public class Frm3700Repository(DbConnectionFactory db) : IFrm3700Repository
{
    public async Task<IEnumerable<Frm3700Dto.ResDto>> SearchAsync(Frm3700Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = new StringBuilder();

        sql.AppendLine(@"
            SELECT
                A.STK_CODE          AS StkCode,
                SUM(A.STK_TQTY)     AS StkTqty,
                MAX(B.MAST_NAME)    AS MastName

            FROM T2INPT_VIEW A WITH (NOLOCK)

            LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                ON A.STK_CODE = B.MAST_CODE

            WHERE ISNULL(A.STK_DATE, '') <> ''
              AND A.STK_CODE <> 'EMPTY'
              AND A.STK_DATE >= @FromDate
              AND A.STK_DATE <= @ToDate
        ");

        var param = new DynamicParameters();

        param.Add("FromDate", reqDto.FromDate);
        param.Add("ToDate", reqDto.ToDate);


        // 품목코드
        if (!string.IsNullOrWhiteSpace(reqDto.ItemCode))
        {
            sql.AppendLine(
                " AND A.STK_CODE = @ItemCode ");

            param.Add(
                "ItemCode",
                reqDto.ItemCode.Trim());
        }


        // 품목명
        if (!string.IsNullOrWhiteSpace(reqDto.ItemName))
        {
            sql.AppendLine(
                " AND B.MAST_NAME LIKE @ItemName ");

            param.Add(
                "ItemName",
                $"%{reqDto.ItemName.Trim()}%");
        }


        sql.AppendLine(@"
            GROUP BY A.STK_CODE
            ORDER BY A.STK_CODE
        ");


        return await conn.QueryAsync<Frm3700Dto.ResDto>(
            sql.ToString(),
            param);
    }
    public async Task<IEnumerable<Frm3700Dto.LotResDto>> LotSearchAsync(Frm3700Dto.LotReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
            SELECT
                A.STK_CODE          AS StkCode,
                A.STK_LOTNO         AS StkLotno,
                SUM(A.STK_TQTY)     AS StkTqty,
                MAX(B.MAST_NAME)    AS MastName

            FROM T2INPT_VIEW A WITH (NOLOCK)

            LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                ON A.STK_CODE = B.MAST_CODE

            WHERE ISNULL(A.STK_DATE, '') <> ''
              AND A.STK_CODE = @StkCode
              AND A.STK_DATE >= @FromDate
              AND A.STK_DATE <= @ToDate

            GROUP BY
                A.STK_CODE,
                A.STK_LOTNO

            ORDER BY
                A.STK_CODE,
                A.STK_LOTNO
        ";


        return await conn.QueryAsync<Frm3700Dto.LotResDto>(
            sql,
            new
            {
                StkCode = reqDto.StkCode ?? string.Empty,
                FromDate = reqDto.FromDate ?? string.Empty,
                ToDate = reqDto.ToDate ?? string.Empty
            });
    }

}
