using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class SFrm6120Repository(DbConnectionFactory db, ICoreRepository coreRepository) : ISFrm6120Repository
{
    public async Task<IEnumerable<SFrm6120Dto.ReqDto>?> LstkpltnocheckAsync(SFrm6120Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
                    SELECT
                        A.SUBK_LOCA   AS SubkLoca,
                        A.SUBK_PLTNO  AS SubkPltno,
                        A.SUBK_CODE   AS SubkCode,
                        B.MAST_NAME   AS MastName,
                        A.SUBK_LOTNO  AS SubkLotno,
                        A.SUBK_WGT    AS SubkWgt,
                        A.SUBK_RWGT   AS SubkRwgt,
                        A.SUBK_REMARK AS SubkRemark,
                        A.SUBK_INDATE AS SubkIndate,
                        A.SUBK_INTIME AS SubkIntime
                    FROM T1MISUBK A WITH (NOLOCK)
                    LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                        ON A.SUBK_CODE = B.MAST_CODE
                    WHERE A.SUBK_PLTNO = @_subkPltno
                    ORDER BY A.SUBK_LOCA, A.SUBK_CODE";

        return await conn.QueryAsync<SFrm6120Dto.ReqDto>(sql, new
        {
            _subkPltno = reqDto.SubkPltno ?? string.Empty
        });

    }
    public async Task<bool> ConfirmedAsync(SFrm6120Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
                    UPDATE T1MILSTK
                    SET
                        LSTK_FLAG   = @_strFlag,
                        LSTK_INDATE = @_strInDate,
                        LSTK_INTIME = @_strInTime
                    WHERE LSTK_LOCA = @_strLoca";

        var affectedRows = await conn.ExecuteAsync(
            sql,
            new
            {
                _strFlag = reqDto.SubkFlag,
                _strInDate = reqDto.SubkIndate,
                _strInTime = reqDto.SubkIntime,
                _strLoca = reqDto.SubkLoca
            });

        return affectedRows > 0;
    }

    public async Task<string?> SubklocacheckAsync(string subkpltno)
    {
        var result = await coreRepository.SubklocacheckAsync(subkpltno ?? string.Empty);

        if (result is null)
        {
            result = "0";
        }

        return result;
    }

    public async Task<bool> LstkcheckAsync(string subkpltno)
    {
        var result = await coreRepository.Lstk_check(subkpltno ?? string.Empty);

        return result;
    }

    public async Task<IEnumerable<SFrm6120Dto.ReqDto>?> SubkSearchAsync(string subkpltno)
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
                        MAST_GUBN1     AS Gubn1Name,
                        MAST_GUBN2     AS Gubn2Name,
                        MAST_GUBN3     AS Gubn3Name
                     FROM T1MISUBK A WITH (NOLOCK) 
                     LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                         ON B.MAST_CODE = A.SUBK_CODE
                     WHERE A.SUBK_PLTNO = @_subkPltno
                     ORDER BY A.SUBK_LOCA, A.SUBK_CODE";

        return await conn.QueryAsync<SFrm6120Dto.ReqDto>(sql, new
        {
            _subkPltno = subkpltno ?? string.Empty
        });
    }
    public async Task<bool> MilstkUpdateAsync(SFrm6120Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = $@"
                    UPDATE T1MILSTK
                    SET
                        LSTK_FLAG   = @StrFlag,
                        LSTK_INDATE = @StrDate,
                        LSTK_INTIME = @StrTime,
                        LSTK_PLTNO  = @PltNo
                    WHERE LSTK_LOCA = @_subkLoca";


        var result = await conn.ExecuteAsync(sql, new
        {
            StrFlag = reqDto.SubkFlag,
            StrDate = reqDto.SubkIndate,
            StrTime = reqDto.SubkIntime,
            PltNo = reqDto.SubkPltno ?? string.Empty,
            _subkLoca = reqDto.SubkLoca,
        });

        return result > 0;
    }
    public async Task<bool> MisubkUpdateAsync(SFrm6120Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = $@"
                    UPDATE T1MISUBK
                    SET
                        SUBK_LOCA   = @StrLoca,
                        SUBK_FLAG   = @StrFlag,
                        SUBK_GUBUN = '',
                        SUBK_USERID  = @jj_id
                    WHERE SUBK_PLTNO = @_subkpltno";


        var result = await conn.ExecuteAsync(sql, new
        {
            StrLoca = reqDto.SubkLoca ?? string.Empty,
            StrFlag = reqDto.SubkFlag ?? string.Empty,
            jj_id = reqDto.UserId ?? string.Empty,
            _subkpltno = reqDto.SubkPltno ?? string.Empty,
        });

        return result > 0;
    }
}
  
