using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Media;
using TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

namespace TOK.WMS.UI.Views.MainMenus.Inbounds;

/// <summary>
/// Frm3300View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class Frm3300View : UserControl
{
    private DataGridRowsPresenter? _rowsPresenter;
    private bool _headerIsStacked;

    public Frm3300View()
    {
        InitializeComponent();
    }
    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is Frm3300ViewModel vm)
            _ = vm.SearchCommand.ExecuteAsync(null);
    }

    private void HeaderGrid_SizeChanged(object sender, SizeChangedEventArgs e)
    {
        // 좁은 화면에서는 도구 모음을 다음 줄에 배치해 제목을 가리지 않게 한다.
        var isStacked = e.NewSize.Width < 800;
        if (_headerIsStacked == isStacked)
            return;

        _headerIsStacked = isStacked;
        Grid.SetRow(ToolbarPanel, isStacked ? 1 : 0);
        Grid.SetColumn(ToolbarPanel, isStacked ? 0 : 1);
        Grid.SetColumnSpan(ToolbarPanel, isStacked ? 2 : 1);
        ToolbarPanel.Margin = isStacked ? new Thickness(0, 12, 0, 0) : new Thickness(0);
    }


    private void DataGrid_LoadingRow(object sender, DataGridRowEventArgs e)
    {
        UpdateRowNumber(e.Row);
    }

    private void DataGrid_LayoutUpdated(object? sender, EventArgs e)
    {
        // LayoutUpdated의 sender는 null일 수 있으므로 실제 그리드를 사용한다.
        if (_rowsPresenter is null || !_rowsPresenter.IsDescendantOf(MimastDB_Table))
            _rowsPresenter = FindRowsPresenter(MimastDB_Table);

        if (_rowsPresenter is null)
            return;

        var childCount = VisualTreeHelper.GetChildrenCount(_rowsPresenter);
        for (var i = 0; i < childCount; i++)
        {
            if (VisualTreeHelper.GetChild(_rowsPresenter, i) is DataGridRow row)
                UpdateRowNumber(row);
        }
    }

    private static DataGridRowsPresenter? FindRowsPresenter(DependencyObject parent)
    {
        var childCount = VisualTreeHelper.GetChildrenCount(parent);
        for (var i = 0; i < childCount; i++)
        {
            var child = VisualTreeHelper.GetChild(parent, i);
            if (child is DataGridRowsPresenter presenter)
                return presenter;

            if (FindRowsPresenter(child) is { } descendant)
                return descendant;
        }

        return null;
    }

    private static void UpdateRowNumber(DataGridRow row)
    {
        var index = row.GetIndex();
        if (index < 0)
            return;

        var number = index + 1;
        if (row.Header is not int current || current != number)
            row.Header = number;
    }
}
