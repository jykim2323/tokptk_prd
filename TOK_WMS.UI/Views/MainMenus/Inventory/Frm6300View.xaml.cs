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
using System.Windows.Navigation;
using System.Windows.Shapes;
using TOK.WMS.UI.ViewModels.MainMenus.Inventory;

namespace TOK.WMS.UI.Views.MainMenus.Inventory;

/// <summary>
/// Frm6300View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class Frm6300View : UserControl
{
    public Frm6300View()
    {
        InitializeComponent();
    }
    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is Frm6300ViewModel vm)
            _ = vm.SearchCommand.ExecuteAsync(null);
    }
}
