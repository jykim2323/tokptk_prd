using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class Frm6100Repository(DbConnectionFactory db) : IFrm6100Repository
{
    public async Task<IEnumerable<Frm6100Dto.ResDto>?> SearchAsync(Frm6100Dto reqDto)
    {
        using var conn = db.Create();

        var sql = @"SELECT
                        LSTK_LOCA AS LstkLoca,
                        LSTK_FLAG AS LstkFlag,
                        LSTK_INDATE AS LstkIndate,
                        LSTK_INTIME AS LstkIntime,
                        LSTK_PLTNO AS LstkPltno
                    FROM T2MILSTK WITH (NOLOCK)
                    WHERE 1 = 1";

        if (!string.IsNullOrWhiteSpace(reqDto.LstkLoca))
        {
            sql = sql + @"AND LSTK_LOCA >= @_lstkLoca";
        }

        return await conn.QueryAsync<Frm6100Dto.ResDto>(sql, new
        {
            _lstkLoca = reqDto.LstkLoca ?? string.Empty
        });
    }
}
