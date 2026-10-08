using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories;

public class CoreRepository(DbConnectionFactory db) : ICoreRepository
{

    public async Task<bool> Trak_check(string sPltno)
    {
        using var conn = db.Create();

        const string trak_sql = PalletTrackingSql.CountByPallet;

        var trak_cnt = await conn.QuerySingleAsync<int>(trak_sql, new
        {
            PltNo = sPltno ?? string.Empty
        });

        if (trak_cnt > 0)
        {
            return false;
        }

        return true;
    }

    public async Task<bool> Lstk_check(string sPltno)
    {
        using var conn = db.Create();

        var lstk_sql = @"SELECT COUNT(*)
                    FROM T2MILSTK WITH (NOLOCK)
                    WHERE LSTK_PLTNO = @sPltno";

        var lstk_cnt = await conn.QuerySingleAsync<int>(lstk_sql, new
        {
            sPltno = sPltno ?? string.Empty
        });

        if (lstk_cnt > 0)
        {
            return false;
        }

        return true;
    }

    public async Task<bool> Subk_check(string sPltno)
    {
        using var conn = db.Create();

        var lstk_sql = @"SELECT COUNT(*)
                    FROM T2MISUBK WITH (NOLOCK)
                    WHERE SUBK_PLTNO = @sPltno";

        var lstk_cnt = await conn.QuerySingleAsync<int>(lstk_sql, new
        {
            sPltno = sPltno ?? string.Empty
        });

        if (lstk_cnt > 0)
        {
            return false;
        }

        return true;
    }

    public async Task<string?> Lstk_pltno_check(string lstkloca)
    {
        using var conn = db.Create();

        var q = @"SELECT LSTK_PLTNO
                         FROM T2MILSTK WITH (NOLOCK)
                         WHERE LSTK_LOCA = @lstkloca";

        var result = await conn.QuerySingleOrDefaultAsync<string?>(q, new
        {
            lstkloca = lstkloca ?? string.Empty
        });

        if (result != null)
        {
            return result;
        }

        return null;
    }

    public async Task<bool> Subk_loca_check(string lstkpltno)
    {
        using var conn = db.Create();

        var q = @"SELECT SUBK_LOCA
                         FROM T2MISUBK WITH (NOLOCK)
                         WHERE SUBK_PLTNO = @subkloca";

        var result = await conn.QueryFirstOrDefaultAsync<string?>(q, new
        {
            subkloca = lstkpltno ?? string.Empty
        });

        if (string.IsNullOrEmpty(result))
        {
            return false;
        }

        return true;
    }

    public async Task<string?> SubklocacheckAsync(string subkpltno)
    {
        using var conn = db.Create();

        var sql = @"
                    SELECT A.SUBK_LOCA   AS SubkLoca
                    FROM   T2MISUBK A WITH (NOLOCK)
                    WHERE  A.SUBK_PLTNO = @_subkPltno";


        var result = await conn.QueryFirstOrDefaultAsync<string?>(sql, new
        {
            _subkPltno = subkpltno ?? string.Empty
        });

        if (result is null)
        {
            result = "0";
        }

        return result;
    }

    public async Task<bool> Subk_dup_check(string sPltno, string subkCode, string subkLotno)
    {
        using var conn = db.Create();

        var lstk_sql = @"SELECT COUNT(*)
                    FROM T2MISUBK WITH (NOLOCK)
                    WHERE SUBK_PLTNO = @sPltno
                    AND   SUBK_CODE  = @subkCode
                    AND   SUBK_LOTNO = @subkLotno";

        var lstk_cnt = await conn.QuerySingleAsync<int>(lstk_sql, new
        {
            sPltno = sPltno ?? string.Empty,
            subkCode = subkCode ?? string.Empty,
            subkLotno = subkLotno ?? string.Empty
        });

        if (lstk_cnt > 0)
        {
            return false;
        }

        return true;
    }

}
