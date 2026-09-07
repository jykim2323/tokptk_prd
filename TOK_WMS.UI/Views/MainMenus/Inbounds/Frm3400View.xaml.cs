using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

namespace TOK.WMS.UI.Views.MainMenus.Inbounds;

/// <summary>
/// Frm3400View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class Frm3400View : UserControl
{
    public Frm3400View()
    {
        InitializeComponent();
    }

    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is Frm3400ViewModel vm)
            _ = vm.SearchCommand.ExecuteAsync(null);
    }


    private void DataGrid_LoadingRow(object sender, DataGridRowEventArgs e)
    {
        e.Row.Header = e.Row.GetIndex() + 1;
    }
}
