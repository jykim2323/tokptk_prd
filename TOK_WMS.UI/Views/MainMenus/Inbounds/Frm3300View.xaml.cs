using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

namespace TOK.WMS.UI.Views.MainMenus.Inbounds;

/// <summary>
/// Frm3300View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class Frm3300View : UserControl
{
    public Frm3300View()
    {
        InitializeComponent();
    }
    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is Frm3300ViewModel vm)
            _ = vm.SearchCommand.ExecuteAsync(null);
    }


    private void DataGrid_LoadingRow(object sender, DataGridRowEventArgs e)
    {
        e.Row.Header = e.Row.GetIndex() + 1;
    }
}
