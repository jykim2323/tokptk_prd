using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class SFrm6110Repository(DbConnectionFactory db) : ISFrm6110Repository
{
    public async Task<bool> ConfirmedAsync(SFrm6110Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
                    UPDATE T2MILSTK
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
}
