using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Controls;

namespace TOK.WMS.UI.Views.MainMenus.Controls;

public partial class ScSignalView : UserControl
{
    public ScSignalView()
    {
        InitializeComponent();
    }

    private async void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is ScSignalViewModel viewModel)
            await viewModel.ActivateAsync();
    }

    private void UserControl_Unloaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is ScSignalViewModel viewModel)
            viewModel.Deactivate();
    }
}
