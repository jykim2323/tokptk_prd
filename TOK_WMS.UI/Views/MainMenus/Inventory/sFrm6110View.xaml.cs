using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using TOK.WMS.UI.ViewModels.MainMenus.Inventory;

namespace TOK.WMS.UI.Views.MainMenus.Inventory;

/// <summary>
/// SFrm6110View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class SFrm6110View : Window
{
    public SFrm6110View(SFrm6110ViewModel vm)
    {
        InitializeComponent();

        DataContext = vm;
    }
}
