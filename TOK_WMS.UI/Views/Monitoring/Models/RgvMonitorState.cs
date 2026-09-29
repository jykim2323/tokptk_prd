namespace TOK.WMS.UI.Views.Monitoring.Models;

/// <summary>
/// RGV 대차의 운전 상태입니다. 실제 색상은 MonitoringStyles.xaml에서 결정합니다.
/// </summary>
public enum RgvVisualState
{
    Unknown,
    Manual,
    Ready,
    Working,
    Error
}

/// <summary>
/// RGV 대차가 화면에 전달하는 위치, 상태 및 상세 정보입니다.
/// </summary>
public sealed record RgvMonitorState(
    double CanvasLeft,
    string DisplayNo,
    RgvVisualState VisualState,
    bool HasPallet,
    bool IsLoadingComplete,
    bool HasTrackingData,
    string Status,
    string ToolTip)
{
    /// <summary>
    /// PLC의 PLT 유 신호 또는 Loading 완료 신호가 켜진 동안 번호판을 PLT 탑재색으로 표시합니다.
    /// </summary>
    public bool HasLoadedPallet => HasPallet || IsLoadingComplete;
}
