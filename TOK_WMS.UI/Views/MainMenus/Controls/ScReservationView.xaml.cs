using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Controls;

namespace TOK.WMS.UI.Views.MainMenus.Controls;

public partial class ScReservationView : UserControl
{
    public ScReservationView()
    {
        InitializeComponent();
    }

    private async void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is ScReservationViewModel viewModel)
            await viewModel.ActivateAsync();
    }
}
