using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class Frm6550Repository(DbConnectionFactory db) : IFrm6550Repository
{
    public async Task<IEnumerable<Frm6550Dto.ResDto>?> SearchAsync(Frm6550Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = new StringBuilder(@"
                                     SELECT
                                         H.STOK_ITEM AS StokItem,

                                         MAX(M.MAST_NAME) AS MastName,

                                         SUM(CASE
                                                 WHEN H.STOK_WH = 'S'
                                                 THEN H.STOK_QTY
                                                 ELSE 0
                                             END) AS StokSqty,

                                         SUM(CASE
                                                 WHEN H.STOK_WH = 'W'
                                                 THEN H.STOK_QTY
                                                 ELSE 0
                                             END) AS StokWqty,

                                         SUM(CASE
                                                 WHEN H.STOK_WH = 'M'
                                                 THEN H.STOK_QTY
                                                 ELSE 0
                                             END) AS StokMqty,

                                         SUM(H.STOK_QTY) AS StokTqty,

                                         MAX(G1.GUBN1_NAME) AS Gubn1Name,
                                         MAX(G2.GUBN2_NAME) AS Gubn2Name,
                                         MAX(G3.GUBN3_NAME) AS Gubn3Name,

                                         SUM(CASE
                                                 WHEN H.STOK_WH = 'A'
                                                 THEN H.STOK_QTY
                                                 ELSE 0
                                             END) AS StokAqty,

                                         SUM(CASE
                                                 WHEN H.STOK_WH = 'B'
                                                 THEN H.STOK_QTY
                                                 ELSE 0
                                             END) AS StokBqty,

                                         SUM(CASE
                                                 WHEN H.STOK_WH = 'C'
                                                 THEN H.STOK_QTY
                                                 ELSE 0
                                             END) AS StokCqty,

                                         SUM(CASE
                                                 WHEN H.STOK_WH = 'D'
                                                 THEN H.STOK_QTY
                                                 ELSE 0
                                             END) AS StokDqty,

                                         SUM(CASE
                                                 WHEN H.STOK_WH = 'E'
                                                 THEN H.STOK_QTY
                                                 ELSE 0
                                             END) AS StokEqty

                                             FROM MISTOK_HIST H WITH (NOLOCK)
                                             LEFT OUTER JOIN MIMAST M WITH (NOLOCK)
                                                 ON H.STOK_ITEM = M.MAST_CODE
                                             LEFT OUTER JOIN MIGUBN1 G1 WITH (NOLOCK)
                                                 ON M.MAST_GUBN1 = G1.GUBN1_CODE
                                             LEFT OUTER JOIN MIGUBN2 G2 WITH (NOLOCK)
                                                 ON M.MAST_GUBN2 = G2.GUBN2_CODE
                                             LEFT OUTER JOIN MIGUBN3 G3 WITH (NOLOCK)
                                                 ON M.MAST_GUBN3 = G3.GUBN3_CODE
                                             WHERE H.CLOSE_DATE = @CloseDate
                                               AND ISNULL(H.STOK_ITEM, '') <> ''
                                             ");

        var param = new DynamicParameters();

        if (!string.IsNullOrWhiteSpace(reqDto.CloseDate))
        {
            param.Add("CloseDate", $"{reqDto.CloseDate}");
        }

        // 품목코드
        if (!string.IsNullOrWhiteSpace(reqDto.StokItem))
        {
            sql.AppendLine(" AND H.STOK_ITEM = @StokItem ");
            param.Add("StokItem", reqDto.StokItem.Trim());
        }

        // 품목명
        if (!string.IsNullOrWhiteSpace(reqDto.MastName))
        {
            sql.AppendLine(" AND M.MAST_NAME LIKE @MastName ");
            param.Add("MastName", $"%{reqDto.MastName.Trim()}%");
        }

        if (reqDto.StokWhM)
        {
            sql.AppendLine(" And  H.STOK_WH Not IN ('S','W') ");
        }
        if (reqDto.StokWhS)
        {
            sql.AppendLine(" And  H.STOK_WH = 'S' ");
        }
        if (reqDto.StokWhW)
        {
            sql.AppendLine(" And  H.STOK_WH = 'W' ");
        }

        if (!string.IsNullOrWhiteSpace(reqDto.DangerousType))
        {
            sql.AppendLine(" And  M.MAST_GUBN1 = @DangerousType ");
            param.Add("DangerousType", reqDto.DangerousType);
        }
        if (!string.IsNullOrWhiteSpace(reqDto.PetroleumType))
        {
            sql.AppendLine(" And  M.MAST_GUBN2 = @PetroleumType ");
            param.Add("PetroleumType", reqDto.PetroleumType);
        }
        if (!string.IsNullOrWhiteSpace(reqDto.SolubilityType))
        {
            sql.AppendLine(" And  M.MAST_GUBN3 = @SolubilityType ");
            param.Add("SolubilityType", reqDto.SolubilityType);
        }

        sql.AppendLine(" GROUP BY H.STOK_ITEM ");
        sql.AppendLine(" ORDER BY H.STOK_ITEM ");

        return await conn.QueryAsync<Frm6550Dto.ResDto>(
            sql.ToString(),
            param);
    }
}
