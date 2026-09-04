using System.Windows;
using TOK.WMS.UI.ViewModels.MainMenus.Inventory;

namespace TOK.WMS.UI.Views.MainMenus.Inventory;

/// <summary>
/// LocaAddView.xaml에 대한 상호 작용 논리
/// </summary>
public partial class LocaAddView : Window
{
    public LocaAddView(LocaAddViewModel vm)
    {
        InitializeComponent();

        DataContext = vm;
    }
}
