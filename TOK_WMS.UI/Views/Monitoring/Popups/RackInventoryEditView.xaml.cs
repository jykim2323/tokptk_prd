using System.ComponentModel;
using System.Windows;
using TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

namespace TOK.WMS.UI.Views.Monitoring.Popups;

public partial class RackInventoryEditView : Window
{
    public RackInventoryEditView(RackInventoryEditViewModel viewModel)
    {
        InitializeComponent();
        DataContext = viewModel;
        FitToWorkArea();
    }

    protected override void OnClosing(CancelEventArgs e)
    {
        if (DataContext is RackInventoryEditViewModel { IsSaving: true, IsSaved: false })
            e.Cancel = true;

        base.OnClosing(e);
    }

    private void FitToWorkArea()
    {
        const double windowMargin = 48;
        var workArea = SystemParameters.WorkArea;
        var availableWidth = Math.Max(700, workArea.Width - windowMargin);
        var availableHeight = Math.Max(500, workArea.Height - windowMargin);
        MinWidth = Math.Min(MinWidth, availableWidth);
        MinHeight = Math.Min(MinHeight, availableHeight);
        Width = Math.Min(900, availableWidth);
        Height = Math.Min(820, availableHeight);
    }
}
