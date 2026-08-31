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

public class LocaAddRepository(DbConnectionFactory db, ICoreRepository coreRepo) : ILocaAddRepository
{
    public async Task<bool> SubkCheckAsync(LocaAddDto.ReqDto reqdto)
    {
        if (!coreRepo.Subk_dup_check(reqdto.SubkPltno ?? string.Empty, reqdto.SubkCode ?? string.Empty, reqdto.SubkLotno ?? string.Empty).Result)
        {
            return false;
        }
        return true;
    }

    public async Task<bool> ConfirmedAsync(LocaAddDto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @" INSERT INTO T1MISUBK
                     (SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_PLTNO, 
                      SUBK_WGT, SUBK_RWGT, SUBK_FLAG, SUBK_GUBUN,
                      SUBK_REMARK, SUBK_BOXNO, SUBK_INDATE, SUBK_INTIME, SUBK_USERID)
                    VALUES
                    (   @StrLoca, @Code, @LotNo, @PltNo,
                        @Qty, @RQty, '1', '',
                        @Remark, @BoxNo, @InDate, @InTime, @UserId
                    )";

        var affectedRows = await conn.ExecuteAsync(
            sql,
            new
            {   StrLoca = reqDto.SubkLoca,
                Code = reqDto.SubkCode,
                LotNo = reqDto.SubkLotno,
                PltNo = reqDto.SubkPltno,
                Qty = reqDto.SubkWgt,
                RQty = reqDto.SubkRwgt,
                Remark = reqDto.SubkRemark,
                BoxNo = reqDto.SubkBoxno,
                InDate = reqDto.SubkIndate,
                InTime = reqDto.SubkIntime,
                UserId = reqDto.UserId
            });

        return affectedRows > 0;
    }
}
