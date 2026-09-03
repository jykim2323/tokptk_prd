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

public class Frm6900Repository(DbConnectionFactory db, ICoreRepository coreRepo) : IFrm6900Repository
{
    public async Task<IEnumerable<Frm6900Dto.ResDto>?> SearchAsync(Frm6900Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = new StringBuilder(@"
                                    SELECT
                                        A.SUBK_PLTNO AS SubkPltno,

                                        CASE
                                            WHEN SUM(
                                                CASE
                                                    WHEN A.SUBK_FLAG = 'N' THEN 1
                                                    ELSE 0
                                                END
                                            ) > 0
                                            THEN 'N'
                                            ELSE ''
                                        END AS SubkFlag,

                                        A.SUBK_LOCA AS SubkLoca,

                                        COUNT(A.SUBK_CODE) AS CodeCnt,

                                        CASE
                                            WHEN LEN(RTRIM(ISNULL(MAX(A.SUBK_INDATE), ''))) = 8
                                                 AND ISNUMERIC(MAX(A.SUBK_INDATE)) = 1
                                            THEN
                                                SUBSTRING(RTRIM(MAX(A.SUBK_INDATE)), 1, 4)
                                                + '-'
                                                + SUBSTRING(RTRIM(MAX(A.SUBK_INDATE)), 5, 2)
                                                + '-'
                                                + SUBSTRING(RTRIM(MAX(A.SUBK_INDATE)), 7, 2)
                                            ELSE ''
                                        END AS InDateTime

                                        FROM T1MISUBK A WITH (NOLOCK)
                                        WHERE 1=1 ");

        var param = new DynamicParameters();

        if (!string.IsNullOrWhiteSpace(reqDto.SubkPltno))
        {
            sql.AppendLine(" AND A.SUBK_PLTNO LIKE @SubkPltno ");
            param.Add("SubkPltno", $"%{reqDto.SubkPltno}%");
        }
        else 
        {
            if(!string.IsNullOrWhiteSpace(reqDto.SubkLoca))
            {
                sql.AppendLine(" AND A.SUBK_LOCA >= @SubkLoca ");
                param.Add("SubkLoca", $"{reqDto.SubkLoca}");
            }
        }

        sql.AppendLine(@"
        GROUP BY A.SUBK_PLTNO, A.SUBK_LOCA
        ORDER BY A.SUBK_LOCA, A.SUBK_PLTNO");


        return await conn.QueryAsync<Frm6900Dto.ResDto>(sql.ToString(), param);
    }

    public async Task<IEnumerable<Frm6900Dto.SubkDto>?> SubkSearchAsync(string lstkLoca)
    {
        using var conn = db.Create();

        var sql = $@" SELECT
                        SUBK_LOCA      AS SubkLoca,
                        SUBK_FLAG      AS SubkFlag,
                        SUBK_CODE      AS SubkCode,
                        SUBK_GUBUN     AS SubkGubun,
                        SUBK_WGT       AS SubkWgt,
                        SUBK_RWGT      AS SubkRwgt,
                        SUBK_LOTNO     AS SubkLotno,
                        SUBK_REMARK    AS SubkRemark,
                        SUBK_BOXNO     AS SubkBoxno,
                        SUBK_PLTNO     AS SubkPltno,
                        SUBK_INDATE    AS SubkIndate,
                        SUBK_INTIME    AS SubkIntime,
                        MAST_NAME      AS MastName,
                        GUBN1_NAME     AS Gubn1Name,
                        GUBN2_NAME     AS Gubn2Name,
                        GUBN3_NAME     AS Gubn3Name
                     FROM T1MISUBK WITH (NOLOCK)
                     LEFT OUTER JOIN MIMAST WITH (NOLOCK)
                         ON MAST_CODE = SUBK_CODE
                     LEFT OUTER JOIN MIGUBN1 WITH (NOLOCK)
                         ON GUBN1_CODE = MAST_GUBN1
                     LEFT OUTER JOIN MIGUBN2 WITH (NOLOCK)
                         ON GUBN2_CODE = MAST_GUBN2
                     LEFT OUTER JOIN MIGUBN3 WITH (NOLOCK)
                         ON GUBN3_CODE = MAST_GUBN3
                     WHERE SUBK_LOCA = @_subkLoca
                     ORDER BY SUBK_LOCA, SUBK_CODE";

        return await conn.QueryAsync<Frm6900Dto.SubkDto>(sql, new
        {
            _subkLoca = lstkLoca ?? string.Empty
        });
    }

    public async Task<bool> TrakingAsync(string sPltno)
    {
        try
        {

            if (!coreRepo.Lstk_check(sPltno ?? string.Empty).Result)
            {
                return false;
            }
        }
        catch (Exception ex)
        {
            return false;
        }

        return true;
    }

    public async Task<bool> LstkCheckAsync(string sPltno)
    {
        try
        {
            if (!coreRepo.Lstk_check(sPltno ?? string.Empty).Result)
            {
                return false;
            }
        }
        catch (Exception ex)
        {
            return false;
        }

        return true;
    }

    public async Task<bool> SubkLocaCheck(string sPltno)
    {
        try
        {
            if (!coreRepo.Subk_loca_check(sPltno ?? string.Empty).Result)
            {
                return false;
            }
        }
        catch (Exception ex)
        {
            return false;
        }
        return true;
    }
}
