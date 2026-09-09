using Dapper;
using System.Data;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public class Frm4300Repository(
    DbConnectionFactory db)
    : IFrm4300Repository
{
    // =========================================================
    // 조회
    // =========================================================

    public async Task<IEnumerable<Frm4300Dto.ResDto>?> SearchAsync(
        Frm4300Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        var sql = @"
            SELECT
                A.OUPT_DATE        AS OuptDate,
                A.OUPT_INDEX       AS OuptIndex,
                A.OUPT_CODE        AS OuptCode,
                B.MAST_NAME        AS MastName,
                A.OUPT_LOTNO       AS OuptLotno,
                A.OUPT_SEQNO       AS OuptSeqno,
                A.OUPT_GUBUN       AS OuptGubun,

                ISNULL(
                    A.OUPT_WGT,
                    0
                )                  AS OuptWgt,

                ISNULL(
                    A.OUPT_OUT_WGT,
                    0
                )                  AS OuptOutWgt,

                A.OUPT_LOCA        AS OuptLoca,
                A.OUPT_BOXNO1      AS OuptBoxno1,
                A.OUPT_REMARK1     AS OuptRemark1,
                A.OUPT_TIME        AS OuptTime,
                A.OUPT_JOB_FLAG    AS OuptJobFlag,
                A.OUPT_REMARK      AS OuptRemark,
                A.OUPT_ID          AS OuptId,
                A.OUPT_BOXNO       AS OuptBoxno,
                A.OUPT_CHASU       AS OuptChasu,
                A.OUPT_CUST        AS OuptCust,
                A.OUPT_PLTNO       AS OuptPltno

            FROM T1MIOUPT A WITH (NOLOCK)

            LEFT JOIN MIMAST B WITH (NOLOCK)
                ON B.MAST_CODE =
                   A.OUPT_CODE

            WHERE ISNULL(
                      A.OUPT_CODE,
                      ''
                  ) <> ''

              AND A.OUPT_JOB_FLAG = '0'
        ";


        var param =
            new DynamicParameters();


        var searchType =
            reqDto.SearchType?
                .Trim()
                .ToUpperInvariant()
            ?? "ALL";


        var searchText =
            reqDto.SearchText?
                .Trim()
            ?? string.Empty;


        // =====================================================
        // 품목코드
        // =====================================================

        if (searchType == "CODE")
        {
            if (!string.IsNullOrWhiteSpace(
                searchText))
            {
                sql += @"
                    AND A.OUPT_CODE =
                        @SearchText
                ";

                param.Add(
                    "SearchText",
                    searchText);
            }


            sql += @"
                ORDER BY
                    A.OUPT_CODE,
                    A.OUPT_INDEX
            ";
        }

        // =====================================================
        // 품목명
        // =====================================================

        else if (searchType == "NAME")
        {
            if (!string.IsNullOrWhiteSpace(
                searchText))
            {
                sql += @"
                    AND B.MAST_NAME LIKE
                        '%' + @SearchText + '%'
                ";

                param.Add(
                    "SearchText",
                    searchText);
            }


            sql += @"
                ORDER BY
                    A.OUPT_LOTNO,
                    A.OUPT_INDEX
            ";
        }

        // =====================================================
        // LOT
        // =====================================================

        else if (searchType == "LOTNO")
        {
            if (!string.IsNullOrWhiteSpace(
                searchText))
            {
                sql += @"
                    AND A.OUPT_LOTNO =
                        @SearchText
                ";

                param.Add(
                    "SearchText",
                    searchText);
            }


            sql += @"
                ORDER BY
                    A.OUPT_LOTNO,
                    A.OUPT_INDEX
            ";
        }

        // =====================================================
        // 위치
        // =====================================================

        else if (searchType == "LOCA")
        {
            if (!string.IsNullOrWhiteSpace(
                searchText))
            {
                sql += @"
                    AND A.OUPT_LOCA =
                        @SearchText
                ";

                param.Add(
                    "SearchText",
                    searchText);
            }


            sql += @"
                ORDER BY
                    A.OUPT_LOCA,
                    A.OUPT_INDEX
            ";
        }

        // =====================================================
        // ALL
        // =====================================================

        else
        {
            sql += @"
                ORDER BY
                    A.OUPT_INDEX,
                    A.OUPT_CODE
            ";
        }


        return await conn.QueryAsync<
            Frm4300Dto.ResDto>(
            sql,
            param);
    }


    // =========================================================
    // 출고예약 이력 삭제
    //
    // Delphi DeleteBitBtnClick 대응
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm4300Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        conn.Open();


        using var tran =
            conn.BeginTransaction();


        try
        {
            var count =
                0;


            foreach (var item in reqDto.Items)
            {
                var index =
                    item.OuptIndex?
                        .Trim()
                    ?? string.Empty;


                var code =
                    item.OuptCode?
                        .Trim()
                    ?? string.Empty;


                var lotNo =
                    item.OuptLotno?
                        .Trim()
                    ?? string.Empty;


                var cust =
                    item.OuptCust?
                        .Trim()
                    ?? string.Empty;


                var loca =
                    item.OuptLoca?
                        .Trim()
                    ?? string.Empty;


                if (string.IsNullOrWhiteSpace(
                    index))
                {
                    continue;
                }


                // =================================================
                // 1. 출고이력 삭제
                // =================================================

                count +=
                    await conn.ExecuteAsync(
                        @"
                        DELETE FROM T1MIOUPT

                        WHERE OUPT_INDEX =
                              @Index

                          AND OUPT_CODE =
                              @Code

                          AND OUPT_LOTNO =
                              @LotNo

                          AND OUPT_CUST =
                              @Cust
                        ",
                        new
                        {
                            Index =
                                index,

                            Code =
                                code,

                            LotNo =
                                lotNo,

                            Cust =
                                cust
                        },
                        tran);


                // =================================================
                // 2. SUBK 상태 원복
                // =================================================

                await conn.ExecuteAsync(
                    @"
                    UPDATE T1MISUBK

                    SET
                        SUBK_RWGT = 0.00,
                        SUBK_FLAG = '1'

                    WHERE SUBK_FLAG = 'Y'

                      AND SUBK_LOCA =
                          @Loca
                    ",
                    new
                    {
                        Loca =
                            loca
                    },
                    tran);


                // =================================================
                // 3. 랙 상태 원복
                // =================================================

                await conn.ExecuteAsync(
                    @"
                    UPDATE T1MILSTK

                    SET LSTK_FLAG = '1'

                    WHERE LSTK_FLAG = 'Y'

                      AND LSTK_LOCA =
                          @Loca
                    ",
                    new
                    {
                        Loca =
                            loca
                    },
                    tran);


                // =================================================
                // 4. Tracking 원복
                // =================================================

                await conn.ExecuteAsync(
                    @"
                    UPDATE T1TBTRAK

                    SET
                        TRAK_INDEX = '',
                        TRAK_LOCA  = '',
                        TRAK_GUBUN = '',
                        TRAK_HIGH  = '',
                        TRAK_FLAG  = '',
                        TRAK_DATE  = '',
                        TRAK_TIME  = ''

                    WHERE TRAK_INDEX =
                          @Index
                    ",
                    new
                    {
                        Index =
                            index
                    },
                    tran);
            }


            tran.Commit();


            return count;
        }
        catch
        {
            tran.Rollback();

            throw;
        }
    }


    // =========================================================
    // 동일 PLT 미출고 건수
    // =========================================================

    public async Task<int> PendingCountAsync(
        string pltNo)
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT COUNT(*)

            FROM T1MIOUPT WITH (NOLOCK)

            WHERE OUPT_PLTNO =
                  @PltNo

              AND OUPT_JOB_FLAG =
                  '0'
        ";


        return await conn.QueryFirstAsync<int>(
            sql,
            new
            {
                PltNo =
                    pltNo
            });
    }


    // =========================================================
    // 수동 출고 완료
    //
    // 최신 Delphi Outlet_complete_proc 대응
    // =========================================================

    public async Task<Frm4300Dto.CompleteResultDto> CompleteAsync(
        Frm4300Dto.CompleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        conn.Open();


        using var tran =
            conn.BeginTransaction();


        try
        {
            var index =
                reqDto.OuptIndex?
                    .Trim()
                ?? string.Empty;


            var loca =
                reqDto.OuptLoca?
                    .Trim()
                ?? string.Empty;


            var pltNo =
                reqDto.OuptPltno?
                    .Trim()
                ?? string.Empty;


            if (string.IsNullOrWhiteSpace(index) ||
                string.IsNullOrWhiteSpace(loca))
            {
                return new Frm4300Dto.CompleteResultDto
                {
                    Success =
                        false,

                    Message =
                        "필수 데이터(위치, 지시번호)가 누락되었습니다."
                };
            }


            // =====================================================
            // PLTNO 없으면 위치에서 검색
            // =====================================================

            if (string.IsNullOrWhiteSpace(
                pltNo))
            {
                pltNo =
                    await conn.QueryFirstOrDefaultAsync<string>(
                        @"
                        SELECT
                            MAX(SUBK_PLTNO)

                        FROM T1MISUBK WITH (NOLOCK)

                        WHERE SUBK_LOCA =
                              @Loca
                        ",
                        new
                        {
                            Loca =
                                loca
                        },
                        tran)
                    ?? string.Empty;
            }


            if (string.IsNullOrWhiteSpace(
                pltNo))
            {
                return new Frm4300Dto.CompleteResultDto
                {
                    Success =
                        false,

                    Message =
                        "파렛트 번호를 찾을 수 없습니다."
                };
            }


            var time =
                DateTime.Now.ToString(
                    "HHmmss");


            // =====================================================
            // 동일 INDEX + PLT 모든 미완료 출고정보
            // =====================================================

            var outputItems =
                (
                    await conn.QueryAsync<
                        CompleteRow>(
                        @"
                        SELECT
                            OUPT_CODE
                                AS Code,

                            OUPT_LOTNO
                                AS LotNo,

                            OUPT_BOXNO
                                AS BoxNo,

                            ISNULL(
                                OUPT_OUT_WGT,
                                0
                            )
                                AS OutQty,

                            OUPT_CUST
                                AS Cust

                        FROM T1MIOUPT WITH (NOLOCK)

                        WHERE OUPT_INDEX =
                              @Index

                          AND OUPT_PLTNO =
                              @PltNo

                          AND OUPT_JOB_FLAG =
                              '0'
                        ",
                        new
                        {
                            Index =
                                index,

                            PltNo =
                                pltNo
                        },
                        tran)
                )
                .ToList();


            if (outputItems.Count == 0)
            {
                return new Frm4300Dto.CompleteResultDto
                {
                    Success =
                        false,

                    Message =
                        "처리할 미출고 데이터가 없습니다."
                };
            }


            // =====================================================
            // 품목별 출고 처리
            // =====================================================

            foreach (var item in outputItems)
            {
                // =================================================
                // 1. 실제재고 + 예약수량 차감
                // =================================================

                await conn.ExecuteAsync(
                    @"
                    UPDATE T1MISUBK

                    SET
                        SUBK_WGT =
                            SUBK_WGT -
                            @OutQty,

                        SUBK_RWGT =
                            SUBK_RWGT -
                            @OutQty

                    WHERE SUBK_PLTNO =
                          @PltNo

                      AND SUBK_CODE =
                          @Code

                      AND SUBK_LOTNO =
                          @LotNo
                    ",
                    new
                    {
                        OutQty =
                            item.OutQty,

                        PltNo =
                            pltNo,

                        Code =
                            item.Code,

                        LotNo =
                            item.LotNo
                    },
                    tran);


                // =================================================
                // 2. 출고이력 완료 처리
                // =================================================

                await conn.ExecuteAsync(
                    @"
                    UPDATE T1MIOUPT

                    SET
                        OUPT_JOB_FLAG = 'C',
                        OUPT_TIME     = @Time

                    WHERE OUPT_INDEX =
                          @Index

                      AND OUPT_PLTNO =
                          @PltNo

                      AND OUPT_CODE =
                          @Code

                      AND OUPT_LOTNO =
                          @LotNo
                    ",
                    new
                    {
                        Time =
                            time,

                        Index =
                            index,

                        PltNo =
                            pltNo,

                        Code =
                            item.Code,

                        LotNo =
                            item.LotNo
                    },
                    tran);
            }


            // =====================================================
            // 3. 수량 0인 품목 삭제
            // =====================================================

            await conn.ExecuteAsync(
                @"
                DELETE FROM T1MISUBK

                WHERE SUBK_PLTNO =
                      @PltNo

                  AND SUBK_WGT <=
                      0.001
                ",
                new
                {
                    PltNo =
                        pltNo
                },
                tran);


            // =====================================================
            // 4. 남아있는 동반재고 → 재입고 상태
            // =====================================================

            await conn.ExecuteAsync(
                @"
                UPDATE T1MISUBK

                SET
                    SUBK_LOCA = '',
                    SUBK_FLAG = 'R'

                WHERE SUBK_PLTNO =
                      @PltNo
                ",
                new
                {
                    PltNo =
                        pltNo
                },
                tran);


            // =====================================================
            // 5. 원래 랙 위치 빈 셀 처리
            // =====================================================

            await conn.ExecuteAsync(
                @"
                UPDATE T1MILSTK

                SET
                    LSTK_FLAG   = '0',
                    LSTK_INDATE = '',
                    LSTK_INTIME = '',
                    LSTK_PLTNO  = ''

                WHERE LSTK_LOCA =
                      @Loca
                ",
                new
                {
                    Loca =
                        loca
                },
                tran);


            // =====================================================
            // 6. 출고 Schedule 삭제
            //
            // Delphi T2TISCHE1 → T1TISCHE1
            // =====================================================

            await conn.ExecuteAsync(
                @"
                DELETE FROM T1TISCHE1

                WHERE SCHE_PLTNO =
                      @PltNo
                ",
                new
                {
                    PltNo =
                        pltNo
                },
                tran);


            tran.Commit();


            return new Frm4300Dto.CompleteResultDto
            {
                Success =
                    true,

                CompleteCount =
                    outputItems.Count,

                Message =
                    $"PLT [{pltNo}] 수동 출고 완료 처리되었습니다."
            };
        }
        catch
        {
            tran.Rollback();

            throw;
        }
    }


    // =========================================================
    // 내부 DTO
    // =========================================================

    private sealed class CompleteRow
    {
        public string? Code { get; set; }

        public string? LotNo { get; set; }

        public string? BoxNo { get; set; }

        public decimal OutQty { get; set; }

        public string? Cust { get; set; }
    }
}