using Dapper;
using System.Data;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Core.Interfaces.Outbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public class Frm4102Repository(
    DbConnectionFactory db)
    : IFrm4102Repository
{
    // =========================================================
    // 조회
    // =========================================================

    public async Task<IEnumerable<Frm4102Dto.ResDto>?> SearchAsync(
        Frm4102Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
            SELECT
                A.HO_CHASU     AS HoChasu,
                A.HO_DATE      AS HoDate,
                A.HO_TIME      AS HoTime,

                A.HO_CODE      AS HoCode,
                B.MAST_NAME    AS MastName,

                A.HO_LOTNO     AS HoLotno,
                A.HO_CUST      AS HoCust,

                ISNULL(A.HO_QTY, 0)     AS HoQty,
                ISNULL(A.HO_OUTQTY, 0)  AS HoOutQty,
                ISNULL(C.STOK_QTY, 0)   AS StokQty,

                A.HO_BOXNO     AS HoBoxno,
                A.HO_REMARK    AS HoRemark,

                A.HO_FLAG      AS HoFlag

            FROM T1HHOUPT A WITH (NOLOCK)

            LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                ON B.MAST_CODE = A.HO_CODE

            LEFT OUTER JOIN STOK_VIEW2 C WITH (NOLOCK)
                ON C.STOK_CODE = A.HO_CODE
               AND C.STOK_LOTNO = A.HO_LOTNO

            WHERE ISNULL(A.HO_DATE, '') <> ''
        ";

        var param =
            new DynamicParameters();


        if (!string.IsNullOrWhiteSpace(
            reqDto.ItemCode))
        {
            sql += @"
                AND A.HO_CODE = @ItemCode
            ";

            param.Add(
                "ItemCode",
                reqDto.ItemCode.Trim());
        }


        if (!string.IsNullOrWhiteSpace(
            reqDto.OutDate))
        {
            sql += @"
                AND A.HO_DATE = @OutDate
            ";

            param.Add(
                "OutDate",
                reqDto.OutDate);
        }


        sql += @"
            ORDER BY
                A.HO_DATE,
                A.HO_CHASU,
                A.HO_CODE,
                A.HO_LOTNO
        ";


        return await conn.QueryAsync<
            Frm4102Dto.ResDto>(
            sql,
            param);
    }


    // =========================================================
    // 출고확정
    // =========================================================

    public async Task<Frm4102Dto.ReserveResultDto> ReserveAsync(
        Frm4102Dto.ReserveReqDto reqDto)
    {
        using var conn = db.Create();

        conn.Open();

        using var tx =
            conn.BeginTransaction();

        try
        {
            if (reqDto.Items.Count == 0)
            {
                return new Frm4102Dto.ReserveResultDto
                {
                    Success = false,
                    Message = "선택된 출고지시가 없습니다."
                };
            }


            var first =
                reqDto.Items[0];


            var workDate =
                first.HoDate?
                    .Replace("-", "")
                    .Trim()
                ?? string.Empty;


            var chasu =
                first.HoChasu?.Trim()
                ?? string.Empty;


            // =================================================
            // 이미 예약된 차수 확인
            // =================================================

            const string duplicateSql = @"
                SELECT COUNT(*)

                FROM T1HHOUPT WITH (NOLOCK)

                WHERE HO_DATE = @HoDate
                  AND HO_CHASU = @HoChasu
                  AND HO_FLAG = 'Y'
            ";


            var duplicate =
                await conn.ExecuteScalarAsync<int>(
                    duplicateSql,
                    new
                    {
                        HoDate = workDate,
                        HoChasu = chasu
                    },
                    tx);


            if (duplicate > 0)
            {
                tx.Rollback();

                return new Frm4102Dto.ReserveResultDto
                {
                    Success = false,

                    Chasu = chasu,

                    Message =
                        $"{chasu} 이미 출고 예약한 차수입니다."
                };
            }


            // =================================================
            // Delphi와 동일하게 임시 출고 테이블 초기화
            // =================================================

            await conn.ExecuteAsync(
                "DELETE FROM T1TIODAT",
                transaction: tx);


            var shortageCount = 0;


            // =================================================
            // 설비 상태 Snapshot
            // =================================================

            var stat =
                await GetStatAsync(
                    conn,
                    tx);


            // =================================================
            // 선택된 출고지시 처리
            // =================================================

            foreach (var item in reqDto.Items)
            {
                var shortage =
                    await CreateOutInfoAsync(
                        conn,
                        tx,
                        item,
                        stat);

                if (shortage)
                    shortageCount++;


                // Delphi Output_Resv_Proc 마지막 HO_FLAG UPDATE
                const string flagSql = @"
                    UPDATE T1HHOUPT

                    SET HO_FLAG = 'Y'

                    WHERE HO_CHASU = @HoChasu
                      AND HO_DATE = @HoDate
                      AND HO_CODE = @HoCode
                      AND HO_LOTNO = @HoLotno
                      AND HO_CUST = @HoCust
                ";

                await conn.ExecuteAsync(
                    flagSql,
                    new
                    {
                        item.HoChasu,

                        HoDate =
                            item.HoDate?
                                .Replace("-", "")
                            ?? string.Empty,

                        item.HoCode,

                        HoLotno =
                            item.HoLotno
                            ?? string.Empty,

                        HoCust =
                            item.HoCust
                            ?? string.Empty
                    },
                    tx);
            }


            // =================================================
            // T2TIODAT → 작업지시 + 출고이력
            // =================================================

            await CreateOutletDataAsync(
                conn,
                tx,
                reqDto.UserId
                ?? string.Empty);


            // =================================================
            // M → Y
            // =================================================

            await ReplaceFlagsAsync(
                conn,
                tx);


            tx.Commit();


            return new Frm4102Dto.ReserveResultDto
            {
                Success = true,

                SelectedCount =
                    reqDto.Items.Count,

                ShortageCount =
                    shortageCount,

                Chasu =
                    chasu,

                Message =
                    shortageCount == 0

                        ? $"{chasu} [차수] 출고 예약 작업을 완료하였습니다."

                        : $"{chasu} [차수] {shortageCount}건 재고부족이 발생했습니다."
            };
        }
        catch
        {
            tx.Rollback();
            throw;
        }
    }


    // =========================================================
    // 설비 상태
    // =========================================================

    private static async Task<Frm4102Dto.StatDto> GetStatAsync(
        IDbConnection conn,
        IDbTransaction tx)
    {
        //const string sql = @"
        //    SELECT
        //        STAT_SC1IO AS StatSc1Io,
        //        STAT_SC2IO AS StatSc2Io,
        //        STAT_SC3IO AS StatSc3Io,

        //        STAT_CV1 AS StatCv1,
        //        STAT_CV2 AS StatCv2,
        //        STAT_CV3 AS StatCv3,
        //        STAT_CV4 AS StatCv4,
        //        STAT_CV5 AS StatCv5,
        //        STAT_CV6 AS StatCv6,

        //        STAT_ODATE AS StatOdate,
        //        ISNULL(STAT_OINDX, 1) AS StatOindx

        //    FROM T1TBSTAT WITH (UPDLOCK, HOLDLOCK)

        //    WHERE STAT_PSWD = 'JPLS'
        //";

        const string sql = @"
            SELECT
                STAT_SC1IO AS StatSc1Io,
                STAT_SC2IO AS StatSc2Io,
                STAT_SC3IO AS StatSc3Io,

                STAT_ODATE AS StatOdate,
                ISNULL(STAT_OINDX, 1) AS StatOindx

            FROM T1TBSTAT WITH (UPDLOCK, HOLDLOCK)

            WHERE STAT_PSWD = 'JPLS'
        ";

        return await conn.QueryFirstAsync<
            Frm4102Dto.StatDto>(
            sql,
            transaction: tx);
    }


    // =========================================================
    // 출고 재고 할당
    //
    // Delphi OutInfo_Create
    // =========================================================

    private static async Task<bool> CreateOutInfoAsync(
        IDbConnection conn,
        IDbTransaction tx,
        Frm4102Dto.ReserveItemDto item,
        Frm4102Dto.StatDto stat)
    {
        var remainQty =
            item.HoQty;


        var originalQty =
            item.HoQty;


        // =====================================================
        // 1. M 상태 우선
        // =====================================================

        await AllocateStockAsync(
            conn,
            tx,
            item,
            stat,
            "M",
            false,
            originalQty,
            qty => remainQty = qty,
            () => remainQty);


        // =====================================================
        // 2. 일반 랙 1 상태
        // =====================================================

        if (remainQty > 0)
        {
            await AllocateStockAsync(
                conn,
                tx,
                item,
                stat,
                "1",
                true,
                originalQty,
                qty => remainQty = qty,
                () => remainQty);
        }


        return remainQty > 0;
    }


    // =========================================================
    // 재고 할당
    // =========================================================

    private static async Task AllocateStockAsync(
        IDbConnection conn,
        IDbTransaction tx,
        Frm4102Dto.ReserveItemDto item,
        Frm4102Dto.StatDto stat,
        string lstkFlag,
        bool processPiggyback,
        decimal originalQty,
        Action<decimal> setRemainQty,
        Func<decimal> getRemainQty)
    {
        const string sql = @"
            SELECT
                S.SUBK_LOCA   AS SubkLoca,
                S.SUBK_CODE   AS SubkCode,
                S.SUBK_LOTNO  AS SubkLotno,

                S.SUBK_BOXNO  AS SubkBoxno,
                S.SUBK_REMARK AS SubkRemark,

                ISNULL(S.SUBK_WGT, 0)  AS SubkWgt,
                ISNULL(S.SUBK_RWGT, 0) AS SubkRwgt,

                S.SUBK_INDATE AS SubkIndate,
                S.SUBK_INTIME AS SubkIntime,

                S.SUBK_PLTNO  AS SubkPltno,

                L.LSTK_FLAG   AS LstkFlag

            FROM T1MISUBK S WITH (UPDLOCK, ROWLOCK)

            INNER JOIN T1MILSTK L WITH (UPDLOCK, ROWLOCK)
                ON L.LSTK_LOCA = S.SUBK_LOCA

            WHERE L.LSTK_FLAG = @LstkFlag
              AND S.SUBK_CODE = @ItemCode
              AND S.SUBK_LOTNO = @LotNo
              AND ISNULL(S.SUBK_WGT, 0) > ISNULL(S.SUBK_RWGT, 0)

            ORDER BY
                S.SUBK_CODE,
                S.SUBK_LOTNO,
                S.SUBK_BOXNO,
                S.SUBK_INDATE,
                S.SUBK_INTIME
        ";


        var stocks =
            (await conn.QueryAsync<
                Frm4102Dto.StockDto>(
                sql,
                new
                {
                    LstkFlag =
                        lstkFlag,

                    ItemCode =
                        item.HoCode,

                    LotNo =
                        item.HoLotno
                        ?? string.Empty
                },
                tx))
            .ToList();


        foreach (var stock in stocks)
        {
            var remainQty =
                getRemainQty();


            if (remainQty <= 0)
                break;


            var loca =
                stock.SubkLoca
                ?? string.Empty;


            if (!IsMachineAvailable(
                loca,
                stat))
            {
                continue;
            }


            var availableQty =
                stock.SubkWgt
                - stock.SubkRwgt;


            if (availableQty <= 0)
                continue;


            var outQty =
                Math.Min(
                    remainQty,
                    availableQty);


            remainQty -=
                outQty;


            setRemainQty(
                remainQty);


            // =============================================
            // SUBK 예약
            // =============================================

            const string updateSubkSql = @"
                UPDATE T1MISUBK

                SET
                    SUBK_FLAG = 'M',
                    SUBK_RWGT =
                        ISNULL(SUBK_RWGT, 0)
                        + @OutQty

                WHERE SUBK_LOCA = @Loca
                  AND SUBK_CODE = @Code
                  AND SUBK_LOTNO = @LotNo
                  AND SUBK_PLTNO = @PltNo
            ";


            await conn.ExecuteAsync(
                updateSubkSql,
                new
                {
                    OutQty =
                        outQty,

                    Loca =
                        loca,

                    Code =
                        stock.SubkCode,

                    LotNo =
                        stock.SubkLotno
                        ?? string.Empty,

                    PltNo =
                        stock.SubkPltno
                },
                tx);


            // =============================================
            // LSTK M 변경
            // =============================================

            await conn.ExecuteAsync(
                @"
                    UPDATE T1MILSTK

                    SET LSTK_FLAG = 'M'

                    WHERE LSTK_LOCA = @Loca
                ",
                new
                {
                    Loca =
                        loca
                },
                tx);


            // =============================================
            // T1TIODAT
            // =============================================

            await UpsertTiodatAsync(
                conn,
                tx,

                item.HoDate?
                    .Replace("-", "")
                    ?? string.Empty,

                item.HoChasu
                    ?? string.Empty,

                stock.SubkCode
                    ?? string.Empty,

                stock.SubkLotno
                    ?? string.Empty,

                item.HoCust
                    ?? string.Empty,

                loca,

                stock.SubkIndate
                    ?? string.Empty,

                stock.SubkIntime
                    ?? string.Empty,

                stock.SubkBoxno
                    ?? string.Empty,

                stock.SubkRemark
                    ?? string.Empty,

                item.HoBoxno
                    ?? string.Empty,

                item.HoRemark
                    ?? string.Empty,

                originalQty,

                stock.SubkWgt,

                outQty);


            // =============================================
            // 동반재고
            // =============================================

            if (processPiggyback)
            {
                await ProcessPiggybackAsync(
                    conn,
                    tx,
                    item,
                    stock);
            }
        }
    }


    // =========================================================
    // 설비 사용 가능 여부
    // =========================================================

    private static bool IsMachineAvailable(
        string loca,
        Frm4102Dto.StatDto stat)
    {
        if (string.IsNullOrWhiteSpace(
            loca))
        {
            return false;
        }


        var bank =
            loca[0];


        var machine =
            bank switch
            {
                '1' or '2' => "1",
                '3' or '4' => "2",
                '5' or '6' => "3",
                _ => string.Empty
            };


        return machine switch
        {
            "1" =>
                stat.StatSc1Io != "0"
                && stat.StatSc1Io != "1",

            "2" =>
                stat.StatSc2Io != "0"
                && stat.StatSc2Io != "1",

            "3" =>
                stat.StatSc3Io != "0"
                && stat.StatSc3Io != "1",

            _ =>
                false
        };
    }


    // =========================================================
    // 동반재고
    // =========================================================

    private static async Task ProcessPiggybackAsync(
        IDbConnection conn,
        IDbTransaction tx,
        Frm4102Dto.ReserveItemDto item,
        Frm4102Dto.StockDto target)
    {
        const string sql = @"
            SELECT
                SUBK_CODE   AS SubkCode,
                SUBK_LOTNO  AS SubkLotno,
                SUBK_WGT    AS SubkWgt,
                SUBK_BOXNO  AS SubkBoxno,
                SUBK_REMARK AS SubkRemark

            FROM T1MISUBK WITH (UPDLOCK, ROWLOCK)

            WHERE SUBK_PLTNO = @PltNo
              AND NOT
              (
                    SUBK_CODE = @Code
                AND SUBK_LOTNO = @LotNo
              )

            ORDER BY
                SUBK_CODE,
                SUBK_LOTNO
        ";


        var others =
            await conn.QueryAsync<
                Frm4102Dto.StockDto>(
                sql,
                new
                {
                    PltNo =
                        target.SubkPltno,

                    Code =
                        target.SubkCode,

                    LotNo =
                        target.SubkLotno
                        ?? string.Empty
                },
                tx);


        foreach (var stock in others)
        {
            await conn.ExecuteAsync(
                @"
                    UPDATE T1MISUBK

                    SET SUBK_FLAG = 'M'

                    WHERE SUBK_PLTNO = @PltNo
                      AND SUBK_CODE = @Code
                      AND SUBK_LOTNO = @LotNo
                ",
                new
                {
                    PltNo =
                        target.SubkPltno,

                    Code =
                        stock.SubkCode,

                    LotNo =
                        stock.SubkLotno
                        ?? string.Empty
                },
                tx);


            await UpsertTiodatAsync(
                conn,
                tx,

                item.HoDate?
                    .Replace("-", "")
                    ?? string.Empty,

                item.HoChasu
                    ?? string.Empty,

                stock.SubkCode
                    ?? string.Empty,

                stock.SubkLotno
                    ?? string.Empty,

                item.HoCust
                    ?? string.Empty,

                target.SubkLoca
                    ?? string.Empty,

                target.SubkIndate
                    ?? string.Empty,

                target.SubkIntime
                    ?? string.Empty,

                stock.SubkBoxno
                    ?? string.Empty,

                stock.SubkRemark
                    ?? string.Empty,

                string.Empty,

                string.Empty,

                0,

                stock.SubkWgt,

                0);
        }
    }


    // =========================================================
    // T2TIODAT UPSERT
    // =========================================================

    private static async Task UpsertTiodatAsync(
        IDbConnection conn,
        IDbTransaction tx,
        string date,
        string chasu,
        string code,
        string lotNo,
        string cust,
        string loca,
        string inDate,
        string inTime,
        string boxNo,
        string remark,
        string boxNo1,
        string remark1,
        decimal jisiQty,
        decimal stockQty,
        decimal outQty)
    {
        const string existsSql = @"
            SELECT COUNT(*)

            FROM T1TIODAT WITH (UPDLOCK, HOLDLOCK)

            WHERE ODAT_DATE = @Date
              AND ODAT_CHASU = @Chasu
              AND ODAT_CODE = @Code
              AND ODAT_LOTNO = @LotNo
              AND ODAT_CUST = @Cust
              AND ODAT_LOCA = @Loca
        ";


        var exists =
            await conn.ExecuteScalarAsync<int>(
                existsSql,
                new
                {
                    Date = date,
                    Chasu = chasu,
                    Code = code,
                    LotNo = lotNo,
                    Cust = cust,
                    Loca = loca
                },
                tx);


        if (exists > 0)
        {
            // 동반재고 OutQty=0은 기존값 덮어쓰지 않음
            if (outQty <= 0)
                return;


            const string updateSql = @"
                UPDATE T1TIODAT

                SET
                    ODAT_RQTY = @OutQty,
                    ODAT_JQTY = @JisiQty,
                    ODAT_BOXNO = @BoxNo,
                    ODAT_REMARK = @Remark

                WHERE ODAT_DATE = @Date
                  AND ODAT_CHASU = @Chasu
                  AND ODAT_CODE = @Code
                  AND ODAT_LOTNO = @LotNo
                  AND ODAT_CUST = @Cust
                  AND ODAT_LOCA = @Loca
            ";


            await conn.ExecuteAsync(
                updateSql,
                new
                {
                    Date =
                        date,

                    Chasu =
                        chasu,

                    Code =
                        code,

                    LotNo =
                        lotNo,

                    Cust =
                        cust,

                    Loca =
                        loca,

                    OutQty =
                        outQty,

                    JisiQty =
                        jisiQty,

                    BoxNo =
                        boxNo,

                    Remark =
                        remark
                },
                tx);

            return;
        }


        const string insertSql = @"
            INSERT INTO T1TIODAT
            (
                ODAT_DATE,
                ODAT_CHASU,

                ODAT_CODE,
                ODAT_LOTNO,
                ODAT_CUST,
                ODAT_LOCA,

                ODAT_INDATE,
                ODAT_INTIME,

                ODAT_BOXNO,
                ODAT_REMARK,

                ODAT_QTY,
                ODAT_RQTY,
                ODAT_JQTY,

                ODAT_BOXNO1,
                ODAT_REMARK1
            )
            VALUES
            (
                @Date,
                @Chasu,

                @Code,
                @LotNo,
                @Cust,
                @Loca,

                @InDate,
                @InTime,

                @BoxNo,
                @Remark,

                @StockQty,
                @OutQty,
                @JisiQty,

                @BoxNo1,
                @Remark1
            )
        ";


        await conn.ExecuteAsync(
            insertSql,
            new
            {
                Date =
                    date,

                Chasu =
                    chasu,

                Code =
                    code,

                LotNo =
                    lotNo,

                Cust =
                    cust,

                Loca =
                    loca,

                InDate =
                    inDate,

                InTime =
                    inTime,

                BoxNo =
                    boxNo,

                Remark =
                    remark,

                StockQty =
                    stockQty,

                OutQty =
                    outQty,

                JisiQty =
                    jisiQty,

                BoxNo1 =
                    boxNo1,

                Remark1 =
                    remark1
            },
            tx);
    }


    // =========================================================
    // T1TIODAT → T1TISCHE1 / T1MIOUPT  
    // =========================================================

    private static async Task CreateOutletDataAsync(
        IDbConnection conn,
        IDbTransaction tx,
        string userId)
    {
        const string sql = @"
            SELECT
                O.ODAT_LOCA AS OdatLoca,
                O.ODAT_CODE AS OdatCode,
                O.ODAT_LOTNO AS OdatLotno,
                O.ODAT_CUST AS OdatCust,

                O.ODAT_RQTY AS OdatRqty,

                MAX(O.ODAT_CHASU) AS OdatChasu,
                MAX(O.ODAT_INDATE) AS OdatIndate,
                MAX(O.ODAT_INTIME) AS OdatIntime,

                MAX(O.ODAT_BOXNO) AS OdatBoxno,
                MAX(O.ODAT_REMARK) AS OdatRemark,

                MAX(O.ODAT_BOXNO1) AS OdatBoxno1,
                MAX(O.ODAT_REMARK1) AS OdatRemark1,

                MAX(S.SUBK_PLTNO) AS SubkPltno,
                MAX(S.SUBK_WGT) AS SubkWgt

            FROM T1TIODAT O WITH (NOLOCK)

            LEFT JOIN T1MISUBK S WITH (NOLOCK)
                ON S.SUBK_LOCA = O.ODAT_LOCA
               AND S.SUBK_CODE = O.ODAT_CODE
               AND S.SUBK_LOTNO = O.ODAT_LOTNO

            GROUP BY
                O.ODAT_LOCA,
                O.ODAT_CODE,
                O.ODAT_LOTNO,
                O.ODAT_CUST,
                O.ODAT_RQTY

            ORDER BY
                O.ODAT_LOCA,
                O.ODAT_CODE,
                O.ODAT_LOTNO,
                O.ODAT_CUST
        ";


        var items =
            (await conn.QueryAsync<
                Frm4102Dto.TiodatDto>(
                sql,
                transaction: tx))
            .ToList();


        var saveLoca =
            string.Empty;

        var currentIndex =
            string.Empty;


        foreach (var item in items)
        {
            var loca =
                item.OdatLoca
                ?? string.Empty;


            // =============================================
            // 위치가 바뀌면 새 출고 INDEX
            // =============================================

            if (saveLoca != loca)
            {
                currentIndex =
                    await NextOutputIndexAsync(
                        conn,
                        tx);


                var sum =
                    await conn.QueryFirstAsync(
                        @"
                            SELECT
                                ISNULL(SUM(SUBK_WGT), 0) AS TotalQty,
                                ISNULL(SUM(SUBK_RWGT), 0) AS TotalOutQty

                            FROM T1MISUBK WITH (NOLOCK)

                            WHERE SUBK_LOCA = @Loca
                        ",
                        new
                        {
                            Loca =
                                loca
                        },
                        tx);


                decimal totalQty =
                    sum.TotalQty;

                decimal totalOutQty =
                    sum.TotalOutQty;


                var gubun =
                    totalQty == totalOutQty
                        ? "T"
                        : "P";


                await InsertScheduleAsync(
                    conn,
                    tx,
                    currentIndex,
                    loca,
                    gubun,
                    item.SubkPltno
                    ?? string.Empty);


                saveLoca =
                    loca;
            }


            var outQty =
                item.OdatRqty;


            var stockQty =
                item.SubkWgt;


            var rflag =
                outQty == 0

                    ? "R"

                    : stockQty != outQty

                        ? "R"

                        : "O";


            var seqNo =
                await NextOutputSeqAsync(
                    conn,
                    tx,
                    currentIndex);


            const string insertOutputSql = @"
                INSERT INTO T1MIOUPT
                (
                    OUPT_DATE,
                    OUPT_INDEX,

                    OUPT_CODE,
                    OUPT_LOTNO,
                    OUPT_CUST,

                    OUPT_SEQNO,

                    OUPT_GUBUN,

                    OUPT_WGT,
                    OUPT_OUT_WGT,

                    OUPT_RLOCA,
                    OUPT_LOCA,

                    OUPT_TIME,

                    OUPT_RFLAG,
                    OUPT_JOB_FLAG,

                    OUPT_CHASU,

                    OUPT_INDATE,
                    OUPT_INTIME,

                    OUPT_BOXNO,
                    OUPT_REMARK,

                    OUPT_LABEL,
                    OUPT_ID,

                    OUPT_BOXNO1,
                    OUPT_REMARK1,

                    OUPT_PLTNO
                )
                VALUES
                (
                    CONVERT(VARCHAR(8), GETDATE(), 112),
                    @Index,

                    @Code,
                    @LotNo,
                    @Cust,

                    @SeqNo,

                    'Y',

                    @StockQty,
                    @OutQty,

                    @Loca,
                    @Loca,

                    REPLACE(
                        CONVERT(VARCHAR(8), GETDATE(), 108),
                        ':',
                        ''
                    ),

                    @Rflag,
                    '0',

                    @Chasu,

                    @InDate,
                    @InTime,

                    @BoxNo,
                    @Remark,

                    'N',
                    @UserId,

                    @BoxNo1,
                    @Remark1,

                    @PltNo
                )
            ";


            await conn.ExecuteAsync(
                insertOutputSql,
                new
                {
                    Index =
                        currentIndex,

                    Code =
                        item.OdatCode,

                    LotNo =
                        item.OdatLotno
                        ?? string.Empty,

                    Cust =
                        item.OdatCust
                        ?? string.Empty,

                    SeqNo =
                        seqNo,

                    StockQty =
                        stockQty,

                    OutQty =
                        outQty,

                    Loca =
                        loca,

                    Rflag =
                        rflag,

                    Chasu =
                        item.OdatChasu,

                    InDate =
                        item.OdatIndate,

                    InTime =
                        item.OdatIntime,

                    BoxNo =
                        item.OdatBoxno,

                    Remark =
                        item.OdatRemark,

                    UserId =
                        userId,

                    BoxNo1 =
                        item.OdatBoxno1,

                    Remark1 =
                        item.OdatRemark1,

                    PltNo =
                        item.SubkPltno
                },
                tx);


            await conn.ExecuteAsync(
                @"
                    UPDATE T1MILSTK

                    SET LSTK_FLAG = 'Y'

                    WHERE LSTK_LOCA = @Loca
                ",
                new
                {
                    Loca =
                        loca
                },
                tx);
        }
    }


    // =========================================================
    // 출고 INDEX
    // =========================================================

    private static async Task<string> NextOutputIndexAsync(
        IDbConnection conn,
        IDbTransaction tx)
    {
        const string statSql = @"
            SELECT
                STAT_ODATE,
                ISNULL(STAT_OINDX, 1) STAT_OINDX

            FROM T1TBSTAT WITH (UPDLOCK, HOLDLOCK)

            WHERE STAT_PSWD = 'JPLS'
        ";


        var stat =
            await conn.QueryFirstAsync(
                statSql,
                transaction: tx);


        var today =
            DateTime.Now.ToString(
                "yyyyMMdd");


        string index;


        if ((string?)stat.STAT_ODATE
            == today)
        {
            var no =
                Convert.ToInt32(
                    stat.STAT_OINDX);


            index =
                $"{today}O{no:0000}";


            await conn.ExecuteAsync(
                @"
                    UPDATE T1TBSTAT

                    SET STAT_OINDX =
                        CASE
                            WHEN STAT_OINDX >= 9999
                            THEN 1
                            ELSE STAT_OINDX + 1
                        END

                    WHERE STAT_PSWD = 'JPLS'
                ",
                transaction: tx);
        }
        else
        {
            index =
                $"{today}O0001";


            await conn.ExecuteAsync(
                @"
                    UPDATE T1TBSTAT

                    SET
                        STAT_ODATE = @Today,
                        STAT_OINDX = 2

                    WHERE STAT_PSWD = 'JPLS'
                ",
                new
                {
                    Today =
                        today
                },
                tx);
        }


        return index;
    }


    // =========================================================
    // 출고 순번
    // =========================================================

    private static async Task<int> NextOutputSeqAsync(
        IDbConnection conn,
        IDbTransaction tx,
        string index)
    {
        return await conn.ExecuteScalarAsync<int>(
            @"
                SELECT
                    ISNULL(MAX(OUPT_SEQNO), 0) + 1

                FROM T1MIOUPT WITH (UPDLOCK, HOLDLOCK)

                WHERE OUPT_INDEX = @Index
            ",
            new
            {
                Index =
                    index
            },
            tx);
    }


    // =========================================================
    // 작업지시
    // =========================================================

    private static async Task InsertScheduleAsync(
        IDbConnection conn,
        IDbTransaction tx,
        string index,
        string loca,
        string gubun,
        string pltNo)
    {
        var stat =
            await GetStatAsync(
                conn,
                tx);


        var bank =
            !string.IsNullOrWhiteSpace(loca)
                ? loca[0]
                : '0';


        var sc =
            bank switch
            {
                '1' or '2' => "1",
                '3' or '4' => "2",
                '5' or '6' => "3",
                _ => "1"
            };


        var to =
            sc switch
            {
                "1" =>
                    stat.StatCv1 == "1"
                        ? "1"
                        : "2",

                "2" =>
                    stat.StatCv3 == "1"
                        ? "1"
                        : "2",

                "3" =>
                    stat.StatCv5 == "1"
                        ? "1"
                        : "2",

                _ =>
                    "1"
            };


        const string sql = @"
            IF NOT EXISTS
            (
                SELECT 1

                FROM T1TISCHE1

                WHERE SCHE_SC = @Sc
                  AND SCHE_INDEX = @Index
            )
            BEGIN

                INSERT INTO T1TISCHE1
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
                    @To,

                    CONVERT(VARCHAR(8), GETDATE(), 112),

                    REPLACE(
                        CONVERT(VARCHAR(8), GETDATE(), 108),
                        ':',
                        ''
                    ),

                    'N',

                    @PltNo
                )

            END
        ";


        await conn.ExecuteAsync(
            sql,
            new
            {
                Sc =
                    sc,

                Index =
                    index,

                Gubun =
                    gubun,

                Loca =
                    loca,

                To =
                    to,

                PltNo =
                    pltNo
            },
            tx);
    }


    // =========================================================
    // M → Y
    // =========================================================

    private static async Task ReplaceFlagsAsync(
        IDbConnection conn,
        IDbTransaction tx)
    {
        await conn.ExecuteAsync(
            @"
                UPDATE T1MILSTK

                SET LSTK_FLAG = 'Y'

                WHERE LSTK_FLAG = 'M'
            ",
            transaction: tx);


        await conn.ExecuteAsync(
            @"
                UPDATE T1MISUBK

                SET SUBK_FLAG = 'Y'

                WHERE SUBK_FLAG = 'M'
            ",
            transaction: tx);
    }


    // =========================================================
    // 선택 삭제
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm4102Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            DELETE FROM T1HHOUPT

            WHERE HO_CHASU = @HoChasu
              AND HO_DATE = @HoDate
              AND HO_CODE = @HoCode
              AND HO_LOTNO = @HoLotno
              AND HO_CUST = @HoCust
        ";


        return await conn.ExecuteAsync(
            sql,
            new
            {
                reqDto.HoChasu,

                HoDate =
                    reqDto.HoDate?
                        .Replace("-", "")
                    ?? string.Empty,

                reqDto.HoCode,

                HoLotno =
                    reqDto.HoLotno
                    ?? string.Empty,

                HoCust =
                    reqDto.HoCust
                    ?? string.Empty
            });
    }


    // =========================================================
    // 전체삭제
    // =========================================================

    public async Task<int> DeleteAllAsync()
    {
        using var conn =
            db.Create();


        return await conn.ExecuteAsync(
            "DELETE FROM T1HHOUPT");
    }
}