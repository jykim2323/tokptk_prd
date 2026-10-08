using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Media3D;

namespace TOK.WMS.UI.Behaviors;

/// <summary>상세 입력·작업 버튼·작업 표를 화면 폭에 맞춰 배치하고 표 높이를 유한하게 유지합니다.</summary>
public static class ResponsiveWorkLayout
{
    public static readonly DependencyProperty DetailProperty = DependencyProperty.RegisterAttached(
        "Detail", typeof(FrameworkElement), typeof(ResponsiveWorkLayout), new PropertyMetadata(null, OnLayoutPropertyChanged));
    public static readonly DependencyProperty ActionsProperty = DependencyProperty.RegisterAttached(
        "Actions", typeof(FrameworkElement), typeof(ResponsiveWorkLayout), new PropertyMetadata(null, OnLayoutPropertyChanged));
    public static readonly DependencyProperty WorkProperty = DependencyProperty.RegisterAttached(
        "Work", typeof(FrameworkElement), typeof(ResponsiveWorkLayout), new PropertyMetadata(null, OnLayoutPropertyChanged));
    public static readonly DependencyProperty DetailWidthProperty = DependencyProperty.RegisterAttached(
        "DetailWidth", typeof(double), typeof(ResponsiveWorkLayout), new PropertyMetadata(360d, OnLayoutPropertyChanged),
        value => value is double width && double.IsFinite(width) && width > 0);
    public static readonly DependencyProperty StackBelowWidthProperty = DependencyProperty.RegisterAttached(
        "StackBelowWidth", typeof(double), typeof(ResponsiveWorkLayout), new PropertyMetadata(1000d, OnLayoutPropertyChanged));
    private static readonly DependencyProperty StateProperty = DependencyProperty.RegisterAttached(
        "State", typeof(LayoutState), typeof(ResponsiveWorkLayout), new PropertyMetadata(null));

    public static FrameworkElement? GetDetail(DependencyObject element) => (FrameworkElement?)element.GetValue(DetailProperty);
    public static void SetDetail(DependencyObject element, FrameworkElement? value) => element.SetValue(DetailProperty, value);
    public static FrameworkElement? GetActions(DependencyObject element) => (FrameworkElement?)element.GetValue(ActionsProperty);
    public static void SetActions(DependencyObject element, FrameworkElement? value) => element.SetValue(ActionsProperty, value);
    public static FrameworkElement? GetWork(DependencyObject element) => (FrameworkElement?)element.GetValue(WorkProperty);
    public static void SetWork(DependencyObject element, FrameworkElement? value) => element.SetValue(WorkProperty, value);
    public static double GetDetailWidth(DependencyObject element) => (double)element.GetValue(DetailWidthProperty);
    public static void SetDetailWidth(DependencyObject element, double value) => element.SetValue(DetailWidthProperty, value);
    public static double GetStackBelowWidth(DependencyObject element) => (double)element.GetValue(StackBelowWidthProperty);
    public static void SetStackBelowWidth(DependencyObject element, double value) => element.SetValue(StackBelowWidthProperty, value);

    private static void OnLayoutPropertyChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
    {
        if (element is not Grid grid)
            return;
        if (grid.GetValue(StateProperty) is not LayoutState state)
        {
            state = new LayoutState(grid);
            grid.SetValue(StateProperty, state);
        }
        state.Update();
    }

    private sealed class LayoutState
    {
        private readonly Grid _grid;
        private ScrollViewer? _scrollViewer;
        private ElementState? _detail;
        private ElementState? _actions;
        private ElementState? _work;
        private StackPanel? _actionPanel;
        private Orientation _originalOrientation;
        private HorizontalAlignment _originalHorizontalAlignment;
        private VerticalAlignment _originalVerticalAlignment;
        private readonly Dictionary<FrameworkElement, Thickness> _buttonMargins = [];
        private bool _updating;
        private bool _awaitingFirstLayout;

        public LayoutState(Grid grid)
        {
            _grid = grid;
            _grid.SizeChanged += OnSizeChanged;
            _grid.Unloaded += OnUnloaded;
            AwaitFirstLayout();
        }

        private void OnSizeChanged(object sender, SizeChangedEventArgs e) => Update();
        private void OnScrollChanged(object sender, ScrollChangedEventArgs e)
        {
            if (ReferenceEquals(e.OriginalSource, _scrollViewer))
                Update();
        }
        private void OnFirstLayout(object? sender, EventArgs e) => Update();
        private void OnUnloaded(object sender, RoutedEventArgs e)
        {
            SetScrollViewer(null);
            AwaitFirstLayout();
        }

        private void AwaitFirstLayout()
        {
            if (_awaitingFirstLayout)
                return;
            _awaitingFirstLayout = true;
            _grid.LayoutUpdated += OnFirstLayout;
        }

        private void FinishFirstLayout()
        {
            if (!_awaitingFirstLayout)
                return;
            _awaitingFirstLayout = false;
            _grid.LayoutUpdated -= OnFirstLayout;
        }

        public void Update()
        {
            if (_updating)
                return;
            var detail = GetDetail(_grid);
            var actions = GetActions(_grid);
            var work = GetWork(_grid);
            if (detail is null || actions is null || work is null)
                return;

            _updating = true;
            try
            {
                CaptureElements(detail, actions, work);
                SetScrollViewer(FindScrollViewer(_grid));
                var width = _scrollViewer is { ViewportWidth: > 0 } ? _scrollViewer.ViewportWidth : _grid.ActualWidth;
                if (!double.IsFinite(width) || width <= 0)
                    return;

                var breakpoint = GetStackBelowWidth(_grid);
                if (!double.IsFinite(breakpoint) || breakpoint <= 0)
                    breakpoint = 1000;
                var stacked = width < breakpoint;
                EnsureDefinitions();
                SetColumnWidth(0, stacked ? new GridLength(1, GridUnitType.Star) : new GridLength(GetDetailWidth(_grid)));
                SetColumnWidth(1, new GridLength(stacked ? 0 : 106));
                SetColumnWidth(2, stacked ? new GridLength(0) : new GridLength(1, GridUnitType.Star));
                for (var row = 0; row < 3; row++)
                    SetRowHeight(row, stacked ? GridLength.Auto : row == 0 ? new GridLength(1, GridUnitType.Star) : new GridLength(0));

                Place(detail, stacked ? 0 : 0, 0, stacked ? 3 : 1);
                Place(actions, stacked ? 1 : 0, stacked ? 0 : 1, stacked ? 3 : 1);
                Place(work, stacked ? 2 : 0, stacked ? 0 : 2, stacked ? 3 : 1);
                SetHeight(detail, stacked ? 300 : double.NaN);
                SetHeight(actions, double.NaN);
                SetHeight(work, stacked ? 320 : double.NaN);
                SetMargin(detail, stacked ? new Thickness(0, 0, 0, 12) : _detail!.Margin);
                SetMargin(actions, stacked ? new Thickness(0, 0, 0, 12) : _actions!.Margin);
                SetMargin(work, stacked ? new Thickness(0) : _work!.Margin);
                ArrangeActions(stacked);

                var viewportHeight = _scrollViewer?.ViewportHeight ?? 0;
                if (stacked)
                    SetHeight(_grid, double.NaN);
                else if (double.IsFinite(viewportHeight) && viewportHeight > 0)
                    SetHeight(_grid, Math.Max(1, viewportHeight - _grid.Margin.Top - _grid.Margin.Bottom));

                if (_scrollViewer is not null && (stacked || double.IsFinite(viewportHeight) && viewportHeight > 0))
                    FinishFirstLayout();
            }
            finally
            {
                _updating = false;
            }
        }

        private void CaptureElements(FrameworkElement detail, FrameworkElement actions, FrameworkElement work)
        {
            if (!ReferenceEquals(_detail?.Element, detail))
                _detail = new(detail, detail.Margin);
            if (!ReferenceEquals(_work?.Element, work))
                _work = new(work, work.Margin);
            if (ReferenceEquals(_actions?.Element, actions))
                return;
            _actions = new(actions, actions.Margin);
            _actionPanel = actions as StackPanel ?? (actions as Border)?.Child as StackPanel;
            _buttonMargins.Clear();
            if (_actionPanel is null)
                return;
            _originalOrientation = _actionPanel.Orientation;
            _originalHorizontalAlignment = _actionPanel.HorizontalAlignment;
            _originalVerticalAlignment = _actionPanel.VerticalAlignment;
            foreach (var child in _actionPanel.Children.OfType<FrameworkElement>())
                _buttonMargins[child] = child.Margin;
        }

        private void ArrangeActions(bool stacked)
        {
            if (_actionPanel is null)
                return;
            var orientation = stacked ? Orientation.Horizontal : _originalOrientation;
            var horizontal = stacked ? HorizontalAlignment.Center : _originalHorizontalAlignment;
            var vertical = stacked ? VerticalAlignment.Center : _originalVerticalAlignment;
            if (_actionPanel.Orientation != orientation) _actionPanel.Orientation = orientation;
            if (_actionPanel.HorizontalAlignment != horizontal) _actionPanel.HorizontalAlignment = horizontal;
            if (_actionPanel.VerticalAlignment != vertical) _actionPanel.VerticalAlignment = vertical;
            var children = _actionPanel.Children.OfType<FrameworkElement>().ToArray();
            for (var index = 0; index < children.Length; index++)
            {
                var child = children[index];
                if (!_buttonMargins.ContainsKey(child))
                    _buttonMargins[child] = child.Margin;
                SetMargin(child, stacked ? new Thickness(0, 0, index < children.Length - 1 ? 8 : 0, 0) : _buttonMargins[child]);
            }
        }

        private void SetScrollViewer(ScrollViewer? viewer)
        {
            if (ReferenceEquals(_scrollViewer, viewer))
                return;
            if (_scrollViewer is not null)
                _scrollViewer.ScrollChanged -= OnScrollChanged;
            _scrollViewer = viewer;
            if (_scrollViewer is not null)
                _scrollViewer.ScrollChanged += OnScrollChanged;
        }

        private void EnsureDefinitions()
        {
            while (_grid.RowDefinitions.Count < 3) _grid.RowDefinitions.Add(new RowDefinition());
            while (_grid.ColumnDefinitions.Count < 3) _grid.ColumnDefinitions.Add(new ColumnDefinition());
        }
        private void SetColumnWidth(int column, GridLength width)
        {
            if (_grid.ColumnDefinitions[column].Width != width) _grid.ColumnDefinitions[column].Width = width;
        }
        private void SetRowHeight(int row, GridLength height)
        {
            if (_grid.RowDefinitions[row].Height != height) _grid.RowDefinitions[row].Height = height;
        }
    }

    private static void Place(FrameworkElement element, int row, int column, int span)
    {
        if (Grid.GetRow(element) != row) Grid.SetRow(element, row);
        if (Grid.GetColumn(element) != column) Grid.SetColumn(element, column);
        if (Grid.GetColumnSpan(element) != span) Grid.SetColumnSpan(element, span);
    }
    private static void SetHeight(FrameworkElement element, double height)
    {
        if (!element.Height.Equals(height)) element.Height = height;
    }
    private static void SetMargin(FrameworkElement element, Thickness margin)
    {
        if (element.Margin != margin) element.Margin = margin;
    }
    private static ScrollViewer? FindScrollViewer(DependencyObject element)
    {
        var current = element;
        while (true)
        {
            var parent = current is Visual or Visual3D ? VisualTreeHelper.GetParent(current) : null;
            parent ??= (current as FrameworkElement)?.Parent ?? LogicalTreeHelper.GetParent(current);
            if (parent is null || ReferenceEquals(parent, current)) return null;
            if (parent is ScrollViewer viewer) return viewer;
            current = parent;
        }
    }
    private sealed record ElementState(FrameworkElement Element, Thickness Margin);
}
