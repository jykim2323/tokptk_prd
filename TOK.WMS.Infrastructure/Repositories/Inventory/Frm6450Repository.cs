using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class Frm6450Repository(DbConnectionFactory db) : IFrm6450Repository
{
    public async Task<IEnumerable<Frm6450Dto.ResDto>?> SearchAsync(Frm6450Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        if(reqDto.HistYN == false)
        {
            var sql = new StringBuilder(@"
                                     SELECT
                                     STOK_WH AS StokWh,
                                     STOK_ITEM AS StokItem,
                                     MAST_NAME  AS MastName,
                                     STOK_LOTNO  AS StokLotno,
                                     STOK_LOCA   AS StokLoca,
                                     STOK_QTY    AS StokQty,     
                                     STOK_BOXNO    AS StokBoxno,  
                                     STOK_REMARK    AS StokRemark,  
                                     STOK_INDATE    AS StokIndate,  
                                     STOK_INTIME    AS StokIntime,  
                                     STOK_FLAG    AS StokInflag,  
                                     gubn1_name    AS Gubn1Name,  
                                     gubn2_name    AS Gubn2Name,   
                                     gubn3_name    AS Gubn3Name               
                                     FROM MISTOK WITH (NOLOCK)
                                     LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE   = STOK_ITEM
                                     LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1
                                     LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2
                                     LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3
                                     WHERE ISNULL(STOK_ITEM, '') <> ''
                                    ");

            var param = new DynamicParameters();

            if (!string.IsNullOrWhiteSpace(reqDto.StokItem))
            {
                sql.AppendLine(" And  STOK_ITEM  = @StokItem ");
                param.Add("StokItem", reqDto.StokItem);
            }

            if (!string.IsNullOrWhiteSpace(reqDto.MastName))
            {
                sql.AppendLine(" And  MAST_NAME  LIKE @MastName ");
                param.Add("MastName", $"%{reqDto.MastName}%");
            }

            if (reqDto.StokWhM)
            {
                sql.AppendLine(" And  STOK_WH Not IN ('S','W') ");
            }
            if (reqDto.StokWhS)
            {
                sql.AppendLine(" And  STOK_WH = 'S' ");
            }
            if (reqDto.StokWhW)
            {
                sql.AppendLine(" And  STOK_WH = 'W' ");
            }
            
            if (!string.IsNullOrWhiteSpace(reqDto.DangerousType))
            {
                sql.AppendLine(" And  MAST_GUBN1 = @DangerousType ");
                param.Add("DangerousType", reqDto.DangerousType);
            }
            if (!string.IsNullOrWhiteSpace(reqDto.PetroleumType))
            {
                sql.AppendLine(" And  MAST_GUBN2 = @PetroleumType ");
                param.Add("PetroleumType", reqDto.PetroleumType);
            }
            if (!string.IsNullOrWhiteSpace(reqDto.SolubilityType))
            {
                sql.AppendLine(" And  MAST_GUBN3 = @SolubilityType ");
                param.Add("SolubilityType", reqDto.SolubilityType);
            }

            sql.AppendLine(" Order By STOK_ITEM, STOK_LOCA ");

            return await conn.QueryAsync<Frm6450Dto.ResDto>(
                sql.ToString(),
                param);
        }
        else
        {
            var sql = new StringBuilder(@"
                                     SELECT
                                     A.STOK_WH AS StokWh,
                                     A.STOK_ITEM AS StokItem,
                                     A.MAST_NAME  AS MastName,
                                     A.STOK_LOTNO  AS StokLotno,
                                     A.STOK_LOCA   AS StokLoca,
                                     A.STOK_QTY    AS StokQty,     
                                     A.STOK_BOXNO    AS StokBoxno,  
                                     A.STOK_REMARK    AS StokRemark,  
                                     A.STOK_INDATE    AS StokIndate,  
                                     A.STOK_INTIME    AS StokIntime,  
                                     A.STOK_FLAG    AS StokInflag,  
                                     G1.GUBN1_NAME    AS Gubn1Name,  
                                     G2.GUBN2_NAME    AS Gubn2Name,   
                                     G3.GUBN3_NAME    AS Gubn3Name                
                                     FROM MISTOK_HIST A (NOLOCK)
                                     LEFT OUTER JOIN MIGUBN1 G1 (NOLOCK) ON G1.GUBN1_CODE = A.GUBN1_CODE
                                     LEFT OUTER JOIN MIGUBN2 G2 (NOLOCK) ON G2.GUBN2_CODE = A.GUBN2_CODE
                                     LEFT OUTER JOIN MIGUBN3 G3 (NOLOCK) ON G3.GUBN3_CODE = A.GUBN3_CODE
                                    ");

            var param = new DynamicParameters();


            sql.AppendLine(" WHERE A.CLOSE_DATE = @CloseDate ");
            param.Add("CloseDate", reqDto.CloseDate);

            if (!string.IsNullOrWhiteSpace(reqDto.StokItem))
            {
                sql.AppendLine(" And  A.STOK_ITEM  LIKE @StokItem ");
                param.Add("StokItem", $"%{reqDto.StokItem}%");
            }

            if (!string.IsNullOrWhiteSpace(reqDto.MastName))
            {
                sql.AppendLine(" And  A.MAST_NAME  LIKE @MastName ");
                param.Add("MastName", $"%{reqDto.MastName}%");
            }

            if (reqDto.StokWhM)
            {
                sql.AppendLine(" And  A.STOK_WH Not IN ('S','W') ");
            }
            if (reqDto.StokWhS)
            {
                sql.AppendLine(" And  A.STOK_WH = 'S' ");
            }
            if (reqDto.StokWhW)
            {
                sql.AppendLine(" And  A.STOK_WH = 'W' ");
            }
            


            if (!string.IsNullOrWhiteSpace(reqDto.DangerousType))
            {
                sql.AppendLine(" And  A.GUBN1_CODE = @DangerousType ");
                param.Add("DangerousType", reqDto.DangerousType);
            }
            if (!string.IsNullOrWhiteSpace(reqDto.PetroleumType))
            {
                sql.AppendLine(" And  A.GUBN2_CODE = @PetroleumType ");
                param.Add("PetroleumType", reqDto.PetroleumType);
            }
            if (!string.IsNullOrWhiteSpace(reqDto.SolubilityType))
            {
                sql.AppendLine(" And  A.GUBN3_CODE = @SolubilityType ");
                param.Add("SolubilityType", reqDto.SolubilityType);
            }

            sql.AppendLine(" Order By STOK_ITEM, STOK_LOCA ");

            return await conn.QueryAsync<Frm6450Dto.ResDto>(
                sql.ToString(),
                param);
        }
    }

    public async Task<IEnumerable<Frm6450Dto.ResDto>?> PltnoCntAsync(Frm6450Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        if (reqDto.HistYN == false)
        {
            var sql = @"SELECT STOK_LOCA
                    FROM MISTOK WITH (NOLOCK)
                    Group By STOK_LOCA";

            return await conn.QueryAsync<Frm6450Dto.ResDto>(sql);
        }
        else
        {
            var sql = @"SELECT STOK_LOCA
                    FROM MISTOK_HIST WITH (NOLOCK)
                    WHERE CLOSE_DATE = @CloseDate
                    Group By STOK_LOCA";

            return await conn.QueryAsync<Frm6450Dto.ResDto>(sql, new
            {
                CloseDate = reqDto.CloseDate
            });
        }
    }
}
