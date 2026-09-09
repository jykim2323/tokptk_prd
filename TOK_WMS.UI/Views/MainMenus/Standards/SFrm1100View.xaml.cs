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
using TOK.WMS.UI.ViewModels.MainMenus.Standards;

namespace TOK.WMS.UI.Views.MainMenus.Standards;

/// <summary>
/// SFrm1100View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class SFrm1100View : Window
{
    public SFrm1100View(SFrm1100ViewModel vm)
    {
        InitializeComponent();

        DataContext = vm;
    }
}