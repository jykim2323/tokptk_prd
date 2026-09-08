using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

namespace TOK.WMS.UI.Views.MainMenus.Inbounds;

/// <summary>
/// Frm3130View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class Frm3130View : UserControl
{
    public Frm3130View()
    {
        InitializeComponent();
    }

    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is Frm3130ViewModel vm)
            _ = vm.SearchCommand.ExecuteAsync(null);
    }
}
