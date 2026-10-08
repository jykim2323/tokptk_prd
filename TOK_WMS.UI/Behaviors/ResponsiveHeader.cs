using System.Windows;
using System.Windows.Controls;

namespace TOK.WMS.UI.Behaviors;

/// <summary>좁은 화면에서는 제목 아래로 도구 모음을 배치합니다.</summary>
public static class ResponsiveHeader
{
    public static readonly DependencyProperty ToolbarProperty = DependencyProperty.RegisterAttached(
        "Toolbar", typeof(FrameworkElement), typeof(ResponsiveHeader),
        new PropertyMetadata(null, OnToolbarChanged));

    public static FrameworkElement? GetToolbar(DependencyObject element) =>
        (FrameworkElement?)element.GetValue(ToolbarProperty);

    public static void SetToolbar(DependencyObject element, FrameworkElement? value) =>
        element.SetValue(ToolbarProperty, value);

    public static readonly DependencyProperty StackBelowWidthProperty = DependencyProperty.RegisterAttached(
        "StackBelowWidth", typeof(double), typeof(ResponsiveHeader),
        new PropertyMetadata(800d, OnBreakpointChanged));

    public static double GetStackBelowWidth(DependencyObject element) =>
        (double)element.GetValue(StackBelowWidthProperty);

    public static void SetStackBelowWidth(DependencyObject element, double value) =>
        element.SetValue(StackBelowWidthProperty, value);

    private static void OnToolbarChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
    {
        if (element is not Grid header) return;
        header.SizeChanged -= Header_SizeChanged;
        if (e.NewValue is FrameworkElement)
            header.SizeChanged += Header_SizeChanged;
        Update(header);
    }

    private static void OnBreakpointChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
    {
        if (element is Grid header) Update(header);
    }

    private static void Header_SizeChanged(object sender, SizeChangedEventArgs e) => Update((Grid)sender);

    private static void Update(Grid header)
    {
        if (GetToolbar(header) is not FrameworkElement toolbar || header.ActualWidth <= 0) return;
        var stacked = header.ActualWidth < GetStackBelowWidth(header);
        Grid.SetRow(toolbar, stacked ? 1 : 0);
        Grid.SetColumn(toolbar, stacked ? 0 : 1);
        Grid.SetColumnSpan(toolbar, stacked ? 2 : 1);
        toolbar.Margin = new Thickness(0, stacked ? 12 : 0, 0, 0);
    }
}
