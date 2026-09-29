using System.Windows;
using System.Windows.Input;
using TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

namespace TOK.WMS.UI.Views.Monitoring.Popups;

public partial class RackOverviewView : Window
{
    private readonly RackOverviewViewModel _viewModel;

    public RackOverviewView(RackOverviewViewModel viewModel)
    {
        InitializeComponent();
        FitToWorkArea();
        _viewModel = viewModel;
        DataContext = viewModel;
    }

    public void Initialize(int bank, int selectedBay) =>
        _viewModel.Initialize(bank, selectedBay);

    private void FitToWorkArea()
    {
        const double windowMargin = 48;
        var workArea = SystemParameters.WorkArea;
        var availableWidth = Math.Max(760, workArea.Width - windowMargin);
        var availableHeight = Math.Max(560, workArea.Height - windowMargin);

        MinWidth = Math.Min(MinWidth, availableWidth);
        MinHeight = Math.Min(MinHeight, availableHeight);
        Width = Math.Min(1460, availableWidth);
        Height = Math.Min(880, availableHeight);
    }

    private void RackCell_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    {
        if (e.ClickCount != 2)
            return;

        if (sender is not FrameworkElement { DataContext: RackCellTile tile }
            || DataContext is not RackOverviewViewModel viewModel
            || !viewModel.OpenCellCommand.CanExecute(tile))
        {
            return;
        }

        viewModel.OpenCellCommand.Execute(tile);
        e.Handled = true;
    }
}
