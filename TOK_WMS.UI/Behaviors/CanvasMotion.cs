using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Animation;

namespace TOK.WMS.UI.Behaviors;

/// <summary>
/// Canvas 좌표 바인딩 값이 바뀔 때 설비를 목표 위치까지 선형 이동시킵니다.
/// 평택 AS-IS 이동 방식을 WPF 애니메이션으로 옮기되,
/// 위치 신호 주기에 맞춰 속도와 최소 이동시간을 조절할 수 있습니다.
/// </summary>
public static class CanvasMotion
{
    private const double DefaultPixelsPerSecond = 120d;
    private const double DefaultMinimumTravelTimeMs = 220d;
    private const double SnapTolerance = 3d;

    public static readonly DependencyProperty TargetTopProperty =
        DependencyProperty.RegisterAttached(
            "TargetTop",
            typeof(double),
            typeof(CanvasMotion),
            new FrameworkPropertyMetadata(double.NaN, OnTargetTopChanged));

    public static readonly DependencyProperty TargetLeftProperty =
        DependencyProperty.RegisterAttached(
            "TargetLeft",
            typeof(double),
            typeof(CanvasMotion),
            new FrameworkPropertyMetadata(double.NaN, OnTargetLeftChanged));

    public static readonly DependencyProperty PixelsPerSecondProperty =
        DependencyProperty.RegisterAttached(
            "PixelsPerSecond",
            typeof(double),
            typeof(CanvasMotion),
            new FrameworkPropertyMetadata(
                DefaultPixelsPerSecond,
                FrameworkPropertyMetadataOptions.Inherits));

    public static readonly DependencyProperty MinimumTravelTimeMsProperty =
        DependencyProperty.RegisterAttached(
            "MinimumTravelTimeMs",
            typeof(double),
            typeof(CanvasMotion),
            new FrameworkPropertyMetadata(
                DefaultMinimumTravelTimeMs,
                FrameworkPropertyMetadataOptions.Inherits));

    private static readonly DependencyProperty IsTopInitializedProperty =
        DependencyProperty.RegisterAttached(
            "IsTopInitialized",
            typeof(bool),
            typeof(CanvasMotion),
            new PropertyMetadata(false));

    private static readonly DependencyProperty IsLeftInitializedProperty =
        DependencyProperty.RegisterAttached(
            "IsLeftInitialized",
            typeof(bool),
            typeof(CanvasMotion),
            new PropertyMetadata(false));

    public static double GetTargetTop(DependencyObject element) =>
        (double)element.GetValue(TargetTopProperty);

    public static void SetTargetTop(DependencyObject element, double value) =>
        element.SetValue(TargetTopProperty, value);

    public static double GetTargetLeft(DependencyObject element) =>
        (double)element.GetValue(TargetLeftProperty);

    public static void SetTargetLeft(DependencyObject element, double value) =>
        element.SetValue(TargetLeftProperty, value);

    public static double GetPixelsPerSecond(DependencyObject element) =>
        (double)element.GetValue(PixelsPerSecondProperty);

    public static void SetPixelsPerSecond(DependencyObject element, double value) =>
        element.SetValue(PixelsPerSecondProperty, value);

    public static double GetMinimumTravelTimeMs(DependencyObject element) =>
        (double)element.GetValue(MinimumTravelTimeMsProperty);

    public static void SetMinimumTravelTimeMs(DependencyObject element, double value) =>
        element.SetValue(MinimumTravelTimeMsProperty, value);

    private static void OnTargetTopChanged(
        DependencyObject dependencyObject,
        DependencyPropertyChangedEventArgs e)
    {
        if (dependencyObject is FrameworkElement element && e.NewValue is double target)
        {
            AnimateCoordinate(
                element,
                Canvas.TopProperty,
                IsTopInitializedProperty,
                target);
        }
    }

    private static void OnTargetLeftChanged(
        DependencyObject dependencyObject,
        DependencyPropertyChangedEventArgs e)
    {
        if (dependencyObject is FrameworkElement element && e.NewValue is double target)
        {
            AnimateCoordinate(
                element,
                Canvas.LeftProperty,
                IsLeftInitializedProperty,
                target);
        }
    }

    private static void AnimateCoordinate(
        FrameworkElement element,
        DependencyProperty coordinateProperty,
        DependencyProperty initializedProperty,
        double target)
    {
        if (!double.IsFinite(target))
            return;

        var isInitialized = (bool)element.GetValue(initializedProperty);
        var current = (double)element.GetValue(coordinateProperty);

        // 최초 위치와 아직 화면에 올라오기 전의 위치는 애니메이션 없이 바로 맞춘다.
        if (!isInitialized || !element.IsLoaded || !double.IsFinite(current))
        {
            element.BeginAnimation(coordinateProperty, null);
            element.SetValue(coordinateProperty, target);
            element.SetValue(initializedProperty, true);
            return;
        }

        var distance = Math.Abs(target - current);
        if (distance <= SnapTolerance)
        {
            element.BeginAnimation(coordinateProperty, null);
            element.SetValue(coordinateProperty, target);
            return;
        }

        var speed = Math.Max(1d, GetPixelsPerSecond(element));
        var minimumTravelTime = TimeSpan.FromMilliseconds(
            Math.Max(80d, GetMinimumTravelTimeMs(element)));
        var calculatedTravelTime = TimeSpan.FromSeconds(distance / speed);
        var duration = new Duration(
            calculatedTravelTime < minimumTravelTime
                ? minimumTravelTime
                : calculatedTravelTime);

        // 실제 바탕값은 먼저 목표 좌표로 두고, 화면에 보이는 값만 현재 위치부터 보간한다.
        // 새 위치가 도착하면 진행 중인 애니메이션을 현재 지점에서 즉시 교체할 수 있다.
        element.SetValue(coordinateProperty, target);
        element.BeginAnimation(
            coordinateProperty,
            new DoubleAnimation
            {
                From = current,
                To = target,
                Duration = duration,
                FillBehavior = FillBehavior.Stop
            },
            HandoffBehavior.SnapshotAndReplace);
    }
}
