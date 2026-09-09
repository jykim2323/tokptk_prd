using Dapper;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public class Frm4500Repository(
    DbConnectionFactory db)
    : IFrm4500Repository
{
    // =========================================================
    // 품목별 출고 실적
    //
    // Delphi StartBitBtnClick
    // =========================================================

    public async Task<IEnumerable<Frm4500Dto.ItemSummaryDto>?> SearchAsync(
        Frm4500Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        var sql = @"
            SELECT
                A.STK_CODE AS StkCode,

                MAX(
                    B.MAST_NAME
                ) AS MastName,

                SUM(
                    ISNULL(
                        A.STK_TQTY,
                        0
                    )
                ) AS StkTqty

            FROM T1OUPT_VIEW A WITH (NOLOCK)

            LEFT JOIN MIMAST B WITH (NOLOCK)
                ON A.STK_CODE =
                   B.MAST_CODE

            WHERE ISNULL(
                      A.STK_DATE,
                      ''
                  ) <> ''

              AND A.STK_CODE <> 'EMPTY'

              AND A.STK_DATE >= @FromDate
              AND A.STK_DATE <= @ToDate
        ";


        var param =
            new DynamicParameters();


        param.Add(
            "FromDate",
            reqDto.FromDate);


        param.Add(
            "ToDate",
            reqDto.ToDate);


        // =====================================================
        // 품목코드
        //
        // 고객사 요청:
        // LIKE가 아니라 정확히 일치
        // =====================================================

        if (!string.IsNullOrWhiteSpace(
            reqDto.ItemCode))
        {
            sql += @"
                AND A.STK_CODE =
                    @ItemCode
            ";


            param.Add(
                "ItemCode",
                reqDto.ItemCode.Trim());
        }


        // =====================================================
        // 품목명
        // =====================================================

        if (!string.IsNullOrWhiteSpace(
            reqDto.ItemName))
        {
            sql += @"
                AND B.MAST_NAME LIKE
                    '%' + @ItemName + '%'
            ";


            param.Add(
                "ItemName",
                reqDto.ItemName.Trim());
        }


        sql += @"
            GROUP BY
                A.STK_CODE

            ORDER BY
                A.STK_CODE
        ";


        return await conn.QueryAsync<
            Frm4500Dto.ItemSummaryDto>(
            sql,
            param);
    }


    // =========================================================
    // LOT별 출고 실적
    //
    // Delphi LotNo_Select_Proc
    // =========================================================

    public async Task<IEnumerable<Frm4500Dto.LotSummaryDto>?> LotSearchAsync(
        Frm4500Dto.LotReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                A.STK_CODE AS StkCode,

                MAX(
                    B.MAST_NAME
                ) AS MastName,

                A.STK_LOTNO AS StkLotno,

                SUM(
                    ISNULL(
                        A.STK_TQTY,
                        0
                    )
                ) AS StkTqty

            FROM T1OUPT_VIEW A WITH (NOLOCK)

            LEFT JOIN MIMAST B WITH (NOLOCK)
                ON A.STK_CODE =
                   B.MAST_CODE

            WHERE ISNULL(
                      A.STK_DATE,
                      ''
                  ) <> ''

              AND A.STK_CODE =
                  @ItemCode

              AND A.STK_DATE >=
                  @FromDate

              AND A.STK_DATE <=
                  @ToDate

            GROUP BY
                A.STK_CODE,
                A.STK_LOTNO

            ORDER BY
                A.STK_CODE,
                A.STK_LOTNO
        ";


        return await conn.QueryAsync<
            Frm4500Dto.LotSummaryDto>(
            sql,
            new
            {
                reqDto.FromDate,
                reqDto.ToDate,
                reqDto.ItemCode
            });
    }
}