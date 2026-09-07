using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inventory;

public class SFrm6910Repository(DbConnectionFactory db) : ISFrm6910Repository
{
    public async Task<IEnumerable<SFrm6910Dto.ResDto>> SearchAsync(string pltNo)
    {
        using var conn = db.Create();

        var sql = @"
        SELECT
            A.SUBK_PLTNO  AS SubkPltno,
            A.SUBK_PLTNO  AS OriginalPltNo,
            A.SUBK_CODE   AS SubkCode,
            B.MAST_NAME   AS MastName,
            A.SUBK_LOTNO  AS SubkLotno,
            A.SUBK_WGT    AS SubkWgt,
            A.SUBK_BOXNO  AS SubkBoxno,
            A.SUBK_REMARK AS SubkRemark

        FROM T1MISUBK A WITH (NOLOCK)

        LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
            ON A.SUBK_CODE = B.MAST_CODE

        WHERE A.SUBK_PLTNO = @PltNo

        ORDER BY
            A.SUBK_CODE,
            A.SUBK_LOTNO
    ";

        return await conn.QueryAsync<SFrm6910Dto.ResDto>(
            sql,
            new
            {
                PltNo = pltNo
            });
    }

    public async Task<bool> SaveAsync(SFrm6910Dto.SaveReqDto reqDto)
    {
        using var conn = db.Create();

        conn.Open();

        using var transaction = conn.BeginTransaction();

        try
        {
            var checkSql = @"
            SELECT COUNT(*)
            FROM T1MISUBK WITH (UPDLOCK, HOLDLOCK)
            WHERE SUBK_PLTNO = @TargetPltNo
              AND SUBK_CODE  = @SubkCode
              AND SUBK_LOTNO = @SubkLotno
        ";

            var updateSql = @"
            UPDATE T1MISUBK

            SET SUBK_PLTNO = @TargetPltNo

            WHERE SUBK_PLTNO = @OriginalPltNo
              AND SUBK_CODE  = @SubkCode
              AND SUBK_LOTNO = @SubkLotno
        ";

            foreach (var item in reqDto.Items)
            {
                // 원래 PLT와 현재 PLT가 같으면 변경 없음
                if (item.OriginalPltNo == item.TargetPltNo)
                    continue;

                // 목적지에 같은 품목 + LOT가 이미 있는지 검사
                var dupCount = await conn.QuerySingleAsync<int>(
                    checkSql,
                    new
                    {
                        item.TargetPltNo,
                        item.SubkCode,
                        item.SubkLotno
                    },
                    transaction);

                if (dupCount > 0)
                {
                    throw new InvalidOperationException(
                        $"파렛트 [{item.TargetPltNo}]에 " +
                        $"품목 [{item.SubkCode}] / LOT [{item.SubkLotno}]가 이미 존재합니다.");
                }

                var affected = await conn.ExecuteAsync(
                    updateSql,
                    new
                    {
                        item.TargetPltNo,
                        item.OriginalPltNo,
                        item.SubkCode,
                        item.SubkLotno
                    },
                    transaction);

                if (affected == 0)
                {
                    throw new InvalidOperationException(
                        $"이동할 재고를 찾을 수 없습니다. " +
                        $"품목:{item.SubkCode}, LOT:{item.SubkLotno}");
                }
            }

            transaction.Commit();

            return true;
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }
}
