using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;
using TOK.WMS.UI.ViewModels;
using TOK.WMS.UI.Services;

namespace TOK.WMS.UI;



/// <summary>
/// Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{

    private readonly ThemeService _theme;
    private bool _menuExpanded = true;

    private const double SidebarOpenWidth = 200.0;
    private const double SidebarClosedWidth = 50.0;

    public MainWindow(MainViewModel vm, ThemeService theme)
    {
        InitializeComponent();
        _theme = theme;
        DataContext = vm;
    }

    // ── 햄버거 버튼 클릭 ─────────────────────────────────────────────
    private void HamburgerBtn_Click(object sender, RoutedEventArgs e)
    {
        _menuExpanded = !_menuExpanded;
        var targetWidth = _menuExpanded ? SidebarOpenWidth : SidebarClosedWidth;

        SidebarPanel.BeginAnimation(WidthProperty,
            new DoubleAnimation(targetWidth, TimeSpan.FromMilliseconds(250))
            {
                EasingFunction = new CubicEase { EasingMode = EasingMode.EaseInOut }
            });
        // 모든 그룹 Expander 일괄 펼침/접힘 (바인딩 없이 직접 set → clobber 문제 없음)
        foreach (var exp in FindVisualChildren<Expander>(SidebarPanel))
            exp.IsExpanded = _menuExpanded;
    }

    private void SideMenuBtn_Click(object sender, RoutedEventArgs e) { /* 필요 시 자동 접힘 추가 */ }
    private void Dock_DocumentClosed(object sender, AvalonDock.DocumentClosedEventArgs e)
    {
        if (e.Document?.Content is ViewModels.Base.DocumentViewModelBase doc)
            (DataContext as ViewModels.MainViewModel)?.CloseDocument(doc);
    }

    private static IEnumerable<T> FindVisualChildren<T>(DependencyObject root) where T : DependencyObject
    {
        if (root == null) yield break;
        int count = VisualTreeHelper.GetChildrenCount(root);
        for (int i = 0; i < count; i++)
        {
            var child = VisualTreeHelper.GetChild(root, i);
            if (child is T t) yield return t;
            foreach (var d in FindVisualChildren<T>(child)) yield return d;
        }
    }

}


