using System.Windows;
using System.Windows.Media;

namespace TOK.WMS.UI.Views.Monitoring.Models;

/// <summary>
/// 모니터링 도면 위 단일 설비 또는 트래킹 지점의 화면 표시 상태입니다.
/// </summary>
public sealed record MonitorPointState(
    Brush Background,
    string Status,
    string ToolTip,
    double Opacity = 1d,
    Visibility Visibility = Visibility.Visible,
    Brush? Foreground = null);
