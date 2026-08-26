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

public class Frm6100Repository(DbConnectionFactory db) : IFrm6100Repository
{
    public async Task<IEnumerable<Frm6100Dto.ResDto>?> SearchAsync(Frm6100Dto reqDto)
    {
        using var conn = db.Create();

        //var tableName = warehouseContext.SelectedWarehouse switch
        //{
        //    WarehouseType.Raw => "T1MILSTK",
        //    WarehouseType.Product => "T1MILSTK",
        //    _ => throw new InvalidOperationException()
        //};

        var sql = $@"SELECT
                        LSTK_LOCA AS LstkLoca,
                        LSTK_FLAG AS LstkFlag,
                        LSTK_INDATE AS LstkIndate,
                        LSTK_INTIME AS LstkIntime,
                        LSTK_PLTNO AS LstkPltno
                    FROM T1MILSTK WITH (NOLOCK)
                    WHERE LSTK_LOCA >= @_lstkLoca";

        return await conn.QueryAsync<Frm6100Dto.ResDto>(sql, new
        {
            _lstkLoca = reqDto.LstkLoca ?? string.Empty
        });
    }

    public async Task<IEnumerable<Frm6100Dto.SubkDto>?> SubkSearchAsync(string lstkLoca)
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

        return await conn.QueryAsync<Frm6100Dto.SubkDto>(sql, new
        {
            _subkLoca = lstkLoca ?? string.Empty
        });
    }

    public async Task<bool> SubkCheckAsync(string lstkLoca)
    {
        using var conn = db.Create();
        var sql = @"SELECT COUNT(*)
                    FROM T1MISUBK WITH (NOLOCK)
                    WHERE SUBK_LOCA = @lstkLoca";
        var count = await conn.QuerySingleAsync<int>(sql, new
        {
            lstkLoca = lstkLoca ?? string.Empty
        });
        return count > 0;
    }

    public async Task<int> DeleteAsync(string subkLoca)
    {
        using var conn = db.Create();

        var sql = @"DELETE FROM T1MISUBK WHERE SUBK_LOCA = @subkLoca";

        return await conn.ExecuteAsync(sql, new
        {
            subkLoca = subkLoca ?? string.Empty
        });
    }
    public async Task<int> LstkClearAsync(string lstkLoca)
    {
        using var conn = db.Create();

        var sql = @"Update  T2MILSTK Set 
                            LSTK_FLAG = '0', 
                            LSTK_INDATE = '', 
                            LSTK_INTIME = '',
                            LSTK_PLTNO = ''
                            WHERE LSTK_LOCA = @lstkLoca";

        return await conn.ExecuteAsync(sql, new
        {
            lstkLoca = lstkLoca ?? string.Empty
        });
    }
}
