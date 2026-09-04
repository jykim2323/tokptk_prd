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
using TOK.WMS.UI.ViewModels.MainMenus.Inventory;

namespace TOK.WMS.UI.Views.MainMenus.Inventory;

/// <summary>
/// sFrm6130View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class SFrm6130View : Window
{
    public SFrm6130View(SFrm6130ViewModel vm)
    {
        InitializeComponent();

        DataContext = vm;
          

    }
}
