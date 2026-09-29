namespace TOK.WMS.UI.Configuration;

/// <summary>UI 런타임 설정. URL·허브경로·폴링주기 등 하드코딩을 코드 밖으로 모은다.</summary>
public class UiSettings
{
    public string ApiBaseUrl { get; init; } = "http://localhost:5216";
    public string MonitorHubPath { get; init; } = "/hubs/monitor";

    // 폴링 주기 (밀리초)
    public int MonitorPollMs { get; init; } = 3000;
    public int PositionPollMs { get; init; } = 200;
    public int MenusPollMs { get; init; } = 4000;
    public int RackPollMs { get; init; } = 3000;
    public int SignalPollMs { get; init; } = 2000;

    /// <summary>UI 시작 시 Api exe 자동 실행 여부</summary>
    public bool AutoStartApi { get; init; } = false;
    /// <summary>Api exe 경로 (UI exe 기준 상대경로 가능)</summary>
    public string ApiExePath { get; init; } = @"..\Api\TOK.WMS.Api.exe";
}
