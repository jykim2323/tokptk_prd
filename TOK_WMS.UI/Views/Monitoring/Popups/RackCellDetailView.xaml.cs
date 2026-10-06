using System.Windows;
using System.ComponentModel;
using TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

namespace TOK.WMS.UI.Views.Monitoring.Popups;

public partial class RackCellDetailView : Window
{
    private readonly RackCellDetailViewModel _viewModel;

    public RackCellDetailView(RackCellDetailViewModel viewModel)
    {
        InitializeComponent();
        _viewModel = viewModel;
        DataContext = viewModel;
    }

    public void Initialize(string location) => _viewModel.Initialize(location);

    protected override void OnClosing(CancelEventArgs e)
    {
        base.OnClosing(e);
        if (_viewModel.IsMutating)
            e.Cancel = true;
    }
}
