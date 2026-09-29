using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Controls;

namespace TOK.WMS.UI.Views.MainMenus.Controls;

public partial class ConveyorSignalView : UserControl
{
    public ConveyorSignalView()
    {
        InitializeComponent();
    }

    private async void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is ConveyorSignalViewModel viewModel)
            await viewModel.ActivateAsync();
    }

    private void UserControl_Unloaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is ConveyorSignalViewModel viewModel)
            viewModel.Deactivate();
    }
}
