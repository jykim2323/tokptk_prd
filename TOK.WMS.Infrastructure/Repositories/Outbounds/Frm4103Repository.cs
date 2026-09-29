using Dapper;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Core.Interfaces.Outbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public class Frm4103Repository(
    DbConnectionFactory db)
    : IFrm4103Repository
{
    // =========================================================
    // 차수 조회
    // Delphi ChaSuComBo_Insert
    // =========================================================

    public async Task<IEnumerable<Frm4103Dto.ChasuDto>?> SearchChasuAsync(
        string outDate)
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                OUPT_CHASU AS Chasu

            FROM T2MIOUPT WITH (NOLOCK)

            WHERE OUPT_DATE = @OutDate
              AND ISNULL(OUPT_CHASU, '') <> ''

            GROUP BY
                OUPT_CHASU

            ORDER BY
                OUPT_CHASU
        ";


        return await conn.QueryAsync<
            Frm4103Dto.ChasuDto>(
            sql,
            new
            {
                OutDate =
                    outDate
            });
    }


    // =========================================================
    // 상단 피킹리스트 현황
    // =========================================================

    public async Task<IEnumerable<Frm4103Dto.SummaryDto>?> SearchSummaryAsync(
        Frm4103Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        var sql = @"
            SELECT
                OUPT_DATE AS OuptDate,

                OUPT_CHASU AS OuptChasu,

                COUNT(DISTINCT OUPT_CODE)
                    AS ProductCount,

                CASE
                    WHEN MAX(ISNULL(OUPT_JOB_FLAG, '0')) = '0'
                        THEN '대기'
                    ELSE '완료'
                END AS JobStatus

            FROM T2MIOUPT WITH (NOLOCK)

            WHERE OUPT_DATE = @OutDate
              AND ISNULL(OUPT_CHASU, '') <> ''
        ";


        var param =
            new DynamicParameters();


        param.Add(
            "OutDate",
            reqDto.OutDate);


        // Delphi 원본:
        // OUPT_CHASU >= 선택차수
        if (!string.IsNullOrWhiteSpace(
            reqDto.Chasu))
        {
            sql += @"
                AND OUPT_CHASU >= @Chasu
            ";


            param.Add(
                "Chasu",
                reqDto.Chasu);
        }


        sql += @"
            GROUP BY
                OUPT_DATE,
                OUPT_CHASU

            ORDER BY
                OUPT_CHASU
        ";


        return await conn.QueryAsync<
            Frm4103Dto.SummaryDto>(
            sql,
            param);
    }


    // =========================================================
    // 하단 출고 대기 현황
    // =========================================================

    public async Task<IEnumerable<Frm4103Dto.ScheduleDto>?> SearchSchedulesAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                SCHE_SC
                    AS ScheSc,

                SCHE_INDEX
                    AS ScheIndex,

                SCHE_JOBGUBUN
                    AS ScheJobGubun,

                SCHE_LOCA
                    AS ScheLoca,

                SCHE_WSNO
                    AS ScheWsno,

                SCHE_EMER
                    AS ScheEmer,

                SCHE_DATE
                    AS ScheDate,

                SCHE_TIME
                    AS ScheTime

            FROM T2TISCHE1 WITH (NOLOCK)

            ORDER BY
                SCHE_INDEX
        ";


        return await conn.QueryAsync<
            Frm4103Dto.ScheduleDto>(
            sql);
    }


    // =========================================================
    // 출고 대기 삭제
    //
    // Delphi DeleteBitBtnClick
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm4103Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        conn.Open();


        using var transaction =
            conn.BeginTransaction();


        try
        {
            var index =
                reqDto.ScheIndex?
                    .Trim()
                ?? string.Empty;


            var loca =
                reqDto.ScheLoca?
                    .Trim()
                ?? string.Empty;


            if (string.IsNullOrWhiteSpace(
                index))
            {
                transaction.Rollback();

                return 0;
            }


            // =================================================
            // 1. 출고이력 삭제
            // T2MIOUPT → T2MIOUPT
            // =================================================

            var result =
                await conn.ExecuteAsync(
                    @"
                        DELETE FROM T2MIOUPT

                        WHERE OUPT_INDEX = @Index
                    ",
                    new
                    {
                        Index =
                            index
                    },
                    transaction);


            // =================================================
            // 2. SUBK 예약 원복
            //
            // SUBK_RWGT = 0
            // SUBK_FLAG = 1
            // =================================================

            await conn.ExecuteAsync(
                @"
                    UPDATE T2MISUBK

                    SET
                        SUBK_RWGT = 0.00,
                        SUBK_FLAG = '1'

                    WHERE SUBK_FLAG = 'Y'
                      AND SUBK_LOCA = @Loca
                ",
                new
                {
                    Loca =
                        loca
                },
                transaction);


            // =================================================
            // 3. LSTK 원복
            // =================================================

            await conn.ExecuteAsync(
                @"
                    UPDATE T2MILSTK

                    SET
                        LSTK_FLAG = '1'

                    WHERE LSTK_FLAG = 'Y'
                      AND LSTK_LOCA = @Loca
                ",
                new
                {
                    Loca =
                        loca
                },
                transaction);


            // =================================================
            // 4. 임시 작업지시 삭제
            // =================================================

            await conn.ExecuteAsync(
                @"
                    DELETE FROM T2TISCHE1

                    WHERE SCHE_INDEX = @Index
                ",
                new
                {
                    Index =
                        index
                },
                transaction);


            transaction.Commit();


            return result;
        }
        catch
        {
            transaction.Rollback();

            throw;
        }
    }


    // =========================================================
    // 출고 지시 확정
    //
    // T2TISCHE1
    //      ↓
    // T2TISCHE
    // =========================================================

    public async Task<Frm4103Dto.ConfirmResultDto> ConfirmAsync(
        Frm4103Dto.ConfirmReqDto reqDto)
    {
        using var conn =
            db.Create();


        conn.Open();


        using var transaction =
            conn.BeginTransaction();


        try
        {
            // =================================================
            // 출고대기 데이터 존재 확인
            // =================================================

            const string countSql = @"
                SELECT COUNT(*)

                FROM T2TISCHE1 WITH (
                    UPDLOCK,
                    HOLDLOCK
                )
            ";


            var count =
                await conn.ExecuteScalarAsync<int>(
                    countSql,
                    transaction:
                        transaction);


            if (count <= 0)
            {
                transaction.Rollback();


                return new Frm4103Dto.ConfirmResultDto
                {
                    Success =
                        false,

                    Count =
                        0,

                    Message =
                        "출고 지시할 데이터가 없습니다."
                };
            }


            // =================================================
            // 임시 작업지시 → 실제 작업지시
            // =================================================

            const string insertSql = @"
                INSERT INTO T2TISCHE
                (
                    SCHE_SC,
                    SCHE_INDEX,
                    SCHE_JOBGUBUN,
                    SCHE_LOCA,
                    SCHE_WSNO,
                    SCHE_DATE,
                    SCHE_TIME,
                    SCHE_EMER,
                    SCHE_PLTNO
                )

                SELECT
                    SCHE_SC,
                    SCHE_INDEX,
                    SCHE_JOBGUBUN,
                    SCHE_LOCA,
                    SCHE_WSNO,
                    SCHE_DATE,
                    SCHE_TIME,
                    SCHE_EMER,
                    SCHE_PLTNO

                FROM T2TISCHE1
            ";


            await conn.ExecuteAsync(
                insertSql,
                transaction:
                    transaction);


            // =================================================
            // 임시 작업지시 삭제
            // =================================================

            await conn.ExecuteAsync(
                @"
                    DELETE FROM T2TISCHE1
                ",
                transaction:
                    transaction);


            transaction.Commit();


            return new Frm4103Dto.ConfirmResultDto
            {
                Success =
                    true,

                Count =
                    count,

                Message =
                    $"출고지시 {count:N0}건을 확정했습니다."
            };
        }
        catch (Exception ex)
        {
            transaction.Rollback();


            return new Frm4103Dto.ConfirmResultDto
            {
                Success =
                    false,

                Count =
                    0,

                Message =
                    $"동일한 출고지시가 있거나 처리 중 오류가 발생했습니다.\n{ex.Message}"
            };
        }
    }
}