using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class Frm6300Repository(DbConnectionFactory db) : IFrm6300Repository
{
    public async Task<IEnumerable<Frm6300Dto.ResDto>?> SearchAsync(Frm6300Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = new StringBuilder(@"
                                     SELECT
                                            STK_CODE AS SubkCode,
                                            SUM(STK_TQTY) AS SubkTqty,
                                            MAX(MAST_NAME)  AS MastName,
                                            MAX(GUBN1_NAME)  AS Gubn1Name,
                                            MAX(GUBN2_NAME)  AS Gubn2Name,
                                            MAX(GUBN3_NAME)  AS Gubn3Name
                                     FROM T1SUBK_VIEW WITH (NOLOCK)
                                     LEFT OUTER JOIN MIMAST (NOLOCK) ON STK_CODE   = MAST_CODE
                                     LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1
                                     LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2
                                     LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3
                                     WHERE 1 = 1
                                    ");

        var param = new DynamicParameters();

        if(!string.IsNullOrWhiteSpace(reqDto.SubkCode))
        {
            sql.AppendLine(" And  STK_CODE  LIKE @SubkCode ");
            param.Add("SubkCode", $"{reqDto.SubkCode}%");
        }

        if (!string.IsNullOrWhiteSpace(reqDto.DangerousType))
        {
            sql.AppendLine(" And  GUBN1_NAME = @DangerousType ");
            param.Add("DangerousType", reqDto.DangerousType);
        }

        if (!string.IsNullOrWhiteSpace(reqDto.PetroleumType))
        {
            sql.AppendLine(" And  GUBN2_NAME = @PetroleumType ");
            param.Add("PetroleumType", reqDto.PetroleumType);
        }

        if (!string.IsNullOrWhiteSpace(reqDto.SolubilityType))
        {
            sql.AppendLine(" And  GUBN3_NAME = @SolubilityType ");
            param.Add("SolubilityType", reqDto.SolubilityType);
        }

        sql.AppendLine(" GROUP By STK_CODE ");
        sql.AppendLine(" Order By STK_CODE ");

        return await conn.QueryAsync<Frm6300Dto.ResDto>(
            sql.ToString(),
            param);
    }
}

