using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Controls;

namespace TOK.WMS.UI.Views.MainMenus.Controls;

public partial class SystemOperationView : UserControl
{
    public SystemOperationView()
    {
        InitializeComponent();
    }

    private async void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is SystemOperationViewModel viewModel)
            await viewModel.ActivateAsync();
    }
}
