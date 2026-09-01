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
using static TOK.WMS.Core.DTOs.Inventory.Frm6100Dto;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class Frm6200Repository(DbConnectionFactory db) : IFrm6200Repository
{
    public async Task<IEnumerable<Frm6200Dto.ResDto>?> SearchAsync(Frm6200Dto.SearchReqDto searchDto)
    {
        using var conn = db.Create();

        var sql = new StringBuilder(@"
                                     SELECT
                                            subk_loca   AS SubkLoca,
                                            subk_code   AS SubkCode,
                                            mast_name   AS MastName,
                                            subk_flag   AS SubkFlag,
                                            subk_gubun  AS SubkGubun,
                                            subk_pltno  AS SubkPltno,
                                            subk_wgt    AS SubkWgt,
                                            subk_rwgt   AS SubkRwgt,
                                            subk_lotno  AS SubkLotno,
                                            subk_boxno  AS SubkBoxno,
                                            subk_indate AS SubkIndate,
                                            subk_intime AS SubkIntime,
                                            subk_remark AS SubkRemark,
                                            gubn1_name  AS Gubn1Name,
                                            gubn2_name  AS Gubn2Name,
                                            gubn3_name  AS Gubn3Name
                                     FROM T1MISUBK WITH (NOLOCK)

                                     LEFT OUTER JOIN MIMAST WITH (NOLOCK)
                                         ON MAST_CODE = SUBK_CODE

                                     LEFT OUTER JOIN MIGUBN1 WITH (NOLOCK)
                                         ON GUBN1_CODE = MAST_GUBN1

                                     LEFT OUTER JOIN MIGUBN2 WITH (NOLOCK)
                                         ON GUBN2_CODE = MAST_GUBN2

                                     LEFT OUTER JOIN MIGUBN3 WITH (NOLOCK)
                                         ON GUBN3_CODE = MAST_GUBN3

                                     WHERE ISNULL(SUBK_LOCA, '') <> ''
                                       AND SUBK_INDATE >= @FromDate
                                       AND SUBK_INDATE <= @ToDate
                                    ");

        var param = new DynamicParameters();

        param.Add("FromDate", searchDto.FromDate);
        param.Add("ToDate", searchDto.ToDate);

        // 검색조건
        switch (searchDto.SearchType)
        {
            case "LOCA":
                if (!string.IsNullOrWhiteSpace(searchDto.SearchText))
                {
                    sql.AppendLine(" AND SUBK_LOCA = @SearchText");
                    param.Add("SearchText", searchDto.SearchText.Trim());
                }
                break;

            case "CODE":
                if (!string.IsNullOrWhiteSpace(searchDto.SearchText))
                {
                    sql.AppendLine(" AND SUBK_CODE = @SearchText");
                    param.Add("SearchText", searchDto.SearchText.Trim());
                }
                break;

            case "NAME":
                if (!string.IsNullOrWhiteSpace(searchDto.SearchText))
                {
                    sql.AppendLine(" AND MAST_NAME LIKE @SearchText");
                    param.Add("SearchText", $"%{searchDto.SearchText.Trim()}%");
                }
                break;

            case "LOTNO":
                if (!string.IsNullOrWhiteSpace(searchDto.SearchText))
                {
                    sql.AppendLine(" AND SUBK_LOTNO = @SearchText");
                    param.Add("SearchText", searchDto.SearchText.Trim());
                }
                break;
        }

        // 위험물
        if (!string.IsNullOrWhiteSpace(searchDto.DangerousType))
        {
            sql.AppendLine(" AND MAST_GUBN1 = @DangerousType");
            param.Add("DangerousType", searchDto.DangerousType);
        }

        // 석유류
        if (!string.IsNullOrWhiteSpace(searchDto.PetroleumType))
        {
            sql.AppendLine(" AND MAST_GUBN2 = @PetroleumType");
            param.Add("PetroleumType", searchDto.PetroleumType);
        }

        // 수용성
        if (!string.IsNullOrWhiteSpace(searchDto.SolubilityType))
        {
            sql.AppendLine(" AND MAST_GUBN3 = @SolubilityType");
            param.Add("SolubilityType", searchDto.SolubilityType);
        }

        sql.AppendLine(" ORDER BY SUBK_LOCA, SUBK_PLTNO");

        return await conn.QueryAsync<Frm6200Dto.ResDto>(
            sql.ToString(),
            param);
    }
    public async Task<bool> ProhibitionAsync(Frm6200Dto.ProhibitionReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
                    UPDATE T1MILSTK
                    SET
                        LSTK_FLAG   = @_strFlag
                    WHERE LSTK_LOCA = @_strLoca";

        var response = await conn.ExecuteAsync(
            sql,
            new
            {
                _strFlag = reqDto.BanType,
                _strLoca = reqDto.SubkLoca
            });

        return response > 0;
    }
}

