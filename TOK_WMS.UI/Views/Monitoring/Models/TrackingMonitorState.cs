namespace TOK.WMS.UI.Views.Monitoring.Models;

/// <summary>
/// 트래킹 구간의 업무 상태입니다. 실제 표시 색상은 MonitoringStyles.xaml에서 결정합니다.
/// </summary>
public enum TrackingVisualState
{
    Unknown,
    Empty,
    PalletOnly,
    DataOnly,
    PalletAndData
}

/// <summary>
/// 트래킹 구간이 화면에 전달하는 상태와 설명입니다.
/// </summary>
public sealed record TrackingMonitorState(
    TrackingVisualState VisualState,
    string Status,
    string ToolTip);
