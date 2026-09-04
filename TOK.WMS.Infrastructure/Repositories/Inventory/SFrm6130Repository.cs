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

public class SFrm6130Repository(DbConnectionFactory db, ICoreRepository coreRepo) : ISFrm6130Repository
{
    public async Task<bool> SubkCheckAsync(SFrm6130Dto.ReqDto reqdto)
    {
        if (!await coreRepo.Subk_dup_check(reqdto.SubkPltno ?? string.Empty, reqdto.SubkCode ?? string.Empty, reqdto.SubkLotno ?? string.Empty))
        {
            return false;
        }
        return true;
    }

    public async Task<bool> ConfirmedAsync(SFrm6130Dto.ReqDto reqDto)
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

    public async Task<int> SubkInsert(SFrm6130Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
        INSERT INTO T1MISUBK
        (
            SUBK_CODE,
            SUBK_LOCA,
            SUBK_FLAG,
            SUBK_REMARK,
            SUBK_WGT,
            SUBK_RWGT,
            SUBK_LOTNO,
            SUBK_GUBUN,
            SUBK_INDATE,
            SUBK_INTIME,
            SUBK_BOXNO,
            SUBK_PLTNO
        )
        VALUES
        (
            @SubkCode,
            @SubkLoca,
            @SubkFlag,
            @SubkRemark,
            @SubkWgt,
            @SubkRwgt,
            @SubkLotno,
            'Y',
            @SubkIndate,
            @SubkIntime,
            @SubkBoxno,
            @SubkPltno
        );
    ";

        var resultCnt = await conn.ExecuteAsync(sql, new
        {
            SubkCode = reqDto.SubkCode ?? string.Empty,
            SubkLoca = reqDto.SubkLoca ?? string.Empty,
            SubkFlag = reqDto.SubkFlag ?? string.Empty,
            SubkRemark = reqDto.SubkRemark ?? string.Empty,

            SubkWgt = decimal.TryParse(reqDto.SubkWgt, out var wgt) ? wgt : 0m,
            SubkRwgt = decimal.TryParse(reqDto.SubkRwgt, out var rwgt) ? rwgt : 0m,

            SubkLotno = reqDto.SubkLotno ?? string.Empty,
            SubkIndate = reqDto.SubkIndate ?? string.Empty,
            SubkIntime = reqDto.SubkIntime ?? string.Empty,
            SubkBoxno = reqDto.SubkBoxno ?? string.Empty,
            SubkPltno = reqDto.SubkPltno ?? string.Empty
        });

        return resultCnt;
    }

    public async Task<bool> SubkUpdateAsync(SFrm6130Dto.ReqDto reqDto)
    {

        using var conn = db.Create();

        var sql = @"
                    UPDATE T1MISUBK
                    SET
                        SUBK_FLAG   = @SubkFlag,
                        SUBK_RWGT   = @SubkRwgt,
                        SUBK_WGT   = @SubkWgt,
                        SUBK_REMARK = @SubkRemark,
                        SUBK_INDATE = @SubkIndate,
                        SUBK_BOXNO = @SubkBoxno
                    WHERE SUBK_LOCA = @SubkLoca
                      AND SUBK_CODE = @SubkCode
                      AND SUBK_LOTNO = @SubkLotno";

        var affectedRows = await conn.ExecuteAsync(
            sql,
            new
            {
                SubkFlag = reqDto.SubkFlag,

                SubkWgt = decimal.TryParse(reqDto.SubkWgt, out var wgt) ? wgt : 0m,
                SubkRwgt = decimal.TryParse(reqDto.SubkRwgt, out var rwgt) ? rwgt : 0m,
                
                SubkRemark = reqDto.SubkRemark,
                SubkIndate = reqDto.SubkIndate,
                SubkBoxno = reqDto.SubkBoxno,
                SubkLoca = reqDto.SubkLoca,
                SubkCode = reqDto.SubkCode,
                SubkLotno = reqDto.SubkLotno
            });

        return affectedRows > 0;
    }
}
