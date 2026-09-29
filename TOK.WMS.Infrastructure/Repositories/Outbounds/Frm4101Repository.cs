using Dapper;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Core.Interfaces.Outbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public class Frm4101Repository(
    DbConnectionFactory db) : IFrm4101Repository
{
    public async Task<Frm4101Dto.SaveResultDto> SaveAsync(
        Frm4101Dto.SaveReqDto reqDto)
    {
        using var conn = db.Create();

        conn.Open();

        using var transaction =
            conn.BeginTransaction();

        try
        {
            // =====================================================
            // 1. 기존 출고지시 전체 삭제
            // Delphi DELETE FROM T2HHOUPT
            // =====================================================

            const string deleteSql = @"
                DELETE FROM T2HHOUPT
            ";

            await conn.ExecuteAsync(
                deleteSql,
                transaction: transaction);


            // =====================================================
            // 2. DB 날짜/시간
            // =====================================================

            const string dateSql = @"
                SELECT
                    CONVERT(VARCHAR(8), GETDATE(), 112) AS WorkDate,
                    REPLACE(
                        CONVERT(VARCHAR(8), GETDATE(), 108),
                        ':',
                        ''
                    ) AS WorkTime
            ";

            var now =
                await conn.QueryFirstAsync(
                    dateSql,
                    transaction: transaction);


            string workDate =
                now.WorkDate;

            string workTime =
                now.WorkTime;


            // =====================================================
            // 3. 차수 조회
            //
            // Delphi STAT_PSWD = 'JPLS'
            //
            // 동시 실행 방지를 위해 UPDLOCK
            // =====================================================

            const string statSql = @"
                SELECT
                    STAT_CDATE AS StatCdate,
                    STAT_CINDX AS StatCindx

                FROM T2TBSTAT WITH (UPDLOCK, HOLDLOCK)

                WHERE STAT_PSWD = 'JPLS'
            ";

            var stat =
                await conn.QueryFirstOrDefaultAsync(
                    statSql,
                    transaction: transaction);


            if (stat == null)
            {
                throw new Exception(
                    "T2TBSTAT의 JPLS 설정을 찾을 수 없습니다.");
            }


            string statDate =
                stat.StatCdate?.ToString()
                ?? string.Empty;

            int statIndex =
                Convert.ToInt32(stat.StatCindx);


            string chasu;


            // =====================================================
            // 같은 날짜
            // =====================================================

            if (workDate == statDate)
            {
                chasu =
                    statIndex.ToString("000");


                if (statIndex >= 998)
                {
                    const string updateStatSql = @"
                        UPDATE T2TBSTAT

                        SET STAT_CINDX = 1

                        WHERE STAT_PSWD = 'JPLS'
                    ";

                    await conn.ExecuteAsync(
                        updateStatSql,
                        transaction: transaction);
                }
                else
                {
                    const string updateStatSql = @"
                        UPDATE T2TBSTAT

                        SET STAT_CINDX =
                            STAT_CINDX + 1

                        WHERE STAT_PSWD = 'JPLS'
                    ";

                    await conn.ExecuteAsync(
                        updateStatSql,
                        transaction: transaction);
                }
            }

            // =====================================================
            // 날짜 변경
            // =====================================================

            else
            {
                chasu = "001";

                const string updateStatSql = @"
                    UPDATE T2TBSTAT

                    SET
                        STAT_CDATE = @WorkDate,
                        STAT_CINDX = 2

                    WHERE STAT_PSWD = 'JPLS'
                ";

                await conn.ExecuteAsync(
                    updateStatSql,
                    new
                    {
                        WorkDate = workDate
                    },
                    transaction);
            }


            // =====================================================
            // 4. 출고지시 등록
            // =====================================================

            var count = 0;


            foreach (var item in reqDto.Items)
            {
                if (string.IsNullOrWhiteSpace(
                    item.ItemCode))
                {
                    continue;
                }


                const string checkSql = @"
                    SELECT COUNT(*)

                    FROM T2HHOUPT WITH (NOLOCK)

                    WHERE HO_DATE = @WorkDate
                      AND HO_CODE = @ItemCode
                      AND ISNULL(HO_LOTNO, '') = @LotNo
                      AND ISNULL(HO_CUST, '') = @Customer
                ";


                var exists =
                    await conn.ExecuteScalarAsync<int>(
                        checkSql,
                        new
                        {
                            WorkDate =
                                workDate,

                            ItemCode =
                                item.ItemCode,

                            LotNo =
                                item.LotNo
                                ?? string.Empty,

                            Customer =
                                item.Customer
                                ?? string.Empty
                        },
                        transaction);


                // =============================================
                // 신규 INSERT
                // =============================================

                if (exists == 0)
                {
                    const string insertSql = @"
                        INSERT INTO T2HHOUPT
                        (
                            HO_DATE,
                            HO_CHASU,

                            HO_CODE,
                            HO_LOTNO,
                            HO_CUST,

                            HO_QTY,

                            HO_BOXNO,
                            HO_REMARK,

                            HO_TIME
                        )
                        VALUES
                        (
                            @WorkDate,
                            @Chasu,

                            @ItemCode,
                            @LotNo,
                            @Customer,

                            @Qty,

                            @BoxNo,
                            @Remark,

                            @WorkTime
                        )
                    ";


                    await conn.ExecuteAsync(
                        insertSql,
                        new
                        {
                            WorkDate =
                                workDate,

                            Chasu =
                                chasu,

                            ItemCode =
                                item.ItemCode,

                            LotNo =
                                item.LotNo
                                ?? string.Empty,

                            Customer =
                                item.Customer
                                ?? string.Empty,

                            item.Qty,

                            BoxNo =
                                item.BoxNo
                                ?? string.Empty,

                            Remark =
                                item.Remark
                                ?? string.Empty,

                            WorkTime =
                                workTime
                        },
                        transaction);
                }

                // =============================================
                // 동일 CODE + LOT + 납품처
                // → 수량 누적
                // =============================================

                else
                {
                    const string updateSql = @"
                        UPDATE T2HHOUPT

                        SET HO_QTY =
                            ISNULL(HO_QTY, 0) + @Qty

                        WHERE HO_DATE = @WorkDate
                          AND HO_CODE = @ItemCode
                          AND ISNULL(HO_LOTNO, '') = @LotNo
                          AND ISNULL(HO_CUST, '') = @Customer
                    ";


                    await conn.ExecuteAsync(
                        updateSql,
                        new
                        {
                            WorkDate =
                                workDate,

                            ItemCode =
                                item.ItemCode,

                            LotNo =
                                item.LotNo
                                ?? string.Empty,

                            Customer =
                                item.Customer
                                ?? string.Empty,

                            item.Qty
                        },
                        transaction);
                }


                count++;
            }


            transaction.Commit();


            return new Frm4101Dto.SaveResultDto
            {
                Chasu = chasu,

                Count = count
            };
        }
        catch
        {
            transaction.Rollback();

            throw;
        }
    }
}