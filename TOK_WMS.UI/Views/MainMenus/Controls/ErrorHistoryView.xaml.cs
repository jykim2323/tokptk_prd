using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Controls;

namespace TOK.WMS.UI.Views.MainMenus.Controls;

public partial class ErrorHistoryView : UserControl
{
    public ErrorHistoryView()
    {
        InitializeComponent();
    }

    private async void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is ErrorHistoryViewModel viewModel)
            await viewModel.ActivateAsync();
    }
}
