using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace TOK.WMS.UI.Behaviors;

/// <summary>여러 업무 패널을 좁은 창에서는 세로로 배치하고, 목록의 표시 높이를 유한하게 유지합니다.</summary>
public static class AdaptiveColumns
{
    public static readonly DependencyProperty EnabledProperty = DependencyProperty.RegisterAttached(
        "Enabled", typeof(bool), typeof(AdaptiveColumns), new PropertyMetadata(false, OnChanged));
    public static readonly DependencyProperty StackBelowWidthProperty = DependencyProperty.RegisterAttached(
        "StackBelowWidth", typeof(double), typeof(AdaptiveColumns), new PropertyMetadata(1100d, OnChanged));
    public static readonly DependencyProperty StackedItemHeightProperty = DependencyProperty.RegisterAttached(
        "StackedItemHeight", typeof(double), typeof(AdaptiveColumns), new PropertyMetadata(420d, OnChanged),
        value => value is double height && double.IsFinite(height) && height > 0);
    private static readonly DependencyProperty StateProperty = DependencyProperty.RegisterAttached(
        "State", typeof(LayoutState), typeof(AdaptiveColumns));

    public static bool GetEnabled(DependencyObject element) => (bool)element.GetValue(EnabledProperty);
    public static void SetEnabled(DependencyObject element, bool value) => element.SetValue(EnabledProperty, value);
    public static double GetStackBelowWidth(DependencyObject element) => (double)element.GetValue(StackBelowWidthProperty);
    public static void SetStackBelowWidth(DependencyObject element, double value) => element.SetValue(StackBelowWidthProperty, value);
    public static double GetStackedItemHeight(DependencyObject element) => (double)element.GetValue(StackedItemHeightProperty);
    public static void SetStackedItemHeight(DependencyObject element, double value) => element.SetValue(StackedItemHeightProperty, value);

    private static void OnChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
    {
        if (element is not Grid grid) return;
        if (grid.GetValue(StateProperty) is not LayoutState state)
        {
            if (!GetEnabled(grid)) return;
            state = new LayoutState(grid);
            grid.SetValue(StateProperty, state);
        }
        state.Update();
    }

    private sealed class LayoutState
    {
        private readonly Grid _grid;
        private GridLength[]? _columns;
        private PanelPosition[]? _panels;
        private ScrollViewer? _viewer;
        private bool _updating;

        public LayoutState(Grid grid)
        {
            _grid = grid;
            grid.SizeChanged += (_, _) => Update();
            grid.Loaded += (_, _) => Update();
            grid.Unloaded += (_, _) => AttachViewer(null);
        }

        private void AttachViewer(ScrollViewer? viewer)
        {
            if (ReferenceEquals(viewer, _viewer)) return;
            if (_viewer is not null) _viewer.ScrollChanged -= OnScrollChanged;
            _viewer = viewer;
            if (_viewer is not null) _viewer.ScrollChanged += OnScrollChanged;
        }

        private void OnScrollChanged(object sender, ScrollChangedEventArgs e)
        {
            if (ReferenceEquals(e.OriginalSource, _viewer)) Update();
        }

        public void Update()
        {
            if (_updating || !GetEnabled(_grid) || _grid.ActualWidth <= 0) return;
            _updating = true;
            try
            {
                _columns ??= _grid.ColumnDefinitions.Select(column => column.Width).ToArray();
                _panels ??= _grid.Children.OfType<FrameworkElement>().Select(element => new PanelPosition(
                    element, Grid.GetColumn(element), Grid.GetColumnSpan(element), element.Margin)).ToArray();
                if (_columns.Length == 0 || _panels.Length == 0) return;
                DependencyObject? parent = VisualTreeHelper.GetParent(_grid);
                while (parent is not null && parent is not ScrollViewer) parent = VisualTreeHelper.GetParent(parent);
                AttachViewer(parent as ScrollViewer);
                var width = _viewer is { ViewportWidth: > 0 } ? _viewer.ViewportWidth : _grid.ActualWidth;
                var stacked = width < GetStackBelowWidth(_grid);
                while (_grid.RowDefinitions.Count < _panels.Length) _grid.RowDefinitions.Add(new RowDefinition());
                for (var index = 0; index < _columns.Length; index++)
                {
                    var desired = stacked ? new GridLength(index == 0 ? 1 : 0, index == 0 ? GridUnitType.Star : GridUnitType.Pixel) : _columns[index];
                    if (_grid.ColumnDefinitions[index].Width != desired) _grid.ColumnDefinitions[index].Width = desired;
                }
                for (var index = 0; index < _panels.Length; index++)
                {
                    var panel = _panels[index];
                    var desired = stacked ? new GridLength(GetStackedItemHeight(_grid)) : index == 0 ? new GridLength(1, GridUnitType.Star) : new GridLength(0);
                    if (_grid.RowDefinitions[index].Height != desired) _grid.RowDefinitions[index].Height = desired;
                    Grid.SetRow(panel.Element, stacked ? index : 0);
                    Grid.SetColumn(panel.Element, stacked ? 0 : panel.Column);
                    Grid.SetColumnSpan(panel.Element, stacked ? _columns.Length : panel.Span);
                    var margin = stacked ? new Thickness(0, 0, 0, index < _panels.Length - 1 ? 12 : 0) : panel.Margin;
                    if (panel.Element.Margin != margin) panel.Element.Margin = margin;
                }
                var height = stacked ? _panels.Length * GetStackedItemHeight(_grid) : _viewer?.ViewportHeight ?? 0;
                if (height > 0 && double.IsFinite(height) && !_grid.Height.Equals(height)) _grid.Height = height;
            }
            finally { _updating = false; }
        }
    }

    private sealed record PanelPosition(FrameworkElement Element, int Column, int Span, Thickness Margin);
}
