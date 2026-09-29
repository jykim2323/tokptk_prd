using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Controls;

namespace TOK.WMS.UI.Views.MainMenus.Controls;

public partial class TransferCompletionWaitView : UserControl
{
    public TransferCompletionWaitView()
    {
        InitializeComponent();
    }

    private async void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is TransferCompletionWaitViewModel viewModel)
            await viewModel.ActivateAsync();
    }
}
