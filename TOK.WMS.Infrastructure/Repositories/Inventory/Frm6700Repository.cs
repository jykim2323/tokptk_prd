using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class Frm6700Repository(DbConnectionFactory db) : IFrm6700Repository
{
    public async Task<IEnumerable<Frm6700Dto.ResDto>?> SearchAsync(Frm6700Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = new StringBuilder(@"
                                    SELECT
                                        JEGO_DATE AS JegoDate,
                                        JEGO_CODE AS JegoCode,

                                        MAX(MAST_NAME) AS MastName,

                                        SUM(JEGO_WQTY) AS JegoWqty,
                                        SUM(JEGO_SQTY) AS JegoSqty,

                                        SUM(JEGO_AQTY) AS JegoAqty,
                                        SUM(JEGO_TQTY) AS JegoTqty,

                                        MAX(GUBN1_NAME) AS Gubn1Name,
                                        MAX(GUBN2_NAME) AS Gubn2Name,
                                        MAX(GUBN3_NAME) AS Gubn3Name

                                    FROM T1MIJEGO WITH (NOLOCK)

                                    LEFT OUTER JOIN MIMAST WITH (NOLOCK)
                                        ON JEGO_CODE = MAST_CODE

                                    LEFT OUTER JOIN MIGUBN1 WITH (NOLOCK)
                                        ON GUBN1_CODE = MAST_GUBN1

                                    LEFT OUTER JOIN MIGUBN2 WITH (NOLOCK)
                                        ON GUBN2_CODE = MAST_GUBN2

                                    LEFT OUTER JOIN MIGUBN3 WITH (NOLOCK)
                                        ON GUBN3_CODE = MAST_GUBN3

                                    WHERE ISNULL(JEGO_CODE, '') <> ''
                                      AND JEGO_DATE = @JegoDate
                                ");

        var param = new DynamicParameters();

        if (!string.IsNullOrWhiteSpace(reqDto.JegoDate))
        {
            param.Add("JegoDate", $"{reqDto.JegoDate}");
        }

        if (!string.IsNullOrWhiteSpace(reqDto.JegoCode))
        {
            sql.AppendLine(" AND JEGO_CODE LIKE @JegoCode ");
            param.Add("JegoCode", $"{reqDto.JegoCode.Trim()}%");
        }

        if (reqDto.StokWhM)
        {
            sql.AppendLine(" And  JEGO_WH Not IN ('S','W') ");
        }
        if (reqDto.StokWhS)
        {
            sql.AppendLine(" And  JEGO_WH = 'S' ");
        }
        if (reqDto.StokWhW)
        {
            sql.AppendLine(" And  JEGO_WH = 'W' ");
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

        sql.AppendLine(@"
        GROUP BY JEGO_DATE, JEGO_CODE
        ORDER BY JEGO_DATE, JEGO_CODE");


        return await conn.QueryAsync<Frm6700Dto.ResDto>(
            sql.ToString(),
            param);



        //var sql = new StringBuilder(@"
        //                            SELECT
        //                                JEGO_DATE AS JegoDate,
        //                                JEGO_CODE AS JegoCode,

        //                                MAX(MAST_NAME) AS MastName,

        //                                SUM(JEGO_WQTY) AS JegoWqty,
        //                                SUM(JEGO_SQTY) AS JegoSqty,

        //                                SUM(JEGO_AQTY) AS JegoAqty,
        //                                SUM(JEGO_BQTY) AS JegoBqty,
        //                                SUM(JEGO_CQTY) AS JegoCqty,
        //                                SUM(JEGO_DQTY) AS JegoDqty,
        //                                SUM(JEGO_EQTY) AS JegoEqty,

        //                                SUM(JEGO_FQTY) AS JegoFqty,
        //                                SUM(JEGO_TQTY) AS JegoTqty,

        //                                MAX(GUBN1_NAME) AS Gubn1Name,
        //                                MAX(GUBN2_NAME) AS Gubn2Name,
        //                                MAX(GUBN3_NAME) AS Gubn3Name

        //                            FROM T1MIJEGO WITH (NOLOCK)

        //                            LEFT OUTER JOIN MIMAST WITH (NOLOCK)
        //                                ON JEGO_CODE = MAST_CODE

        //                            LEFT OUTER JOIN MIGUBN1 WITH (NOLOCK)
        //                                ON GUBN1_CODE = MAST_GUBN1

        //                            LEFT OUTER JOIN MIGUBN2 WITH (NOLOCK)
        //                                ON GUBN2_CODE = MAST_GUBN2

        //                            LEFT OUTER JOIN MIGUBN3 WITH (NOLOCK)
        //                                ON GUBN3_CODE = MAST_GUBN3

        //                            WHERE ISNULL(JEGO_CODE, '') <> ''
        //                              AND JEGO_DATE = @JegoDate
        //                        ");

        //var param = new DynamicParameters();

        //if (!string.IsNullOrWhiteSpace(reqDto.JegoDate))
        //{
        //    param.Add("JegoDate", $"{reqDto.JegoDate}");
        //}

        //if (!string.IsNullOrWhiteSpace(reqDto.JegoCode))
        //{
        //    sql.AppendLine(" AND JEGO_CODE LIKE @JegoCode ");
        //    param.Add("JegoCode", $"{reqDto.JegoCode.Trim()}%");
        //}

        //if (reqDto.StokWhM)
        //{
        //    sql.AppendLine(" And  H.STOK_WH Not IN ('S','W') ");
        //}
        //if (reqDto.StokWhS)
        //{
        //    sql.AppendLine(" And  H.STOK_WH = 'S' ");
        //}
        //if (reqDto.StokWhW)
        //{
        //    sql.AppendLine(" And  H.STOK_WH = 'W' ");
        //}

        //if (!string.IsNullOrWhiteSpace(reqDto.DangerousType))
        //{
        //    sql.AppendLine(" And  M.MAST_GUBN1 = @DangerousType ");
        //    param.Add("DangerousType", reqDto.DangerousType);
        //}
        //if (!string.IsNullOrWhiteSpace(reqDto.PetroleumType))
        //{
        //    sql.AppendLine(" And  M.MAST_GUBN2 = @PetroleumType ");
        //    param.Add("PetroleumType", reqDto.PetroleumType);
        //}
        //if (!string.IsNullOrWhiteSpace(reqDto.SolubilityType))
        //{
        //    sql.AppendLine(" And  M.MAST_GUBN3 = @SolubilityType ");
        //    param.Add("SolubilityType", reqDto.SolubilityType);
        //}

        //sql.AppendLine(@"
        //GROUP BY JEGO_DATE, JEGO_CODE
        ////ORDER BY JEGO_DATE, JEGO_CODE");
    }
}
