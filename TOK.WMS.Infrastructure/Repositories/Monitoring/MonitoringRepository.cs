using Dapper;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.Core.Interfaces.Monitoring;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Monitoring;

public sealed class MonitoringRepository(DbConnectionFactory db) : IMonitoringRepository
{
    private const string StatusPassword = "JPLS";
    private const int OutboundScheduleLimit = 100;

    // 현재 모니터링 배치에 존재하는 구간만 내려 준다.
    // 09, 10, 59는 화면에 없고, 60은 PLC 구간이지만 DB 기본 행이 없을 수 있다.
    private static readonly string[] MonitorTrackNumbers = BuildMonitorTrackNumbers();

    // 평택 상품/제품창고 Tracking 구간.
    // T2TBCVC1 -- 1층
    // T2TBCVC2 -- 2층

    private static readonly BcrLayout[] BcrLayouts =
    [
        new(1, 2, "06"),
        new(2, 3, "14"),
        new(3, 5, "20"),
        new(4, 7, "83")
    ];

    public async Task<Sc1LineSnapshotDto> GetSc1LineSnapshotAsync(
        CancellationToken cancellationToken = default)
    {
        const string sql = """
                           SET NOCOUNT ON;

                           SELECT
                               LTRIM(RTRIM(SCRC_NO)) AS CraneNo,
                               LTRIM(RTRIM(COALESCE(SCRC_CYCLE, ''))) AS Cycle,
                               LTRIM(RTRIM(COALESCE(SCRC_ONLINE, ''))) AS Online,
                               LTRIM(RTRIM(COALESCE(SCRC_READY, ''))) AS Ready,
                               LTRIM(RTRIM(COALESCE(SCRC_HOME, ''))) AS Home,
                               LTRIM(RTRIM(COALESCE(SCRC_LOCA, ''))) AS Location,
                               LTRIM(RTRIM(COALESCE(SCRC_CENTER, ''))) AS Centered,
                               LTRIM(RTRIM(COALESCE(SCRC_ACK, ''))) AS Acknowledged,
                               LTRIM(RTRIM(COALESCE(SCRC_LOAD, ''))) AS Loadable,
                               LTRIM(RTRIM(COALESCE(SCRC_UNLOAD, ''))) AS Unloadable,
                               LTRIM(RTRIM(COALESCE(SCRC_SCPLT, ''))) AS HasPallet,
                               TRY_CONVERT(int, SCRC_POSBY) AS PositionBay,
                               TRY_CONVERT(int, SCRC_POSLV) AS PositionLevel,
                               LTRIM(RTRIM(COALESCE(SCRC_ERROR, ''))) AS ErrorCode,
                               LTRIM(RTRIM(COALESCE(SCRC_PLTNO, ''))) AS PalletNo,
                               LTRIM(RTRIM(COALESCE(SCRC_INDEX, ''))) AS JobIndex,
                               LTRIM(RTRIM(COALESCE(SCRC_GUBUN, ''))) AS JobType,
                               LTRIM(RTRIM(COALESCE(SCRC_WSNO, ''))) AS WorkStation,
                               LTRIM(RTRIM(COALESCE(SCRC_DESC, ''))) AS ErrorDescription
                           FROM dbo.T2TBSCRC WITH (NOLOCK)
                           WHERE TRY_CONVERT(int, SCRC_NO) BETWEEN 1 AND 7
                           ORDER BY TRY_CONVERT(int, SCRC_NO);

                           SELECT TOP (1)
                               LTRIM(RTRIM(COALESCE(STAT_SC1IO, ''))) AS Sc1IoMode,
                               LTRIM(RTRIM(COALESCE(STAT_SC2IO, ''))) AS Sc2IoMode,
                               LTRIM(RTRIM(COALESCE(STAT_SC3IO, ''))) AS Sc3IoMode,
                               LTRIM(RTRIM(COALESCE(STAT_SC4IO, ''))) AS Sc4IoMode,
                               LTRIM(RTRIM(COALESCE(STAT_SC5IO, ''))) AS Sc5IoMode,
                               LTRIM(RTRIM(COALESCE(STAT_SC6IO, ''))) AS Sc6IoMode,
                               LTRIM(RTRIM(COALESCE(STAT_SC7IO, ''))) AS Sc7IoMode,
                               LTRIM(RTRIM(COALESCE(STAT_BCR1, ''))) AS Bcr1Status,
                               LTRIM(RTRIM(COALESCE(STAT_BCR2, ''))) AS Bcr2Status,
                               LTRIM(RTRIM(COALESCE(STAT_BCR3, ''))) AS Bcr3Status,
                               LTRIM(RTRIM(COALESCE(STAT_BCR4, ''))) AS Bcr4Status
                           FROM dbo.T2TBSTAT WITH (NOLOCK)
                           WHERE STAT_PSWD = @StatusPassword;

                           SELECT
                               1 AS ControllerNo,
                               LTRIM(RTRIM(CVC1_SR)) AS Sr,
                               COALESCE(CVC1_CH01, '') AS Ch01,
                               COALESCE(CVC1_CH02, '') AS Ch02,
                               COALESCE(CVC1_CH03, '') AS Ch03,
                               COALESCE(CVC1_CH04, '') AS Ch04,
                               COALESCE(CVC1_CH05, '') AS Ch05,
                               COALESCE(CVC1_CH06, '') AS Ch06,
                               COALESCE(CVC1_CH07, '') AS Ch07
                           FROM dbo.T2TBCVC1 WITH (NOLOCK)
                           WHERE CVC1_SR IN ('R', 'S')
                           UNION ALL
                           SELECT
                               2 AS ControllerNo,
                               LTRIM(RTRIM(CVC2_SR)) AS Sr,
                               COALESCE(CVC2_CH01, '') AS Ch01,
                               COALESCE(CVC2_CH02, '') AS Ch02,
                               COALESCE(CVC2_CH03, '') AS Ch03,
                               COALESCE(CVC2_CH04, '') AS Ch04,
                               COALESCE(CVC2_CH05, '') AS Ch05,
                               COALESCE(CVC2_CH06, '') AS Ch06,
                               COALESCE(CVC2_CH07, '') AS Ch07
                           FROM dbo.T2TBCVC2 WITH (NOLOCK)
                           WHERE CVC2_SR IN ('R', 'S')
                           ORDER BY ControllerNo, Sr;

                           SELECT
                               1 AS RgvNo,
                               LTRIM(RTRIM(RGV1_SR)) AS Sr,
                               COALESCE(RGV1_CH01, '') AS Ch01,
                               LTRIM(RTRIM(COALESCE(RGV1_CH02, ''))) AS Ch02,
                               LTRIM(RTRIM(COALESCE(RGV1_CH03, ''))) AS Ch03,
                               LTRIM(RTRIM(COALESCE(RGV1_CH04, ''))) AS Ch04,
                               LTRIM(RTRIM(COALESCE(
                                   (SELECT ERR_DESC
                                    FROM dbo.TBECODE WITH (NOLOCK)
                                    WHERE ERR_ECODE = RGV1_CH03), ''))) AS ErrorDescription
                           FROM dbo.T2TBRGV1 WITH (NOLOCK)
                           WHERE RGV1_SR IN ('R', 'S')
                           UNION ALL
                           SELECT
                               2 AS RgvNo,
                               LTRIM(RTRIM(RGV2_SR)) AS Sr,
                               COALESCE(RGV2_CH01, '') AS Ch01,
                               LTRIM(RTRIM(COALESCE(RGV2_CH02, ''))) AS Ch02,
                               LTRIM(RTRIM(COALESCE(RGV2_CH03, ''))) AS Ch03,
                               LTRIM(RTRIM(COALESCE(RGV2_CH04, ''))) AS Ch04,
                               LTRIM(RTRIM(COALESCE(
                                   (SELECT ERR_DESC
                                    FROM dbo.TBECODE WITH (NOLOCK)
                                    WHERE ERR_ECODE = RGV2_CH03), ''))) AS ErrorDescription
                           FROM dbo.T2TBRGV2 WITH (NOLOCK)
                           WHERE RGV2_SR IN ('R', 'S')
                           ORDER BY RgvNo, Sr;

                           SELECT 1 AS CraneNo,
                                  COALESCE(SCC1_CH01, '') AS Ch01,
                                  LTRIM(RTRIM(COALESCE(SCC1_CH04, ''))) AS ErrorCode
                           FROM dbo.T2TBSCC1 WITH (NOLOCK) WHERE SCC1_SR = 'R'
                           UNION ALL
                           SELECT 2, COALESCE(SCC2_CH01, ''), LTRIM(RTRIM(COALESCE(SCC2_CH04, '')))
                           FROM dbo.T2TBSCC2 WITH (NOLOCK) WHERE SCC2_SR = 'R'
                           UNION ALL
                           SELECT 3, COALESCE(SCC3_CH01, ''), LTRIM(RTRIM(COALESCE(SCC3_CH04, '')))
                           FROM dbo.T2TBSCC3 WITH (NOLOCK) WHERE SCC3_SR = 'R'
                           UNION ALL
                           SELECT 4, COALESCE(SCC4_CH01, ''), LTRIM(RTRIM(COALESCE(SCC4_CH04, '')))
                           FROM dbo.T2TBSCC4 WITH (NOLOCK) WHERE SCC4_SR = 'R'
                           UNION ALL
                           SELECT 5, COALESCE(SCC5_CH01, ''), LTRIM(RTRIM(COALESCE(SCC5_CH04, '')))
                           FROM dbo.T2TBSCC5 WITH (NOLOCK) WHERE SCC5_SR = 'R'
                           UNION ALL
                           SELECT 6, COALESCE(SCC6_CH01, ''), LTRIM(RTRIM(COALESCE(SCC6_CH04, '')))
                           FROM dbo.T2TBSCC6 WITH (NOLOCK) WHERE SCC6_SR = 'R'
                           UNION ALL
                           SELECT 7, COALESCE(SCC7_CH01, ''), LTRIM(RTRIM(COALESCE(SCC7_CH04, '')))
                           FROM dbo.T2TBSCC7 WITH (NOLOCK) WHERE SCC7_SR = 'R'
                           ORDER BY CraneNo;

                           SELECT
                               LTRIM(RTRIM(TRAK_NO)) AS TrackNo,
                               LTRIM(RTRIM(COALESCE(TRAK_INDEX, ''))) AS [Index],
                               LTRIM(RTRIM(COALESCE(TRAK_GUBUN, ''))) AS JobType,
                               LTRIM(RTRIM(COALESCE(TRAK_LOCA, ''))) AS Location,
                               LTRIM(RTRIM(COALESCE(TRAK_WSNO, ''))) AS WorkStation,
                               LTRIM(RTRIM(COALESCE(TRAK_FROM, ''))) AS [From],
                               LTRIM(RTRIM(COALESCE(TRAK_TO, ''))) AS [To],
                               LTRIM(RTRIM(COALESCE(TRAK_FLAG, ''))) AS Flag,
                               LTRIM(RTRIM(COALESCE(TRAK_DATE, ''))) AS [Date],
                               LTRIM(RTRIM(COALESCE(TRAK_TIME, ''))) AS [Time]
                           FROM dbo.T2TBTRAK WITH (NOLOCK)
                           WHERE TRAK_NO IN @TrackNumbers
                           ORDER BY TRY_CONVERT(int, TRAK_NO);

                           SELECT
                               LTRIM(RTRIM(LSTK_BK)) AS Bank,
                               LTRIM(RTRIM(LSTK_BY)) AS Bay,
                               COUNT(*) AS TotalCells,
                               SUM(CASE WHEN LSTK_FLAG IN ('1', 'Y') THEN 1 ELSE 0 END) AS UsedCells,
                               SUM(CASE WHEN LSTK_FLAG = '0' THEN 1 ELSE 0 END) AS EmptyCells,
                               SUM(CASE WHEN LSTK_FLAG = 'X' THEN 1 ELSE 0 END) AS InboundCells,
                               SUM(CASE WHEN LSTK_FLAG = 'Y' THEN 1 ELSE 0 END) AS OutboundCells,
                               SUM(CASE WHEN LSTK_FLAG IN ('W', 'D') THEN 1 ELSE 0 END) AS DoubleStorageCells,
                               SUM(CASE WHEN LSTK_FLAG = 'E' THEN 1 ELSE 0 END) AS EmptyRetrievalCells,
                               SUM(CASE WHEN LSTK_FLAG = 'N' THEN 1 ELSE 0 END) AS ProhibitedCells
                           FROM dbo.T2MILSTK WITH (NOLOCK)
                           WHERE TRY_CONVERT(int, LSTK_BK) BETWEEN 1 AND 14
                           GROUP BY LSTK_BK, LSTK_BY
                           ORDER BY TRY_CONVERT(int, LSTK_BK), TRY_CONVERT(int, LSTK_BY);

                           SELECT
                               (TRY_CONVERT(int, LSTK_BK) + 1) / 2 AS CraneNo,
                               COUNT(*) AS TotalCells,
                               SUM(CASE WHEN LSTK_FLAG IN ('1', 'Y') THEN 1 ELSE 0 END) AS UsedCells,
                               SUM(CASE WHEN LSTK_FLAG = '0' THEN 1 ELSE 0 END) AS EmptyCells,
                               SUM(CASE WHEN LSTK_FLAG = 'N' THEN 1 ELSE 0 END) AS ProhibitedCells
                           FROM dbo.T2MILSTK WITH (NOLOCK)
                           WHERE TRY_CONVERT(int, LSTK_BK) BETWEEN 1 AND 14
                           GROUP BY (TRY_CONVERT(int, LSTK_BK) + 1) / 2
                           ORDER BY CraneNo;

                           SELECT TOP (@ScheduleLimit)
                               LTRIM(RTRIM(SCHE_INDEX)) AS Sequence,
                               LTRIM(RTRIM(SCHE_SC)) AS CraneNo,
                               LTRIM(RTRIM(COALESCE(SCHE_LOCA, ''))) AS Location,
                               LTRIM(RTRIM(COALESCE(SCHE_WSNO, ''))) AS WorkStation,
                               LTRIM(RTRIM(COALESCE(SCHE_EMER, ''))) AS Emergency,
                               LTRIM(RTRIM(COALESCE(SCHE_DATE, ''))) AS InstructionDate,
                               LTRIM(RTRIM(COALESCE(SCHE_TIME, ''))) AS InstructionTime,
                               LTRIM(RTRIM(COALESCE(SCHE_PLTNO, ''))) AS PalletNo,
                               LTRIM(RTRIM(COALESCE(SCHE_JOBGUBUN, ''))) AS JobType
                           FROM dbo.T2TISCHE WITH (NOLOCK)
                           WHERE TRY_CONVERT(int, SCHE_SC) BETWEEN 1 AND 7
                             AND SCHE_JOBGUBUN = @OutboundJobType
                           ORDER BY SCHE_DATE, SCHE_TIME, SCHE_INDEX;
                           """;

        var command = new CommandDefinition(
            sql,
            new
            {
                StatusPassword,
                TrackNumbers = MonitorTrackNumbers,
                ScheduleLimit = OutboundScheduleLimit,
                OutboundJobType = "O"
            },
            cancellationToken: cancellationToken);

        using var connection = db.Create();
        using var results = await connection.QueryMultipleAsync(command);

        var craneRows = (await results.ReadAsync<CraneRow>()).AsList();
        var systemStatus = await results.ReadFirstOrDefaultAsync<SystemStatusRow>();
        var conveyorRows = (await results.ReadAsync<ConveyorSignalRow>()).AsList();
        var rgvRows = (await results.ReadAsync<RgvSignalRow>()).AsList();
        var scSignalRows = (await results.ReadAsync<ScSignalRow>()).AsList();
        var trackRows = (await results.ReadAsync<TrackRow>()).AsList();
        var rackBays = (await results.ReadAsync<Sc1RackBaySummaryDto>()).AsList();
        var inventoryRows = (await results.ReadAsync<InventoryRow>()).AsList();
        var scheduleRows = (await results.ReadAsync<ScheduleRow>()).AsList();

        var cranes = Enumerable.Range(1, 7)
            .Select(craneNo => MapCrane(
                craneNo,
                craneRows.FirstOrDefault(row => ParseNumber(row.CraneNo) == craneNo),
                scSignalRows.FirstOrDefault(row => row.CraneNo == craneNo)))
            .ToArray();

        var conveyorControllers = Enumerable.Range(1, 2)
            .Select(controllerNo => MapConveyorSignals(conveyorRows, controllerNo))
            .ToArray();

        var rgvs = new[]
        {
            MapRgv(rgvRows, rgvNo: 1),
            MapRgv(rgvRows, rgvNo: 2)
        };

        var tracks = MapTracks(
            trackRows, conveyorControllers[0], conveyorControllers[1], rgvs);
        var tracksByNumber = trackRows.ToDictionary(row => row.TrackNo, StringComparer.Ordinal);
        var bcrs = BcrLayouts
            .Select(layout =>
            {
                tracksByNumber.TryGetValue(layout.ResultTrackNo, out var track);
                return MapBcr(layout, systemStatus?.GetBcrStatus(layout.BcrNo), track);
            })
            .ToArray();

        var inventorySummaries = Enumerable.Range(1, 7)
            .Select(craneNo => MapInventory(
                inventoryRows.FirstOrDefault(row => row.CraneNo == craneNo)
                ?? new InventoryRow { CraneNo = craneNo }))
            .ToArray();

        return new Sc1LineSnapshotDto
        {
            RetrievedAt = DateTimeOffset.Now,
            Crane = cranes[0],
            Cranes = cranes,
            // 2열 운전 모드는 T2TBCVC1.R.CH04의 12번째 비트를 기준으로 한다.
            // 화면 BIT 표기는 0부터 시작하므로 BIT11이며, 0=입고 / 1=출고다.
            LineMode = MapLineMode(conveyorControllers[0].ReceiveCh04),
            Bcr = bcrs[0],
            Bcrs = bcrs,
            ConveyorSignals = conveyorControllers[0],
            ConveyorControllers = conveyorControllers,
            Rgvs = rgvs,
            Tracks = tracks,
            RackBays = rackBays,
            InventorySummary = inventorySummaries[0],
            InventorySummaries = inventorySummaries,
            TotalInventorySummary = BuildTotalInventory(inventorySummaries),
            OutboundSchedules = scheduleRows.Select(MapSchedule).ToArray()
        };
    }

    public async Task<EquipmentPositionSnapshotDto> GetEquipmentPositionsAsync(
        CancellationToken cancellationToken = default)
    {
        const string sql = """
                           SET NOCOUNT ON;

                           SELECT
                               SCRC_NO AS CraneNo,
                               SCRC_POSBY AS PositionBay,
                               SCRC_POSLV AS PositionLevel
                           FROM dbo.T2TBSCRC WITH (NOLOCK)
                           WHERE SCRC_NO BETWEEN 1 AND 7
                           ORDER BY TRY_CONVERT(int, SCRC_NO);

                           SELECT
                               1 AS RgvNo,
                               RGV1_CH02 AS CurrentPosition
                           FROM dbo.T2TBRGV1 WITH (NOLOCK)
                           WHERE RGV1_SR = 'R'

                           UNION ALL

                           SELECT
                               2 AS RgvNo,
                               RGV2_CH02 AS CurrentPosition
                           FROM dbo.T2TBRGV2 WITH (NOLOCK)
                           WHERE RGV2_SR = 'R'
                           ORDER BY RgvNo;
                           """;

        using var connection = db.Create();
        using var results = await connection.QueryMultipleAsync(
            new CommandDefinition(sql, cancellationToken: cancellationToken));

        var cranes = (await results.ReadAsync<ScCranePositionDto>()).AsList();
        var rgvs = (await results.ReadAsync<RgvPositionDto>()).AsList();

        return new EquipmentPositionSnapshotDto
        {
            RetrievedAt = DateTimeOffset.Now,
            Cranes = cranes,
            Rgvs = rgvs
        };
    }

    public async Task<BcrToggleResultDto> ToggleBcrAsync(
        int bcrNo,
        CancellationToken cancellationToken = default)
    {
        // 사용자 값을 SQL 식별자에 직접 사용하지 않고, 허용된 4개 컬럼만 선택한다.
        var statusColumn = bcrNo switch
        {
            1 => "STAT_BCR1",
            2 => "STAT_BCR2",
            3 => "STAT_BCR3",
            4 => "STAT_BCR4",
            _ => throw new ArgumentOutOfRangeException(
                nameof(bcrNo), bcrNo, "BCR 번호는 1~4만 허용됩니다.")
        };

        var sql = $"""
                   SET NOCOUNT ON;

                   UPDATE dbo.T2TBSTAT WITH (UPDLOCK, ROWLOCK)
                   SET {statusColumn} = CASE
                                           WHEN LTRIM(RTRIM(COALESCE({statusColumn}, ''))) = '1'
                                               THEN '0'
                                           ELSE '1'
                                        END
                   OUTPUT CAST(@BcrNo AS int) AS BcrNo,
                          LTRIM(RTRIM(inserted.{statusColumn})) AS StatusCode
                   WHERE STAT_PSWD = @StatusPassword;
                   """;

        using var connection = db.Create();
        var row = await connection.QuerySingleOrDefaultAsync<BcrToggleRow>(
            new CommandDefinition(
                sql,
                new { BcrNo = bcrNo, StatusPassword },
                cancellationToken: cancellationToken));

        if (row is null)
        {
            throw new InvalidOperationException(
                "T2TBSTAT에서 시스템 상태 행(STAT_PSWD='JPLS')을 찾지 못했습니다.");
        }

        return new BcrToggleResultDto
        {
            BcrNo = row.BcrNo,
            StatusCode = row.StatusCode,
            IsEnabled = IsOn(row.StatusCode)
        };
    }

    public async Task<MonitoringTrackDetailDto?> GetTrackAsync(
        string trackNo,
        CancellationToken cancellationToken = default)
    {
        var normalizedTrackNo = NormalizeTrackNo(trackNo);
        const string sql = """
                           SELECT
                               LTRIM(RTRIM(TRAK_NO)) AS TrackNo,
                               LTRIM(RTRIM(COALESCE(TRAK_INDEX, ''))) AS [Index],
                               LTRIM(RTRIM(COALESCE(TRAK_GUBUN, ''))) AS JobType,
                               LTRIM(RTRIM(COALESCE(TRAK_LOCA, ''))) AS Location,
                               LTRIM(RTRIM(COALESCE(TRAK_WSNO, ''))) AS WorkStation,
                               LTRIM(RTRIM(COALESCE(TRAK_FROM, ''))) AS [From],
                               LTRIM(RTRIM(COALESCE(TRAK_TO, ''))) AS [To],
                               LTRIM(RTRIM(COALESCE(TRAK_FLAG, ''))) AS Flag,
                               LTRIM(RTRIM(COALESCE(TRAK_DATE, ''))) AS [Date],
                               LTRIM(RTRIM(COALESCE(TRAK_TIME, ''))) AS [Time]
                           FROM dbo.T2TBTRAK WITH (NOLOCK)
                           WHERE TRAK_NO = @TrackNo;
                           """;

        using var connection = db.Create();
        return await connection.QuerySingleOrDefaultAsync<MonitoringTrackDetailDto>(
            new CommandDefinition(
                sql,
                new { TrackNo = normalizedTrackNo },
                cancellationToken: cancellationToken));
    }

    public async Task SaveTrackAsync(
        string trackNo,
        MonitoringTrackUpdateRequest request,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);
        var normalizedTrackNo = NormalizeTrackNo(trackNo);
        var values = NormalizeTrackRequest(request);

        const string sql = """
                           SET NOCOUNT ON;

                           IF EXISTS (SELECT 1 FROM dbo.T2TBTRAK WHERE TRAK_NO = @TrackNo)
                           BEGIN
                               UPDATE dbo.T2TBTRAK
                                  SET TRAK_INDEX = @Index,
                                      TRAK_GUBUN = @JobType,
                                      TRAK_LOCA = @Location,
                                      TRAK_WSNO = @WorkStation,
                                      TRAK_FROM = @From,
                                      TRAK_TO = @To,
                                      TRAK_FLAG = @Flag,
                                      TRAK_DATE = @Date,
                                      TRAK_TIME = @Time
                                WHERE TRAK_NO = @TrackNo;
                           END
                           ELSE
                           BEGIN
                               INSERT INTO dbo.T2TBTRAK
                                   (TRAK_NO, TRAK_INDEX, TRAK_GUBUN, TRAK_LOCA,
                                    TRAK_WSNO, TRAK_FROM, TRAK_TO, TRAK_FLAG,
                                    TRAK_DATE, TRAK_TIME)
                               VALUES
                                   (@TrackNo, @Index, @JobType, @Location,
                                    @WorkStation, @From, @To, @Flag,
                                    @Date, @Time);
                           END;
                           """;

        using var connection = db.Create();
        await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new
            {
                TrackNo = normalizedTrackNo,
                values.Index,
                values.JobType,
                values.Location,
                values.WorkStation,
                values.From,
                values.To,
                values.Flag,
                values.Date,
                values.Time
            },
            cancellationToken: cancellationToken));
    }

    public async Task DeleteTrackAsync(
        string trackNo,
        CancellationToken cancellationToken = default)
    {
        var normalizedTrackNo = NormalizeTrackNo(trackNo);
        const string selectSql = """
                                 SELECT
                                     LTRIM(RTRIM(COALESCE(TRAK_INDEX, ''))) AS [Index],
                                     LTRIM(RTRIM(COALESCE(TRAK_LOCA, ''))) AS Location
                                 FROM dbo.T2TBTRAK WITH (UPDLOCK, ROWLOCK)
                                 WHERE TRAK_NO = @TrackNo;
                                 """;
        const string clearSql = """
                                UPDATE dbo.T2TBTRAK
                                   SET TRAK_INDEX = '', TRAK_GUBUN = '', TRAK_LOCA = '',
                                       TRAK_WSNO = '', TRAK_FROM = '', TRAK_TO = '',
                                       TRAK_FLAG = '', TRAK_DATE = '', TRAK_TIME = ''
                                 WHERE TRAK_NO = @TrackNo;
                                """;
        const string deleteInboundSql = """
                                        DELETE FROM dbo.T2MIINPT
                                         WHERE INPT_INDEX = @Index;
                                        """;
        const string releaseRackSql = """
                                      UPDATE dbo.T2MILSTK
                                         SET LSTK_FLAG = '0'
                                       WHERE LSTK_LOCA = @Location
                                         AND LSTK_FLAG IN ('X', 'Y', 'W', 'E');
                                      """;

        using var connection = db.Create();
        connection.Open();
        using var transaction = connection.BeginTransaction();
        try
        {
            var current = await connection.QuerySingleOrDefaultAsync<TrackDeleteRow>(
                new CommandDefinition(
                    selectSql,
                    new { TrackNo = normalizedTrackNo },
                    transaction,
                    cancellationToken: cancellationToken));

            if (current is null)
                throw new InvalidOperationException($"트래킹 {normalizedTrackNo}번을 찾지 못했습니다.");

            await connection.ExecuteAsync(new CommandDefinition(
                clearSql,
                new { TrackNo = normalizedTrackNo },
                transaction,
                cancellationToken: cancellationToken));

            if (!string.IsNullOrWhiteSpace(current.Index))
            {
                await connection.ExecuteAsync(new CommandDefinition(
                    deleteInboundSql,
                    new { current.Index },
                    transaction,
                    cancellationToken: cancellationToken));
            }

            if (IsLocation(current.Location))
            {
                await connection.ExecuteAsync(new CommandDefinition(
                    releaseRackSql,
                    new { current.Location },
                    transaction,
                    cancellationToken: cancellationToken));
            }

            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public async Task MoveTrackAsync(
        string sourceTrackNo,
        string destinationTrackNo,
        CancellationToken cancellationToken = default)
    {
        var normalizedSourceTrackNo = NormalizeTrackNo(sourceTrackNo);
        var normalizedDestinationTrackNo = NormalizeTrackNo(destinationTrackNo);

        if (normalizedSourceTrackNo == normalizedDestinationTrackNo)
            throw new ArgumentException("현재 구간과 다른 이동 대상 구간을 선택해 주세요.", nameof(destinationTrackNo));

        const string selectSql = """
                                 SELECT
                                     LTRIM(RTRIM(TRAK_NO)) AS TrackNo,
                                     LTRIM(RTRIM(COALESCE(TRAK_INDEX, ''))) AS [Index],
                                     LTRIM(RTRIM(COALESCE(TRAK_GUBUN, ''))) AS JobType,
                                     LTRIM(RTRIM(COALESCE(TRAK_LOCA, ''))) AS Location,
                                     LTRIM(RTRIM(COALESCE(TRAK_WSNO, ''))) AS WorkStation,
                                     LTRIM(RTRIM(COALESCE(TRAK_FROM, ''))) AS [From],
                                     LTRIM(RTRIM(COALESCE(TRAK_TO, ''))) AS [To],
                                     LTRIM(RTRIM(COALESCE(TRAK_FLAG, ''))) AS Flag,
                                     LTRIM(RTRIM(COALESCE(TRAK_DATE, ''))) AS [Date],
                                     LTRIM(RTRIM(COALESCE(TRAK_TIME, ''))) AS [Time]
                                 FROM dbo.T2TBTRAK WITH (UPDLOCK, HOLDLOCK)
                                 WHERE TRAK_NO IN (@SourceTrackNo, @DestinationTrackNo);
                                 """;
        const string updateDestinationSql = """
                                            UPDATE dbo.T2TBTRAK
                                               SET TRAK_INDEX = @Index,
                                                   TRAK_GUBUN = @JobType,
                                                   TRAK_LOCA = @DestinationLocation,
                                                   TRAK_WSNO = @WorkStation,
                                                   TRAK_FROM = @From,
                                                   TRAK_TO = @To,
                                                   TRAK_FLAG = @Flag,
                                                   TRAK_DATE = @Date,
                                                   TRAK_TIME = @Time
                                             WHERE TRAK_NO = @DestinationTrackNo;
                                            """;
        const string clearSourceSql = """
                                      UPDATE dbo.T2TBTRAK
                                         SET TRAK_INDEX = '', TRAK_GUBUN = '', TRAK_LOCA = '',
                                             TRAK_WSNO = '', TRAK_FROM = '', TRAK_TO = '',
                                             TRAK_FLAG = '', TRAK_DATE = '', TRAK_TIME = ''
                                       WHERE TRAK_NO = @SourceTrackNo;
                                      """;
        const string releaseRackSql = """
                                      UPDATE dbo.T2MILSTK
                                         SET LSTK_FLAG = '0'
                                       WHERE LSTK_LOCA = @Location;
                                      """;

        using var connection = db.Create();
        connection.Open();
        using var transaction = connection.BeginTransaction();
        try
        {
            var rows = (await connection.QueryAsync<TrackMoveRow>(
                    new CommandDefinition(
                        selectSql,
                        new
                        {
                            SourceTrackNo = normalizedSourceTrackNo,
                            DestinationTrackNo = normalizedDestinationTrackNo
                        },
                        transaction,
                        cancellationToken: cancellationToken)))
                .ToDictionary(row => row.TrackNo, StringComparer.Ordinal);

            if (!rows.TryGetValue(normalizedSourceTrackNo, out var source))
                throw new InvalidOperationException($"트래킹 {normalizedSourceTrackNo}번을 찾지 못했습니다.");

            if (!rows.TryGetValue(normalizedDestinationTrackNo, out var destination))
                throw new InvalidOperationException($"이동 대상 트래킹 {normalizedDestinationTrackNo}번을 찾지 못했습니다.");

            if (!HasTrackData(source))
                throw new InvalidOperationException($"트래킹 {normalizedSourceTrackNo}번에 이동할 데이터가 없습니다.");

            if (HasTrackData(destination))
            {
                throw new InvalidOperationException(
                    $"이동 대상 트래킹 {normalizedDestinationTrackNo}번에 이미 데이터가 있습니다.");
            }

            await connection.ExecuteAsync(new CommandDefinition(
                updateDestinationSql,
                new
                {
                    DestinationTrackNo = normalizedDestinationTrackNo,
                    source.Index,
                    source.JobType,
                    DestinationLocation = string.Equals(
                        source.JobType, "I", StringComparison.OrdinalIgnoreCase)
                        ? string.Empty
                        : source.Location,
                    source.WorkStation,
                    source.From,
                    source.To,
                    source.Flag,
                    source.Date,
                    source.Time
                },
                transaction,
                cancellationToken: cancellationToken));

            if (IsLocation(source.Location))
            {
                await connection.ExecuteAsync(new CommandDefinition(
                    releaseRackSql,
                    new { source.Location },
                    transaction,
                    cancellationToken: cancellationToken));
            }

            await connection.ExecuteAsync(new CommandDefinition(
                clearSourceSql,
                new { SourceTrackNo = normalizedSourceTrackNo },
                transaction,
                cancellationToken: cancellationToken));

            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public async Task<MonitoringStackerWorkDto?> GetStackerWorkAsync(
        int craneNo,
        CancellationToken cancellationToken = default)
    {
        ValidateCraneNo(craneNo);
        using var connection = db.Create();
        const string heightColumnCheckSql = """
                                                  SELECT CASE
                                                      WHEN COL_LENGTH('dbo.T2TBSCRC', 'SCRC_HIGH') IS NULL THEN 0
                                                      ELSE 1
                                                  END;
                                                  """;
        var hasHeightColumn = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(
                heightColumnCheckSql,
                cancellationToken: cancellationToken)) == 1;
        var heightProjection = hasHeightColumn
            ? "LTRIM(RTRIM(COALESCE(SCRC_HIGH, '')))"
            : "CAST('' AS varchar(1))";

        var sql = $"""
                            SELECT
                                TRY_CONVERT(int, SCRC_NO) AS CraneNo,
                               LTRIM(RTRIM(COALESCE(SCRC_CYCLE, ''))) AS Cycle,
                               LTRIM(RTRIM(COALESCE(SCRC_ONLINE, ''))) AS Online,
                               LTRIM(RTRIM(COALESCE(SCRC_READY, ''))) AS Ready,
                               LTRIM(RTRIM(COALESCE(SCRC_HOME, ''))) AS Home,
                               LTRIM(RTRIM(COALESCE(SCRC_LOCA, ''))) AS Location,
                               LTRIM(RTRIM(COALESCE(SCRC_CENTER, ''))) AS Centered,
                               LTRIM(RTRIM(COALESCE(SCRC_ACK, ''))) AS Acknowledged,
                               LTRIM(RTRIM(COALESCE(SCRC_LOAD, ''))) AS LoadComplete,
                               LTRIM(RTRIM(COALESCE(SCRC_UNLOAD, ''))) AS UnloadComplete,
                               LTRIM(RTRIM(COALESCE(SCRC_SCPLT, ''))) AS HasPallet,
                               LTRIM(RTRIM(COALESCE(SCRC_POSBY, ''))) AS PositionBay,
                               LTRIM(RTRIM(COALESCE(SCRC_POSLV, ''))) AS PositionLevel,
                               LTRIM(RTRIM(COALESCE(SCRC_ERROR, ''))) AS Error,
                                LTRIM(RTRIM(COALESCE(SCRC_INDEX, ''))) AS JobIndex,
                                LTRIM(RTRIM(COALESCE(SCRC_GUBUN, ''))) AS JobType,
                                LTRIM(RTRIM(COALESCE(SCRC_WSNO, ''))) AS WorkStation,
                                {heightProjection} AS Height,
                                LTRIM(RTRIM(COALESCE(SCRC_DESC, ''))) AS ErrorDescription,
                               LTRIM(RTRIM(COALESCE(SCRC_PLTNO, ''))) AS PalletNo
                           FROM dbo.T2TBSCRC WITH (NOLOCK)
                            WHERE TRY_CONVERT(int, SCRC_NO) = @CraneNo;
        """;

        return await connection.QuerySingleOrDefaultAsync<MonitoringStackerWorkDto>(
            new CommandDefinition(
                sql,
                new { CraneNo = craneNo },
                cancellationToken: cancellationToken));
    }

    public Task ReissueStackerAsync(
        int craneNo,
        bool hasForkPallet,
        CancellationToken cancellationToken = default) =>
        UpdateStackerAsync(craneNo, StackerAction.Reissue, hasForkPallet, cancellationToken);

    public Task CompleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken = default) =>
        UpdateStackerAsync(craneNo, StackerAction.Complete, false, cancellationToken);

    public Task ForceDeleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken = default) =>
        UpdateStackerAsync(craneNo, StackerAction.ForceDelete, false, cancellationToken);

    public Task ClearStackerErrorAsync(
        int craneNo,
        CancellationToken cancellationToken = default) =>
        UpdateStackerAsync(craneNo, StackerAction.ClearError, false, cancellationToken);

    public async Task<IReadOnlyList<MonitoringRackCellDto>> GetRackCellsAsync(
        int bank,
        CancellationToken cancellationToken = default)
    {
        ValidateBank(bank);
        const string sql = """
                           SELECT
                               LTRIM(RTRIM(LSTK_LOCA)) AS Location,
                               LTRIM(RTRIM(LSTK_BK)) AS Bank,
                               LTRIM(RTRIM(LSTK_BY)) AS Bay,
                               LTRIM(RTRIM(LSTK_LV)) AS [Level],
                               LTRIM(RTRIM(COALESCE(LSTK_FLAG, ''))) AS Flag,
                               CASE LTRIM(RTRIM(COALESCE(LSTK_FLAG, '')))
                                   WHEN '0' THEN N'빈 셀'
                                   WHEN '1' THEN N'제품 있음'
                                   WHEN 'X' THEN N'입고 예약'
                                   WHEN 'Y' THEN N'출고 예약'
                                   WHEN 'W' THEN N'이중 입고'
                                   WHEN 'D' THEN N'이중 입고'
                                   WHEN 'E' THEN N'공출고'
                                   WHEN 'N' THEN N'사용 금지'
                                   ELSE N'상태 미정'
                               END AS StatusName,
                               LTRIM(RTRIM(COALESCE(LSTK_INDATE, ''))) AS InDate,
                               LTRIM(RTRIM(COALESCE(LSTK_INTIME, ''))) AS InTime,
                               LTRIM(RTRIM(COALESCE(LSTK_PLTNO, ''))) AS PalletNo
                           FROM dbo.T2MILSTK WITH (NOLOCK)
                           WHERE TRY_CONVERT(int, LSTK_BK) = @Bank
                           ORDER BY TRY_CONVERT(int, LSTK_LV) DESC,
                                    TRY_CONVERT(int, LSTK_BY);
                           """;

        using var connection = db.Create();
        return (await connection.QueryAsync<MonitoringRackCellDto>(
            new CommandDefinition(
                sql,
                new { Bank = bank },
                cancellationToken: cancellationToken))).AsList();
    }

    public async Task<MonitoringRackCellDetailDto?> GetRackCellDetailAsync(
        string location,
        CancellationToken cancellationToken = default)
    {
        var normalizedLocation = NormalizeLocation(location);
        const string sql = """
                           SELECT
                               LTRIM(RTRIM(LSTK_LOCA)) AS Location,
                               LTRIM(RTRIM(LSTK_BK)) AS Bank,
                               LTRIM(RTRIM(LSTK_BY)) AS Bay,
                               LTRIM(RTRIM(LSTK_LV)) AS [Level],
                               LTRIM(RTRIM(COALESCE(LSTK_FLAG, ''))) AS Flag,
                               CASE LTRIM(RTRIM(COALESCE(LSTK_FLAG, '')))
                                   WHEN '0' THEN N'빈 셀'
                                   WHEN '1' THEN N'제품 있음'
                                   WHEN 'X' THEN N'입고 예약'
                                   WHEN 'Y' THEN N'출고 예약'
                                   WHEN 'W' THEN N'이중 입고'
                                   WHEN 'D' THEN N'이중 입고'
                                   WHEN 'E' THEN N'공출고'
                                   WHEN 'N' THEN N'사용 금지'
                                   ELSE N'상태 미정'
                               END AS StatusName,
                               LTRIM(RTRIM(COALESCE(LSTK_INDATE, ''))) AS InDate,
                               LTRIM(RTRIM(COALESCE(LSTK_INTIME, ''))) AS InTime,
                               LTRIM(RTRIM(COALESCE(LSTK_PLTNO, ''))) AS PalletNo
                           FROM dbo.T2MILSTK WITH (NOLOCK)
                           WHERE LSTK_LOCA = @Location;

                           SELECT
                               LTRIM(RTRIM(COALESCE(S.SUBK_FLAG, ''))) AS Flag,
                               LTRIM(RTRIM(COALESCE(S.SUBK_PLTNO, ''))) AS PalletNo,
                               LTRIM(RTRIM(COALESCE(S.SUBK_CODE, ''))) AS ItemCode,
                               LTRIM(RTRIM(COALESCE(M.MAST_NAME, ''))) AS ItemName,
                               LTRIM(RTRIM(COALESCE(S.SUBK_LOTNO, ''))) AS LotNo,
                               COALESCE(S.SUBK_WGT, 0) AS Quantity,
                               COALESCE(S.SUBK_RWGT, 0) AS ReservedQuantity,
                               LTRIM(RTRIM(COALESCE(S.SUBK_BOXNO, ''))) AS BoxNo,
                               LTRIM(RTRIM(COALESCE(S.SUBK_REMARK, ''))) AS Remark,
                               LTRIM(RTRIM(COALESCE(S.SUBK_INDATE, ''))) AS InDate,
                               LTRIM(RTRIM(COALESCE(S.SUBK_INTIME, ''))) AS InTime
                           FROM dbo.T2MISUBK AS S WITH (NOLOCK)
                           LEFT JOIN dbo.MIMAST AS M WITH (NOLOCK)
                             ON M.MAST_CODE = S.SUBK_CODE
                           WHERE S.SUBK_LOCA = @Location
                           ORDER BY S.SUBK_CODE, S.SUBK_LOTNO, S.SUBK_PLTNO;
                           """;

        using var connection = db.Create();
        using var results = await connection.QueryMultipleAsync(
            new CommandDefinition(
                sql,
                new { Location = normalizedLocation },
                cancellationToken: cancellationToken));

        var cell = await results.ReadSingleOrDefaultAsync<MonitoringRackCellDto>();
        var items = (await results.ReadAsync<MonitoringRackInventoryDto>()).AsList();
        return cell is null
            ? null
            : new MonitoringRackCellDetailDto { Cell = cell, InventoryItems = items };
    }

    private async Task UpdateStackerAsync(
        int craneNo,
        StackerAction action,
        bool hasForkPallet,
        CancellationToken cancellationToken)
    {
        ValidateCraneNo(craneNo);
        const string selectSql = """
                                 SELECT
                                     LTRIM(RTRIM(COALESCE(SCRC_CYCLE, ''))) AS Cycle,
                                     LTRIM(RTRIM(COALESCE(SCRC_LOCA, ''))) AS Location
                                 FROM dbo.T2TBSCRC WITH (UPDLOCK, ROWLOCK)
                                 WHERE TRY_CONVERT(int, SCRC_NO) = @CraneNo;
                                 """;

        using var connection = db.Create();
        connection.Open();
        using var transaction = connection.BeginTransaction();
        try
        {
            var current = await connection.QuerySingleOrDefaultAsync<StackerCommandRow>(
                new CommandDefinition(
                    selectSql,
                    new { CraneNo = craneNo },
                    transaction,
                    cancellationToken: cancellationToken))
                ?? throw new InvalidOperationException($"스태커 크레인 {craneNo}호기를 찾지 못했습니다.");

            switch (action)
            {
                case StackerAction.Reissue:
                    EnsureActiveStackerWork(current, "재지시");
                    var reissueCycle = $"{current.Cycle[0]}0";
                    const string reissueSql = """
                                              UPDATE dbo.T2TBSCRC
                                                 SET SCRC_CYCLE = @Cycle,
                                                     SCRC_ACK = '0',
                                                     SCRC_LOAD = @Load,
                                                     SCRC_UNLOAD = '0',
                                                     SCRC_ERROR = '0',
                                                     SCRC_DESC = ''
                                               WHERE TRY_CONVERT(int, SCRC_NO) = @CraneNo;
                                              """;
                    await connection.ExecuteAsync(new CommandDefinition(
                        reissueSql,
                        new { CraneNo = craneNo, Cycle = reissueCycle, Load = hasForkPallet ? "1" : "0" },
                        transaction,
                        cancellationToken: cancellationToken));
                    break;

                case StackerAction.Complete:
                    EnsureActiveStackerWork(current, "작업완료");
                    var phase = current.Cycle[1];
                    var (ack, load, unload) = phase switch
                    {
                        '0' => ("1", "1", "1"),
                        '1' => ("0", "1", "1"),
                        '2' => ("0", "0", "1"),
                        _ => throw new InvalidOperationException(
                            $"현재 진행상태({current.Cycle})에서는 작업완료 처리할 수 없습니다.")
                    };
                    const string completeSql = """
                                               UPDATE dbo.T2TBSCRC
                                                  SET SCRC_ACK = @Ack,
                                                      SCRC_LOAD = @Load,
                                                      SCRC_UNLOAD = @Unload,
                                                      SCRC_READY = '0',
                                                      SCRC_ERROR = '0',
                                                      SCRC_DESC = ''
                                                WHERE TRY_CONVERT(int, SCRC_NO) = @CraneNo;
                                               """;
                    await connection.ExecuteAsync(new CommandDefinition(
                        completeSql,
                        new { CraneNo = craneNo, Ack = ack, Load = load, Unload = unload },
                        transaction,
                        cancellationToken: cancellationToken));
                    break;

                case StackerAction.ForceDelete:
                    const string forceDeleteSql = """
                                                  UPDATE dbo.T2TBSCRC
                                                     SET SCRC_CYCLE = 'O3', SCRC_READY = '0', SCRC_LOCA = '',
                                                         SCRC_ACK = '0', SCRC_LOAD = '0', SCRC_UNLOAD = '0',
                                                         SCRC_SCPLT = '0', SCRC_ERROR = '0', SCRC_INDEX = '',
                                                         SCRC_GUBUN = '', SCRC_WSNO = '', SCRC_DESC = '',
                                                         SCRC_PLTNO = ''
                                                   WHERE TRY_CONVERT(int, SCRC_NO) = @CraneNo;
                                                  """;
                    await connection.ExecuteAsync(new CommandDefinition(
                        forceDeleteSql,
                        new { CraneNo = craneNo },
                        transaction,
                        cancellationToken: cancellationToken));

                    var tableName = $"dbo.T2TBSCC{craneNo}";
                    var prefix = $"SCC{craneNo}";
                    var clearSignalSql = $"""
                                         UPDATE {tableName}
                                            SET {prefix}_CH01 = '0000000000000000'
                                          WHERE {prefix}_SR = 'S';
                                         """;
                    await connection.ExecuteAsync(new CommandDefinition(
                        clearSignalSql,
                        transaction: transaction,
                        cancellationToken: cancellationToken));
                    break;

                case StackerAction.ClearError:
                    const string clearErrorSql = """
                                                 UPDATE dbo.T2TBSCRC
                                                    SET SCRC_ERROR = '0', SCRC_DESC = ''
                                                  WHERE TRY_CONVERT(int, SCRC_NO) = @CraneNo;
                                                 """;
                    await connection.ExecuteAsync(new CommandDefinition(
                        clearErrorSql,
                        new { CraneNo = craneNo },
                        transaction,
                        cancellationToken: cancellationToken));
                    break;

                default:
                    throw new ArgumentOutOfRangeException(nameof(action), action, null);
            }

            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    private static void EnsureActiveStackerWork(StackerCommandRow row, string actionName)
    {
        if (row.Cycle.Length < 2 || row.Cycle[1] == '3' || !IsLocation(row.Location))
        {
            throw new InvalidOperationException(
                $"현재 진행상태({row.Cycle})와 작업위치({row.Location})에서는 {actionName}할 수 없습니다.");
        }
    }

    private static MonitoringTrackUpdateRequest NormalizeTrackRequest(
        MonitoringTrackUpdateRequest request) => new()
    {
        Index = ValidateLength(request.Index, 20, "작업순번"),
        JobType = ValidateLength(request.JobType, 1, "구분"),
        Location = ValidateOptionalLocation(request.Location),
        WorkStation = ValidateLength(request.WorkStation, 1, "스테이션"),
        From = ValidateLength(request.From, 2, "FROM"),
        To = ValidateLength(request.To, 2, "TO"),
        Flag = ValidateLength(request.Flag, 1, "상태"),
        Date = ValidateDigits(request.Date, 8, "등록일자"),
        Time = ValidateDigits(request.Time, 6, "등록시간")
    };

    private static string NormalizeTrackNo(string trackNo)
    {
        if (!int.TryParse(trackNo?.Trim(), out var number) || number is < 1 or > 84)
            throw new ArgumentException("트래킹 번호는 01~84 사이여야 합니다.", nameof(trackNo));

        return number.ToString("00");
    }

    private static string NormalizeLocation(string location)
    {
        var normalized = location?.Trim() ?? string.Empty;
        if (!IsLocation(normalized))
            throw new ArgumentException("저장위치는 숫자 6자리(BBYYLL)여야 합니다.", nameof(location));
        return normalized;
    }

    private static string ValidateOptionalLocation(string value)
    {
        var normalized = value?.Trim() ?? string.Empty;
        if (normalized.Length > 0 && !IsLocation(normalized))
            throw new ArgumentException("작업위치는 비워 두거나 숫자 6자리(BBYYLL)로 입력해야 합니다.");
        return normalized;
    }

    private static string ValidateLength(string value, int maxLength, string fieldName)
    {
        var normalized = value?.Trim() ?? string.Empty;
        if (normalized.Length > maxLength)
            throw new ArgumentException($"{fieldName}은(는) 최대 {maxLength}자리입니다.");
        return normalized;
    }

    private static string ValidateDigits(string value, int length, string fieldName)
    {
        var normalized = value?.Trim() ?? string.Empty;
        if (normalized.Length > 0 &&
            (normalized.Length != length || normalized.Any(character => !char.IsDigit(character))))
        {
            throw new ArgumentException($"{fieldName}은(는) 비워 두거나 숫자 {length}자리여야 합니다.");
        }

        return normalized;
    }

    private static bool IsLocation(string? value) =>
        value?.Trim() is { Length: 6 } location && location.All(char.IsDigit);

    private static bool HasTrackData(TrackMoveRow row) =>
        !string.IsNullOrWhiteSpace(row.Index) ||
        !string.IsNullOrWhiteSpace(row.JobType) ||
        !string.IsNullOrWhiteSpace(row.Location) ||
        !string.IsNullOrWhiteSpace(row.WorkStation) ||
        !string.IsNullOrWhiteSpace(row.From) ||
        !string.IsNullOrWhiteSpace(row.To) ||
        !string.IsNullOrWhiteSpace(row.Flag) ||
        !string.IsNullOrWhiteSpace(row.Date) ||
        !string.IsNullOrWhiteSpace(row.Time);

    private static void ValidateCraneNo(int craneNo)
    {
        if (craneNo is < 1 or > 7)
            throw new ArgumentOutOfRangeException(nameof(craneNo), "스태커 크레인 호기는 1~7만 허용됩니다.");
    }

    private static void ValidateBank(int bank)
    {
        if (bank is < 1 or > 14)
            throw new ArgumentOutOfRangeException(nameof(bank), "랙 열은 1~14만 허용됩니다.");
    }

    private static Sc1CraneStatusDto MapCrane(
        int craneNo,
        CraneRow? row,
        ScSignalRow? scSignal)
    {
        var (hasError, errorCode) = ResolveCraneError(row?.ErrorCode, scSignal?.ErrorCode);
        var receiveBits = scSignal?.Ch01;

        // 송도 AS-IS와 동일하게 CH01 bit0=온라인, bit4=지령수신 대기를 사용한다.
        // 정상적인 16 BIT 원본 신호가 없을 때만 T2TBSCRC 값을 대체값으로 사용한다.
        var hasReceiveStatus = IsValidBitWord(receiveBits);
        var isOnline = hasReceiveStatus
            ? IsBitOn(receiveBits, 0)
            : IsOn(row?.Online);
        var isManual = IsBitOn(receiveBits, 2);
        var isCommandWaiting = hasReceiveStatus
            ? IsBitOn(receiveBits, 4)
            : IsOn(row?.Ready);
        var isWorking = IsBitOn(receiveBits, 5);

        if (!hasError)
        {
            errorCode = IsBitOn(receiveBits, 13) ? "공출고"
                : IsBitOn(receiveBits, 14) ? "이중격납"
                : IsBitOn(receiveBits, 15) ? "기타에러"
                : string.Empty;
            hasError = !string.IsNullOrEmpty(errorCode);
        }

        return new Sc1CraneStatusDto
        {
            CraneNo = craneNo,
            Cycle = row?.Cycle ?? string.Empty,
            IsOnline = isOnline,
            IsReady = isCommandWaiting,
            IsManual = isManual,
            IsWorking = isWorking,
            IsHome = IsOn(row?.Home),
            Location = row?.Location ?? string.Empty,
            IsForkCentered = IsOn(row?.Centered),
            IsAcknowledged = IsOn(row?.Acknowledged),
            CanLoad = IsOn(row?.Loadable),
            CanUnload = IsOn(row?.Unloadable),
            HasPallet = hasReceiveStatus
                ? IsBitOn(receiveBits, 8)
                : IsOn(row?.HasPallet),
            IsLoadingComplete = hasReceiveStatus && IsBitOn(receiveBits, 9),
            IsUnloadingComplete = hasReceiveStatus && IsBitOn(receiveBits, 10),
            PositionBay = row?.PositionBay ?? 0,
            PositionLevel = row?.PositionLevel ?? 0,
            HasError = hasError,
            ErrorCode = errorCode,
            PalletNo = row?.PalletNo ?? string.Empty,
            JobIndex = row?.JobIndex ?? string.Empty,
            JobType = row?.JobType ?? string.Empty,
            WorkStation = row?.WorkStation ?? string.Empty,
            ErrorDescription = row?.ErrorDescription ?? string.Empty
        };
    }

    private static Sc1LineModeDto MapLineMode(string? modeBits)
    {
        const int modeBitIndex = 11;

        var bits = modeBits?.Trim();
        var isOutbound = IsValidBitWord(bits) && bits![modeBitIndex] == '1';
        var code = isOutbound ? "1" : "0";
        var description = isOutbound ? "출고 모드" : "입고 모드";

        return new Sc1LineModeDto
        {
            Bank2ModeCode = code,
            Bank2ModeDescription = description,
            Bank2CanInbound = !isOutbound,
            Bank2CanOutbound = isOutbound
        };
    }

    private static Sc1BcrStatusDto MapBcr(
        BcrLayout layout,
        string? statusCode,
        TrackRow? resultTrack)
    {
        var code = statusCode?.Trim() ?? string.Empty;
        var resultCode = resultTrack?.Flag.Trim() ?? string.Empty;
        var message = BuildBcrMessage(layout.BcrNo, resultTrack);

        return new Sc1BcrStatusDto
        {
            BcrNo = layout.BcrNo,
            InstalledBank = layout.InstalledBank,
            StatusCode = code,
            IsEnabled = IsOn(code),
            IsNormal = message == "정 상",
            ResultTrackNo = layout.ResultTrackNo,
            ResultStatusCode = resultCode,
            Message = message
        };
    }

    private static string BuildBcrMessage(int bcrNo, TrackRow? row)
    {
        var index = row?.Index.Trim() ?? string.Empty;
        var flag = row?.Flag.Trim() ?? string.Empty;

        return flag switch
        {
            "2" => "리딩 에러",
            "4" => "PLT NO 정보 없음",
            "5" => $"{bcrNo} 호기 입고할 랙이 없습니다...",
            "" when !string.IsNullOrWhiteSpace(index) => "정 상",
            "" or "0" => string.Empty,
            // AS-IS도 정의되지 않은 Flag에서는 별도 문구를 표시하지 않는다.
            _ => string.Empty
        };
    }

    private static Sc1ConveyorSignalsDto MapConveyorSignals(
        IReadOnlyCollection<ConveyorSignalRow> rows,
        int controllerNo)
    {
        var receive = rows.FirstOrDefault(row =>
            row.ControllerNo == controllerNo && row.Sr == "R");
        var send = rows.FirstOrDefault(row =>
            row.ControllerNo == controllerNo && row.Sr == "S");

        return new Sc1ConveyorSignalsDto
        {
            ControllerNo = controllerNo,
            ReceiveCh01 = receive?.Ch01 ?? string.Empty,
            ReceiveCh02 = receive?.Ch02 ?? string.Empty,
            ReceiveCh03 = receive?.Ch03 ?? string.Empty,
            ReceiveCh04 = receive?.Ch04 ?? string.Empty,
            ReceiveCh05 = receive?.Ch05 ?? string.Empty,
            ReceiveCh06 = receive?.Ch06 ?? string.Empty,
            ReceiveCh07 = receive?.Ch07 ?? string.Empty,
            SendCh01 = send?.Ch01 ?? string.Empty,
            SendCh02 = send?.Ch02 ?? string.Empty,
            SendCh03 = send?.Ch03 ?? string.Empty,
            SendCh04 = send?.Ch04 ?? string.Empty,
            SendCh05 = send?.Ch05 ?? string.Empty,
            SendCh06 = send?.Ch06 ?? string.Empty,
            SendCh07 = send?.Ch07 ?? string.Empty
        };
    }

    private static Sc1RgvStatusDto MapRgv(
        IReadOnlyCollection<RgvSignalRow> rows,
        int rgvNo)
    {
        var receive = rows.FirstOrDefault(row => row.RgvNo == rgvNo && row.Sr == "R");
        var send = rows.FirstOrDefault(row => row.RgvNo == rgvNo && row.Sr == "S");
        var receiveBits = receive?.Ch01?.Trim() ?? string.Empty;
        var errorCode = receive?.Ch03?.Trim() ?? string.Empty;

        return new Sc1RgvStatusDto
        {
            RgvNo = rgvNo,
            IsSignalValid = IsValidBitWord(receiveBits),
            IsOnline = IsBitOn(receiveBits, 0),
            IsAuto = IsBitOn(receiveBits, 1),
            IsReady = IsBitOn(receiveBits, 2),
            IsAcknowledged = IsBitOn(receiveBits, 3),
            HasPallet = IsBitOn(receiveBits, 4),
            IsLoadingComplete = IsBitOn(receiveBits, 5),
            IsUnloadingComplete = IsBitOn(receiveBits, 6),
            HasError = IsBitOn(receiveBits, 7) || IsErrorCode(errorCode),
            CurrentPosition = receive?.Ch02?.Trim() ?? string.Empty,
            ErrorCode = errorCode,
            ErrorDescription = receive?.ErrorDescription?.Trim() ?? string.Empty,
            FromPosition = send?.Ch02?.Trim() ?? string.Empty,
            ToPosition = send?.Ch03?.Trim() ?? string.Empty,
            ReceiveBits = receiveBits,
            SendBits = send?.Ch01?.Trim() ?? string.Empty,
            StatusSource = $"T2TBRGV{rgvNo}.R.CH01"
        };
    }

    private static IReadOnlyList<Sc1TrackDto> MapTracks(
        IReadOnlyCollection<TrackRow> rows,
        Sc1ConveyorSignalsDto cvc1,
        Sc1ConveyorSignalsDto cvc2,
        IReadOnlyCollection<Sc1RgvStatusDto> rgvs)
    {
        var rowsByNumber = rows.ToDictionary(row => row.TrackNo, StringComparer.Ordinal);
        var rgvsByNumber = rgvs.ToDictionary(rgv => rgv.RgvNo);

        return MonitorTrackNumbers.Select(trackNo =>
        {
            rowsByNumber.TryGetValue(trackNo, out var row);
            return new Sc1TrackDto
            {
                TrackNo = trackNo,
                Index = row?.Index ?? string.Empty,
                JobType = row?.JobType ?? string.Empty,
                Location = row?.Location ?? string.Empty,
                WorkStation = row?.WorkStation ?? string.Empty,
                From = row?.From ?? string.Empty,
                To = row?.To ?? string.Empty,
                Flag = row?.Flag ?? string.Empty,
                Date = row?.Date ?? string.Empty,
                Time = row?.Time ?? string.Empty,
                HasPhysicalPallet = HasTrackPallet(
                    trackNo, cvc1, cvc2, rgvsByNumber),
                HasTrackingData = !string.IsNullOrWhiteSpace(row?.Index)
            };
        }).ToArray();
    }

    private static bool HasTrackPallet(
        string trackNo,
        Sc1ConveyorSignalsDto cvc1,
        Sc1ConveyorSignalsDto cvc2,
        IReadOnlyDictionary<int, Sc1RgvStatusDto> rgvs)
    {
        var number = ParseNumber(trackNo);

        // 25·82번은 컨베이어가 아니라 RGV 대차다. 신호가 비정상일 때도
        // 컨베이어 BIT로 우회하지 않고 해당 RGV 테이블 값만 사용한다.
        if (number == 25)
            return rgvs.TryGetValue(1, out var rgv1)
                   && rgv1.IsSignalValid
                   && rgv1.HasPallet;

        if (number == 82)
            return rgvs.TryGetValue(2, out var rgv2)
                   && rgv2.IsSignalValid
                   && rgv2.HasPallet;

        return number switch
        {
            >= 1 and <= 16 => IsBitOn(cvc1.ReceiveCh01, number - 1),
            >= 17 and <= 32 => IsBitOn(cvc1.ReceiveCh02, number - 17),
            >= 33 and <= 48 => IsBitOn(cvc1.ReceiveCh03, number - 33),
            >= 49 and <= 58 => IsBitOn(cvc1.ReceiveCh04, number - 49),
            >= 60 and <= 75 => IsBitOn(cvc2.ReceiveCh01, number - 60),
            >= 76 and <= 84 => IsBitOn(cvc2.ReceiveCh02, number - 76),
            _ => false
        };
    }

    private static Sc1InventorySummaryDto MapInventory(InventoryRow row)
    {
        var usableCells = Math.Max(0, row.TotalCells - row.ProhibitedCells);
        var occupancyRate = usableCells == 0
            ? 0m
            : Math.Round(row.UsedCells * 100m / usableCells, 1);

        return new Sc1InventorySummaryDto
        {
            CraneNo = row.CraneNo,
            TotalCells = row.TotalCells,
            UsedCells = row.UsedCells,
            EmptyCells = row.EmptyCells,
            ProhibitedCells = row.ProhibitedCells,
            AvailableCells = row.EmptyCells,
            OccupancyRate = occupancyRate
        };
    }

    private static Sc1InventorySummaryDto BuildTotalInventory(
        IReadOnlyCollection<Sc1InventorySummaryDto> summaries)
    {
        var totalCells = summaries.Sum(item => item.TotalCells);
        var usedCells = summaries.Sum(item => item.UsedCells);
        var emptyCells = summaries.Sum(item => item.EmptyCells);
        var prohibitedCells = summaries.Sum(item => item.ProhibitedCells);
        var usableCells = Math.Max(0, totalCells - prohibitedCells);

        return new Sc1InventorySummaryDto
        {
            CraneNo = 0,
            TotalCells = totalCells,
            UsedCells = usedCells,
            EmptyCells = emptyCells,
            ProhibitedCells = prohibitedCells,
            AvailableCells = summaries.Sum(item => item.AvailableCells),
            OccupancyRate = usableCells == 0
                ? 0m
                : Math.Round(usedCells * 100m / usableCells, 1)
        };
    }

    private static Sc1OutboundScheduleDto MapSchedule(ScheduleRow row) => new()
    {
        Sequence = row.Sequence,
        CraneNo = ParseNumber(row.CraneNo) is var craneNo and >= 1 and <= 7 ? craneNo : 1,
        Location = row.Location,
        WorkStation = row.WorkStation,
        IsEmergency = row.Emergency.Equals("E", StringComparison.OrdinalIgnoreCase),
        InstructionDate = row.InstructionDate,
        InstructionTime = row.InstructionTime,
        PalletNo = row.PalletNo,
        JobType = row.JobType
    };

    private static (bool HasError, string ErrorCode) ResolveCraneError(
        string? craneError,
        string? signalError)
    {
        var signalCode = signalError?.Trim() ?? string.Empty;
        var craneCode = craneError?.Trim() ?? string.Empty;

        // PLC가 전달한 4자리 에러코드를 우선하고, 없으면 SCRC 상태를 사용한다.
        if (IsErrorCode(signalCode))
        {
            return (true, signalCode);
        }

        if (IsErrorCode(craneCode))
        {
            return (true, craneCode);
        }

        return (false, !string.IsNullOrEmpty(signalCode) ? signalCode : craneCode);
    }

    private static bool IsErrorCode(string code) =>
        !string.IsNullOrWhiteSpace(code) && code.Trim('0').Length > 0;

    private static bool IsOn(string? value) => value?.Trim() == "1";

    private static bool IsBitOn(string? bits, int zeroBasedIndex) =>
        !string.IsNullOrEmpty(bits) &&
        zeroBasedIndex >= 0 &&
        zeroBasedIndex < bits.Length &&
        bits[zeroBasedIndex] == '1';

    private static bool IsValidBitWord(string? bits)
    {
        var value = bits?.Trim();
        return value is { Length: 16 } &&
               value.All(bit => bit is '0' or '1');
    }

    private static int ParseNumber(string? value) =>
        int.TryParse(value?.Trim(), out var number) ? number : 0;

    private static string[] BuildMonitorTrackNumbers() =>
        Enumerable.Range(1, 8)
            .Concat(Enumerable.Range(11, 48))
            .Concat(Enumerable.Range(60, 25))
            .Select(number => number.ToString("00"))
            .ToArray();

    private sealed record BcrLayout(int BcrNo, int InstalledBank, string ResultTrackNo);

    private sealed class CraneRow
    {
        public string CraneNo { get; set; } = string.Empty;
        public string Cycle { get; set; } = string.Empty;
        public string Online { get; set; } = string.Empty;
        public string Ready { get; set; } = string.Empty;
        public string Home { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public string Centered { get; set; } = string.Empty;
        public string Acknowledged { get; set; } = string.Empty;
        public string Loadable { get; set; } = string.Empty;
        public string Unloadable { get; set; } = string.Empty;
        public string HasPallet { get; set; } = string.Empty;
        public int? PositionBay { get; set; }
        public int? PositionLevel { get; set; }
        public string ErrorCode { get; set; } = string.Empty;
        public string PalletNo { get; set; } = string.Empty;
        public string JobIndex { get; set; } = string.Empty;
        public string JobType { get; set; } = string.Empty;
        public string WorkStation { get; set; } = string.Empty;
        public string ErrorDescription { get; set; } = string.Empty;
    }

    private sealed class SystemStatusRow
    {
        public string Sc1IoMode { get; set; } = string.Empty;
        public string Sc2IoMode { get; set; } = string.Empty;
        public string Sc3IoMode { get; set; } = string.Empty;
        public string Sc4IoMode { get; set; } = string.Empty;
        public string Sc5IoMode { get; set; } = string.Empty;
        public string Sc6IoMode { get; set; } = string.Empty;
        public string Sc7IoMode { get; set; } = string.Empty;
        public string Bcr1Status { get; set; } = string.Empty;
        public string Bcr2Status { get; set; } = string.Empty;
        public string Bcr3Status { get; set; } = string.Empty;
        public string Bcr4Status { get; set; } = string.Empty;

        public string GetBcrStatus(int bcrNo) => bcrNo switch
        {
            1 => Bcr1Status,
            2 => Bcr2Status,
            3 => Bcr3Status,
            4 => Bcr4Status,
            _ => string.Empty
        };
    }

    private sealed class ConveyorSignalRow
    {
        public int ControllerNo { get; set; }
        public string Sr { get; set; } = string.Empty;
        public string Ch01 { get; set; } = string.Empty;
        public string Ch02 { get; set; } = string.Empty;
        public string Ch03 { get; set; } = string.Empty;
        public string Ch04 { get; set; } = string.Empty;
        public string Ch05 { get; set; } = string.Empty;
        public string Ch06 { get; set; } = string.Empty;
        public string Ch07 { get; set; } = string.Empty;
    }

    private sealed class RgvSignalRow
    {
        public int RgvNo { get; set; }
        public string Sr { get; set; } = string.Empty;
        public string Ch01 { get; set; } = string.Empty;
        public string Ch02 { get; set; } = string.Empty;
        public string Ch03 { get; set; } = string.Empty;
        public string Ch04 { get; set; } = string.Empty;
        public string ErrorDescription { get; set; } = string.Empty;
    }

    private sealed class ScSignalRow
    {
        public int CraneNo { get; set; }
        public string Ch01 { get; set; } = string.Empty;
        public string ErrorCode { get; set; } = string.Empty;
    }

    private sealed class TrackRow
    {
        public string TrackNo { get; set; } = string.Empty;
        public string Index { get; set; } = string.Empty;
        public string JobType { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public string WorkStation { get; set; } = string.Empty;
        public string From { get; set; } = string.Empty;
        public string To { get; set; } = string.Empty;
        public string Flag { get; set; } = string.Empty;
        public string Date { get; set; } = string.Empty;
        public string Time { get; set; } = string.Empty;
    }

    private sealed class InventoryRow
    {
        public int CraneNo { get; set; }
        public int TotalCells { get; set; }
        public int UsedCells { get; set; }
        public int EmptyCells { get; set; }
        public int ProhibitedCells { get; set; }
    }

    private sealed class ScheduleRow
    {
        public string Sequence { get; set; } = string.Empty;
        public string CraneNo { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public string WorkStation { get; set; } = string.Empty;
        public string Emergency { get; set; } = string.Empty;
        public string InstructionDate { get; set; } = string.Empty;
        public string InstructionTime { get; set; } = string.Empty;
        public string PalletNo { get; set; } = string.Empty;
        public string JobType { get; set; } = string.Empty;
    }

    private sealed class BcrToggleRow
    {
        public int BcrNo { get; set; }
        public string StatusCode { get; set; } = string.Empty;
    }

    private sealed class TrackDeleteRow
    {
        public string Index { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
    }

    private sealed class TrackMoveRow
    {
        public string TrackNo { get; set; } = string.Empty;
        public string Index { get; set; } = string.Empty;
        public string JobType { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public string WorkStation { get; set; } = string.Empty;
        public string From { get; set; } = string.Empty;
        public string To { get; set; } = string.Empty;
        public string Flag { get; set; } = string.Empty;
        public string Date { get; set; } = string.Empty;
        public string Time { get; set; } = string.Empty;
    }

    private sealed class StackerCommandRow
    {
        public string Cycle { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
    }

    private enum StackerAction
    {
        Reissue,
        Complete,
        ForceDelete,
        ClearError
    }
}
