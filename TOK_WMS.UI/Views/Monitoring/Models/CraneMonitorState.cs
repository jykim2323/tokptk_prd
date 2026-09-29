using System.Windows.Media;

namespace TOK.WMS.UI.Views.Monitoring.Models;

/// <summary>
/// 창고 배치도에 표시할 스태커 크레인의 위치와 운전 상태입니다.
/// </summary>
public sealed record CraneMonitorState(
    double CanvasTop,
    Brush Background,
    bool HasPallet,
    bool IsLoadingComplete,
    string Status,
    string ToolTip)
{
    /// <summary>
    /// PLC의 PLT 유 신호 또는 Loading 완료 신호가 켜진 동안 캐리지에 PLT가
    /// 올라온 상태로 표시합니다. Loading 완료 펄스와 PLT 유지 신호를 모두 수용합니다.
    /// </summary>
    public bool HasLoadedPallet => HasPallet || IsLoadingComplete;
}
