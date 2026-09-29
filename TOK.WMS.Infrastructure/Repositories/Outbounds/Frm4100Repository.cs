using Dapper;
using System.Data;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public class Frm4100Repository(
    DbConnectionFactory db)
    : IFrm4100Repository
{
    // =========================================================
    // 재고 조회
    // =========================================================

    public async Task<IEnumerable<Frm4100Dto.StockDto>?> SearchAsync(
        Frm4100Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        var sql = @"
            SELECT
                A.SUBK_LOCA       AS SubkLoca,
                A.SUBK_PLTNO      AS SubkPltno,
                A.SUBK_CODE       AS SubkCode,
                B.MAST_NAME       AS MastName,
                A.SUBK_LOTNO      AS SubkLotno,

                ISNULL(
                    A.SUBK_WGT,
                    0
                )                 AS SubkWgt,

                A.SUBK_BOXNO      AS SubkBoxno,
                A.SUBK_REMARK     AS SubkRemark,
                A.SUBK_INDATE     AS SubkIndate,
                A.SUBK_INTIME     AS SubkIntime

            FROM T2MISUBK A WITH (NOLOCK)

            LEFT JOIN MIMAST B WITH (NOLOCK)
                ON B.MAST_CODE =
                   A.SUBK_CODE

            LEFT JOIN T2MILSTK C WITH (NOLOCK)
                ON C.LSTK_LOCA =
                   A.SUBK_LOCA

            WHERE ISNULL(
                      A.SUBK_CODE,
                      ''
                  ) <> ''

              AND C.LSTK_FLAG = '1'
              AND A.SUBK_FLAG = '1'
        ";


        var param =
            new DynamicParameters();


        // -----------------------------------------------------
        // 품목코드
        // -----------------------------------------------------

        if (!string.IsNullOrWhiteSpace(
            reqDto.ItemCode))
        {
            sql += @"
                AND A.SUBK_CODE =
                    @ItemCode
            ";


            param.Add(
                "ItemCode",
                reqDto.ItemCode.Trim());
        }


        // -----------------------------------------------------
        // 품명
        // -----------------------------------------------------

        if (!string.IsNullOrWhiteSpace(
            reqDto.ItemName))
        {
            sql += @"
                AND B.MAST_NAME LIKE
                    '%' + @ItemName + '%'
            ";


            param.Add(
                "ItemName",
                reqDto.ItemName.Trim());
        }


        // -----------------------------------------------------
        // LOT
        // -----------------------------------------------------

        if (!string.IsNullOrWhiteSpace(
            reqDto.LotNo))
        {
            sql += @"
                AND A.SUBK_LOTNO LIKE
                    '%' + @LotNo + '%'
            ";


            param.Add(
                "LotNo",
                reqDto.LotNo.Trim());
        }


        sql += @"
            ORDER BY
                A.SUBK_LOCA,
                A.SUBK_PLTNO,
                A.SUBK_CODE,
                A.SUBK_BOXNO,
                A.SUBK_INDATE,
                A.SUBK_INTIME,
                A.SUBK_LOTNO
        ";


        return await conn.QueryAsync<
            Frm4100Dto.StockDto>(
            sql,
            param);
    }


    // =========================================================
    // 선택 위치 팔레트 자료
    // =========================================================

    public async Task<IEnumerable<Frm4100Dto.PalletItemDto>?> PalletSearchAsync(
        string loca)
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                A.SUBK_LOCA       AS SubkLoca,
                A.SUBK_CODE       AS SubkCode,

                B.MAST_NAME       AS MastName,

                A.SUBK_LOTNO      AS SubkLotno,
                A.SUBK_FLAG       AS SubkFlag,

                ISNULL(
                    A.SUBK_WGT,
                    0
                )                 AS SubkWgt,

                ISNULL(
                    A.SUBK_RWGT,
                    0
                )                 AS SubkRwgt,

                A.SUBK_BOXNO      AS SubkBoxno,
                A.SUBK_REMARK     AS SubkRemark,
                A.SUBK_INDATE     AS SubkIndate,
                A.SUBK_INTIME     AS SubkIntime

            FROM T2MISUBK A WITH (NOLOCK)

            LEFT JOIN MIMAST B WITH (NOLOCK)
                ON B.MAST_CODE =
                   A.SUBK_CODE

            WHERE ISNULL(
                      A.SUBK_CODE,
                      ''
                  ) <> ''

              AND A.SUBK_LOCA =
                  @Loca

            ORDER BY
                A.SUBK_CODE,
                A.SUBK_LOTNO,
                A.SUBK_BOXNO
        ";


        return await conn.QueryAsync<
            Frm4100Dto.PalletItemDto>(
            sql,
            new
            {
                Loca =
                    loca
            });
    }


    // =========================================================
    // 출고대 상태 조회
    //
    // 지원 위치 형식
    //
    // 010105  -> BANK 01
    // 020105  -> BANK 02
    // 030105  -> BANK 03
    //
    // 1-01-1  -> BANK 1
    // 2-01-1  -> BANK 2
    //
    // BANK 1/2 -> 1호기
    // BANK 3/4 -> 2호기
    // BANK 5/6 -> 3호기
    // =========================================================

    public async Task<Frm4100Dto.StationStatusDto?> StationStatusAsync(
        string loca)
    {
        using var conn =
            db.Create();


        if (string.IsNullOrWhiteSpace(
            loca))
        {
            return null;
        }


        var bank =
            GetBankNo(
                loca);


        if (bank <= 0)
        {
            return null;
        }


        var result =
            new Frm4100Dto.StationStatusDto();


        // =====================================================
        // BANK 1,2
        // → 1호기
        // → 출고대 1,2
        // =====================================================

        if (bank is 1 or 2)
        {
            result.Hogi =
                "1";


            result.Station1No =
                "1";


            result.Station2No =
                "2";


            const string sql = @"
                SELECT TOP 1
                    CVC1_CH01

                FROM T2TBCVC1 WITH (NOLOCK)

                WHERE CVC1_SR = 'R'
            ";


            var value =
                await conn.QueryFirstOrDefaultAsync<string>(
                    sql);


            ApplyStationStatus(
                result,
                value);


            return result;
        }


        // =====================================================
        // BANK 3,4
        // → 2호기
        // → 출고대 3,4
        // =====================================================

        if (bank is 3 or 4)
        {
            result.Hogi =
                "2";


            result.Station1No =
                "3";


            result.Station2No =
                "4";


            const string sql = @"
                SELECT TOP 1
                    CVC2_CH01

                FROM T2TBCVC2 WITH (NOLOCK)

                WHERE CVC2_SR = 'R'
            ";


            var value =
                await conn.QueryFirstOrDefaultAsync<string>(
                    sql);


            ApplyStationStatus(
                result,
                value);


            return result;
        }


        // =====================================================
        // BANK 5,6
        // → 3호기
        // → 출고대 5,6
        // =====================================================

        if (bank is 5 or 6)
        {
            result.Hogi =
                "3";


            result.Station1No =
                "5";


            result.Station2No =
                "6";


            const string sql = @"
                SELECT TOP 1
                    CVC3_CH01

                FROM T2TBCVC3 WITH (NOLOCK)

                WHERE CVC3_SR = 'R'
            ";


            var value =
                await conn.QueryFirstOrDefaultAsync<string>(
                    sql);


            ApplyStationStatus(
                result,
                value);


            return result;
        }


        return null;
    }


    // =========================================================
    // 위치 문자열에서 BANK 번호 추출
    // =========================================================

    private static int GetBankNo(
        string loca)
    {
        var value =
            loca.Trim();


        if (string.IsNullOrWhiteSpace(
            value))
        {
            return 0;
        }


        // =====================================================
        // Format A
        //
        // 1-01-1
        // 2-03-4
        //
        // 첫 "-" 앞이 Bank
        // =====================================================

        if (value.Contains('-'))
        {
            var split =
                value.Split(
                    '-',
                    StringSplitOptions.RemoveEmptyEntries);


            if (split.Length > 0 &&
                int.TryParse(
                    split[0],
                    out var formattedBank))
            {
                return formattedBank;
            }


            return 0;
        }


        // =====================================================
        // Format B
        //
        // 010105
        // 020105
        // 030105
        //
        // 첫 2자리 = BANK
        // =====================================================

        if (value.Length >= 2)
        {
            var bankText =
                value.Substring(
                    0,
                    2);


            if (int.TryParse(
                bankText,
                out var bank))
            {
                return bank;
            }
        }


        // =====================================================
        // 혹시 1 / 2 / 3 등의 값만 들어오는 경우
        // =====================================================

        if (int.TryParse(
            value,
            out var singleBank))
        {
            return singleBank;
        }


        return 0;
    }


    // =========================================================
    // PLC / CVC 문자열 해석
    // =========================================================

    private static void ApplyStationStatus(
        Frm4100Dto.StationStatusDto result,
        string? value)
    {
        var s =
            value
            ?? string.Empty;


        result.Station1Visible =
            true;


        result.Station2Visible =
            true;


        // =====================================================
        // Delphi
        //
        // Copy(CH01, 12, 1)
        //
        // C# index는 0부터 시작
        // → [11]
        // =====================================================

        result.Station1OutputMode =
            s.Length >= 12 &&
            s[11] == '1';


        // =====================================================
        // Delphi
        //
        // Copy(CH01, 13, 1)
        //
        // C# → [12]
        // =====================================================

        result.Station2OutputMode =
            s.Length >= 13 &&
            s[12] == '1';


        // =====================================================
        // Delphi
        //
        // Copy(CH01, 16, 1)
        //
        // C# → [15]
        // =====================================================

        result.AutoMode =
            s.Length >= 16 &&
            s[15] == '1';


        result.Station1ModeText =
            result.Station1OutputMode
                ? "[출고모드]"
                : "[입고모드]";


        result.Station2ModeText =
            result.Station2OutputMode
                ? "[출고모드]"
                : "[입고모드]";
    }


    // =========================================================
    // 출고예약
    // =========================================================

    public async Task<Frm4100Dto.ReserveResultDto> ReserveAsync(
        Frm4100Dto.ReserveReqDto reqDto)
    {
        using var conn =
            db.Create();


        conn.Open();


        using var tran =
            conn.BeginTransaction();


        try
        {
            if (reqDto.Items.Count == 0)
            {
                return new Frm4100Dto.ReserveResultDto
                {
                    Success =
                        false,

                    Message =
                        "출고예약 데이터가 없습니다."
                };
            }


            var now =
                DateTime.Now;


            var date =
                now.ToString(
                    "yyyyMMdd");


            var time =
                now.ToString(
                    "HHmmss");


            var processedPlts =
                new HashSet<string>(
                    StringComparer.OrdinalIgnoreCase);


            var detailCount =
                0;


            // =====================================================
            // PLT 단위 처리
            // =====================================================

            foreach (var first in reqDto.Items)
            {
                var pltNo =
                    first.SubkPltno?
                        .Trim()
                    ?? string.Empty;


                if (string.IsNullOrWhiteSpace(
                    pltNo))
                {
                    continue;
                }


                // 이미 처리한 PLT
                if (!processedPlts.Add(
                    pltNo))
                {
                    continue;
                }


                var loca =
                    first.SubkLoca?
                        .Trim()
                    ?? string.Empty;


                var wsno =
                    first.Wsno?
                        .Trim()
                    ?? string.Empty;


                // =================================================
                // 출고 INDEX 발급
                // =================================================

                var outIndex =
                    await CreateOutIndexAsync(
                        conn,
                        tran,
                        date);


                // =================================================
                // PLT 전체 재고량
                // =================================================

                var stockTotal =
                    await conn.QueryFirstOrDefaultAsync<decimal>(
                        @"
                        SELECT
                            ISNULL(
                                SUM(SUBK_WGT),
                                0
                            )

                        FROM T2MISUBK WITH (NOLOCK)

                        WHERE SUBK_LOCA =
                              @Loca
                        ",
                        new
                        {
                            Loca =
                                loca
                        },
                        tran);


                // =================================================
                // 기존 예약량
                // =================================================

                var reservedTotal =
                    await conn.QueryFirstOrDefaultAsync<decimal>(
                        @"
                        SELECT
                            ISNULL(
                                SUM(SUBK_RWGT),
                                0
                            )

                        FROM T2MISUBK WITH (NOLOCK)

                        WHERE SUBK_LOCA =
                              @Loca
                        ",
                        new
                        {
                            Loca =
                                loca
                        },
                        tran);


                // =================================================
                // 이번 화면에서 예약할 수량
                // =================================================

                var gridRequestQty =
                    reqDto.Items
                        .Where(
                            x =>
                                string.Equals(
                                    x.SubkPltno,
                                    pltNo,
                                    StringComparison.OrdinalIgnoreCase))
                        .Sum(
                            x =>
                                x.RequestQty);


                // =================================================
                // 전체출고 T / 부분출고 P
                // =================================================

                var gubun =
                    stockTotal <=
                    reservedTotal +
                    gridRequestQty +
                    0.001m
                        ? "T"
                        : "P";


                // =================================================
                // 작업지시
                // =================================================

                await InsertScheduleAsync(
                    conn,
                    tran,

                    outIndex,
                    loca,
                    gubun,
                    wsno,
                    pltNo,

                    reqDto.Emergency,

                    date,
                    time);


                // =================================================
                // 사용자가 선택한 품목 Key
                // =================================================

                var selectedKeys =
                    new HashSet<string>(
                        StringComparer.OrdinalIgnoreCase);


                // =================================================
                // 선택한 출고 품목
                // =================================================

                foreach (var item in
                    reqDto.Items.Where(
                        x =>
                            string.Equals(
                                x.SubkPltno,
                                pltNo,
                                StringComparison.OrdinalIgnoreCase)))
                {
                    var code =
                        item.SubkCode?
                            .Trim()
                        ?? string.Empty;


                    var lot =
                        item.SubkLotno?
                            .Trim()
                        ?? string.Empty;


                    selectedKeys.Add(
                        $"{code}|{lot}");


                    var rflag =
                        item.RequestQty == 0 ||
                        item.StockQty !=
                        item.RequestQty
                            ? "R"
                            : "O";


                    var seq =
                        await NextSeqAsync(
                            conn,
                            tran,
                            outIndex);


                    // =================================================
                    // 출고 이력
                    // =================================================

                    await conn.ExecuteAsync(
                        @"
                        INSERT INTO T2MIOUPT
                        (
                            OUPT_DATE,
                            OUPT_INDEX,
                            OUPT_SEQNO,

                            OUPT_PLTNO,
                            OUPT_LOCA,

                            OUPT_CODE,
                            OUPT_LOTNO,

                            OUPT_WGT,
                            OUPT_OUT_WGT,

                            OUPT_GUBUN,
                            OUPT_JOB_FLAG,

                            OUPT_CUST,
                            OUPT_TIME,

                            OUPT_BOXNO1,
                            OUPT_REMARK1,

                            OUPT_ID,
                            OUPT_RFLAG,

                            OUPT_BOXNO,
                            OUPT_REMARK
                        )
                        VALUES
                        (
                            @Date,
                            @Index,
                            @Seq,

                            @PltNo,
                            @Loca,

                            @Code,
                            @LotNo,

                            @StockQty,
                            @RequestQty,

                            'Y',
                            '0',

                            @Customer,
                            @Time,

                            @OutBoxno,
                            @OutRemark,

                            @UserId,
                            @Rflag,

                            @Boxno,
                            @Remark
                        )
                        ",
                        new
                        {
                            Date =
                                date,

                            Index =
                                outIndex,

                            Seq =
                                seq,

                            PltNo =
                                pltNo,

                            Loca =
                                loca,

                            Code =
                                code,

                            LotNo =
                                lot,

                            StockQty =
                                item.StockQty,

                            RequestQty =
                                item.RequestQty,

                            Customer =
                                item.Customer
                                ?? string.Empty,

                            Time =
                                time,

                            OutBoxno =
                                item.OutBoxno
                                ?? string.Empty,

                            OutRemark =
                                item.OutRemark
                                ?? string.Empty,

                            UserId =
                                reqDto.UserId
                                ?? string.Empty,

                            Rflag =
                                rflag,

                            Boxno =
                                item.SubkBoxno
                                ?? string.Empty,

                            Remark =
                                item.SubkRemark
                                ?? string.Empty
                        },
                        tran);


                    // =================================================
                    // SUBK 예약
                    // =================================================

                    await conn.ExecuteAsync(
                        @"
                        UPDATE T2MISUBK

                        SET
                            SUBK_FLAG = 'M',

                            SUBK_RWGT =
                                ISNULL(
                                    SUBK_RWGT,
                                    0
                                )
                                + @RequestQty

                        WHERE SUBK_PLTNO =
                              @PltNo

                          AND SUBK_CODE =
                              @Code

                          AND SUBK_LOTNO =
                              @LotNo
                        ",
                        new
                        {
                            RequestQty =
                                item.RequestQty,

                            PltNo =
                                pltNo,

                            Code =
                                code,

                            LotNo =
                                lot
                        },
                        tran);


                    detailCount++;
                }


                // =====================================================
                // 같은 PLT의 동반 재고
                // =====================================================

                var allPalletItems =
                    await conn.QueryAsync<
                        Frm4100Dto.PalletItemDto>(
                        @"
                        SELECT
                            SUBK_CODE
                                AS SubkCode,

                            SUBK_LOTNO
                                AS SubkLotno,

                            ISNULL(
                                SUBK_WGT,
                                0
                            )
                                AS SubkWgt,

                            ISNULL(
                                SUBK_RWGT,
                                0
                            )
                                AS SubkRwgt,

                            SUBK_BOXNO
                                AS SubkBoxno,

                            SUBK_REMARK
                                AS SubkRemark

                        FROM T2MISUBK WITH (NOLOCK)

                        WHERE SUBK_PLTNO =
                              @PltNo
                        ",
                        new
                        {
                            PltNo =
                                pltNo
                        },
                        tran);


                foreach (var other in
                    allPalletItems)
                {
                    var code =
                        other.SubkCode?
                            .Trim()
                        ?? string.Empty;


                    var lot =
                        other.SubkLotno?
                            .Trim()
                        ?? string.Empty;


                    var key =
                        $"{code}|{lot}";


                    if (selectedKeys.Contains(
                        key))
                    {
                        continue;
                    }


                    var seq =
                        await NextSeqAsync(
                            conn,
                            tran,
                            outIndex);


                    // =================================================
                    // 동반재고 출고 이력
                    // OUT_WGT = 0
                    // RFLAG = R
                    // =================================================

                    await conn.ExecuteAsync(
                        @"
                        INSERT INTO T2MIOUPT
                        (
                            OUPT_DATE,
                            OUPT_INDEX,
                            OUPT_SEQNO,

                            OUPT_PLTNO,
                            OUPT_LOCA,

                            OUPT_CODE,
                            OUPT_LOTNO,

                            OUPT_WGT,
                            OUPT_OUT_WGT,

                            OUPT_GUBUN,
                            OUPT_JOB_FLAG,

                            OUPT_CUST,
                            OUPT_TIME,

                            OUPT_BOXNO1,
                            OUPT_REMARK1,

                            OUPT_ID,
                            OUPT_RFLAG,

                            OUPT_BOXNO,
                            OUPT_REMARK
                        )
                        VALUES
                        (
                            @Date,
                            @Index,
                            @Seq,

                            @PltNo,
                            @Loca,

                            @Code,
                            @LotNo,

                            @StockQty,
                            0,

                            'Y',
                            '0',

                            '',
                            @Time,

                            '',
                            '',

                            @UserId,
                            'R',

                            @Boxno,
                            @Remark
                        )
                        ",
                        new
                        {
                            Date =
                                date,

                            Index =
                                outIndex,

                            Seq =
                                seq,

                            PltNo =
                                pltNo,

                            Loca =
                                loca,

                            Code =
                                code,

                            LotNo =
                                lot,

                            StockQty =
                                other.SubkWgt,

                            Time =
                                time,

                            UserId =
                                reqDto.UserId
                                ?? string.Empty,

                            Boxno =
                                other.SubkBoxno
                                ?? string.Empty,

                            Remark =
                                other.SubkRemark
                                ?? string.Empty
                        },
                        tran);


                    // =================================================
                    // 동반재고 상태 M
                    // =================================================

                    await conn.ExecuteAsync(
                        @"
                        UPDATE T2MISUBK

                        SET SUBK_FLAG = 'M'

                        WHERE SUBK_PLTNO =
                              @PltNo

                          AND SUBK_CODE =
                              @Code

                          AND SUBK_LOTNO =
                              @LotNo
                        ",
                        new
                        {
                            PltNo =
                                pltNo,

                            Code =
                                code,

                            LotNo =
                                lot
                        },
                        tran);


                    detailCount++;
                }


                // =====================================================
                // MILSTK 작업중
                // =====================================================

                await conn.ExecuteAsync(
                    @"
                    UPDATE T2MILSTK

                    SET LSTK_FLAG = 'M'

                    WHERE LSTK_LOCA =
                          @Loca
                    ",
                    new
                    {
                        Loca =
                            loca
                    },
                    tran);
            }


            // =========================================================
            // 최종 상태 M -> Y
            // =========================================================

            await ReplaceFlagsAsync(
                conn,
                tran);


            tran.Commit();


            return new Frm4100Dto.ReserveResultDto
            {
                Success =
                    true,

                PltCount =
                    processedPlts.Count,

                DetailCount =
                    detailCount,

                Message =
                    "출고 예약이 완료되었습니다."
            };
        }
        catch
        {
            tran.Rollback();

            throw;
        }
    }


    // =========================================================
    // 바로출고
    // =========================================================

    public async Task<Frm4100Dto.DirectOutputResultDto> DirectOutputAsync(
        Frm4100Dto.DirectOutputReqDto reqDto)
    {
        if (reqDto.Item == null)
        {
            return new Frm4100Dto.DirectOutputResultDto
            {
                Success =
                    false,

                Message =
                    "출고 데이터가 없습니다."
            };
        }


        var reserveReq =
            new Frm4100Dto.ReserveReqDto
            {
                UserId =
                    reqDto.UserId,

                Emergency =
                    reqDto.Emergency,

                Items =
                [
                    reqDto.Item
                ]
            };


        var result =
            await ReserveAsync(
                reserveReq);


        return new Frm4100Dto.DirectOutputResultDto
        {
            Success =
                result.Success,

            Message =
                result.Success
                    ? "바로 출고 처리가 완료되었습니다."
                    : result.Message
        };
    }


    // =========================================================
    // 출고 INDEX 채번
    // =========================================================

    private static async Task<string> CreateOutIndexAsync(
        IDbConnection conn,
        IDbTransaction tran,
        string date)
    {
        var stat =
            await conn.QueryFirstAsync<StatDto>(
                @"
                SELECT
                    STAT_ODATE
                        AS ODate,

                    STAT_OINDX
                        AS OIndex

                FROM T2TBSTAT WITH
                (
                    UPDLOCK,
                    ROWLOCK
                )

                WHERE STAT_PSWD =
                      'JPLS'
                ",
                transaction:
                    tran);


        int index;


        if (stat.ODate ==
            date)
        {
            index =
                stat.OIndex;


            var next =
                stat.OIndex >= 9999
                    ? 1
                    : stat.OIndex + 1;


            await conn.ExecuteAsync(
                @"
                UPDATE T2TBSTAT

                SET STAT_OINDX =
                    @Next

                WHERE STAT_PSWD =
                      'JPLS'
                ",
                new
                {
                    Next =
                        next
                },
                tran);
        }
        else
        {
            index =
                1;


            await conn.ExecuteAsync(
                @"
                UPDATE T2TBSTAT

                SET
                    STAT_ODATE =
                        @Date,

                    STAT_OINDX =
                        2

                WHERE STAT_PSWD =
                      'JPLS'
                ",
                new
                {
                    Date =
                        date
                },
                tran);
        }


        return
            $"{date}O{index:0000}";
    }


    // =========================================================
    // OUPT SEQ
    // =========================================================

    private static async Task<int> NextSeqAsync(
        IDbConnection conn,
        IDbTransaction tran,
        string outIndex)
    {
        return await conn.QueryFirstAsync<int>(
            @"
            SELECT
                ISNULL(
                    MAX(OUPT_SEQNO),
                    0
                ) + 1

            FROM T2MIOUPT WITH
            (
                UPDLOCK
            )

            WHERE OUPT_INDEX =
                  @OutIndex
            ",
            new
            {
                OutIndex =
                    outIndex
            },
            tran);
    }


    // =========================================================
    // T2TISCHE 생성
    // =========================================================

    private static async Task InsertScheduleAsync(
        IDbConnection conn,
        IDbTransaction tran,

        string outIndex,
        string loca,
        string gubun,
        string wsno,
        string pltNo,

        bool emergency,

        string date,
        string time)
    {
        var bank =
            GetBankNo(
                loca);


        var sc =
            bank switch
            {
                1 or 2 =>
                    "1",

                3 or 4 =>
                    "2",

                5 or 6 =>
                    "3",

                _ =>
                    string.Empty
            };


        // -----------------------------------------------------
        // Delphi 실제 SCHE_WSNO는
        // 호기 내부 1/2번으로 변환
        // -----------------------------------------------------

        var ws =
            wsno switch
            {
                "1" or "3" or "5"
                    => "1",

                "2" or "4" or "6"
                    => "2",

                _ =>
                    wsno
            };


        await conn.ExecuteAsync(
            @"
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
            VALUES
            (
                @Sc,
                @Index,
                @Gubun,

                @Loca,
                @Wsno,

                @Date,
                @Time,

                @Emer,
                @PltNo
            )
            ",
            new
            {
                Sc =
                    sc,

                Index =
                    outIndex,

                Gubun =
                    gubun,

                Loca =
                    loca,

                Wsno =
                    ws,

                Date =
                    date,

                Time =
                    time,

                Emer =
                    emergency
                        ? "E"
                        : "N",

                PltNo =
                    pltNo
            },
            tran);
    }


    // =========================================================
    // 상태 최종 확정
    // =========================================================

    private static async Task ReplaceFlagsAsync(
        IDbConnection conn,
        IDbTransaction tran)
    {
        await conn.ExecuteAsync(
            @"
            UPDATE T2MILSTK

            SET LSTK_FLAG = 'Y'

            WHERE LSTK_FLAG = 'M';


            UPDATE T2MISUBK

            SET SUBK_FLAG = 'Y'

            WHERE SUBK_FLAG = 'M';
            ",
            transaction:
                tran);
    }


    // =========================================================
    // T2TBSTAT 내부 DTO
    // =========================================================

    private sealed class StatDto
    {
        public string? ODate { get; set; }

        public int OIndex { get; set; }
    }
}