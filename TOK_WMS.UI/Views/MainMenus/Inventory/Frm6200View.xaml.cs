using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Inventory;

namespace TOK.WMS.UI.Views.MainMenus.Inventory;

/// <summary>
/// Frm6200View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class Frm6200View : UserControl
{
    public Frm6200View()
    {
        InitializeComponent();
    }

    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is Frm6200ViewModel vm)
            _ = vm.SearchCommand.ExecuteAsync(null);
    }

    private void DataGrid_LoadingRow(object sender, DataGridRowEventArgs e)
    {
        e.Row.Header = e.Row.GetIndex() + 1;
    }
}
