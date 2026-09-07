using Dapper;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Globalization;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inbounds;

public class Frm3300Repository(DbConnectionFactory db) : IFrm3300Repository
{
    public async Task<IEnumerable<Frm3300Dto.ResDto>?> SearchAsync()
    {
        using var conn = db.Create();

        var sql = @"
            SELECT
                INPT_INDATE   AS InptIndate,
                INPT_INDEX    AS InptIndex,
                INPT_CODE     AS InptCode,
                MAST_NAME     AS MastName,
                INPT_LOTNO    AS InptLotno,
                INPT_WEIGHT   AS InptWeight,
                INPT_REMARK   AS InptRemark,
                INPT_HOGI     AS InptHogi,
                INPT_LOCA     AS InptLoca,
                INPT_BOXNO    AS InptBoxno,
                INPT_STIME    AS InptStime,
                INPT_ETIME    AS InptEtime,
                INPT_JOB_FLAG AS InptJobFlag,
                INPT_ID       AS InptId,
                INPT_LABEL    AS InptLabel,
                INPT_PLTNO    AS InptPltno
            FROM T1MIINPT WITH (NOLOCK)

            LEFT OUTER JOIN MIMAST WITH (NOLOCK)
                ON MAST_CODE = INPT_CODE

            WHERE INPT_JOB_FLAG = '0'

            ORDER BY
                INPT_INDEX,
                INPT_CODE
        ";

        return await conn.QueryAsync<Frm3300Dto.ResDto>(sql);
    }
    // =========================================================
    // 미입고 이력 삭제
    // T2MIINPT 삭제 + T2MILSTK 입고예약 해제
    // =========================================================
    public async Task<bool> DeleteAsync(Frm3300Dto.DeleteReqDto reqDto)
    {
        using var conn = db.Create();

        conn.Open();

        using var transaction = conn.BeginTransaction();

        try
        {
            var deleteSql = @"
                DELETE FROM T1MIINPT
                WHERE INPT_CODE  = @InptCode
                  AND INPT_LOTNO = @InptLotno
                  AND INPT_INDEX = @InptIndex
            ";

            var deleted = await conn.ExecuteAsync(
                deleteSql,
                new
                {
                    InptCode = reqDto.InptCode ?? string.Empty,
                    InptLotno = reqDto.InptLotno ?? string.Empty,
                    InptIndex = reqDto.InptIndex ?? string.Empty
                },
                transaction);


            var updateSql = @"
                UPDATE T1MILSTK

                SET
                    LSTK_FLAG = '0',
                    LSTK_PLTNO = ''

                WHERE LSTK_FLAG = 'X'
                  AND LSTK_LOCA = @InptLoca
            ";

            await conn.ExecuteAsync(
                updateSql,
                new
                {
                    InptLoca = reqDto.InptLoca ?? string.Empty
                },
                transaction);

            transaction.Commit();

            return deleted > 0;
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    // =========================================================
    // 라벨 발행 상태 N
    // Delphi Inlet_Label_print
    // =========================================================
    public async Task<bool> LabelPrintAsync(Frm3300Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
            UPDATE T1MIINPT

            SET INPT_LABEL = 'N'

            WHERE INPT_CODE  = @InptCode
              AND INPT_LOTNO = @InptLotno
              AND INPT_INDEX = @InptIndex
        ";

        return await conn.ExecuteAsync(
            sql,
            new
            {
                InptCode = reqDto.InptCode ?? string.Empty,
                InptLotno = reqDto.InptLotno ?? string.Empty,
                InptIndex = reqDto.InptIndex ?? string.Empty
            }) > 0;
    }

    // =========================================================
    // 라벨 발행 완료 Y
    // Delphi Inlet_Label_print1
    // =========================================================
    public async Task<bool> LabelPrintCompleteAsync(Frm3300Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
            UPDATE T1MIINPT

            SET INPT_LABEL = 'Y'

            WHERE INPT_CODE  = @InptCode
              AND INPT_LOTNO = @InptLotno
              AND INPT_INDEX = @InptIndex
        ";

        return await conn.ExecuteAsync(
            sql,
            new
            {
                InptCode = reqDto.InptCode ?? string.Empty,
                InptLotno = reqDto.InptLotno ?? string.Empty,
                InptIndex = reqDto.InptIndex ?? string.Empty
            }) > 0;
    }

}
