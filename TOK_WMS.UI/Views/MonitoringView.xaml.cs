using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Media3D;
using TOK.WMS.UI.ViewModels.MainMenus.Monitoring;

namespace TOK.WMS.UI.Views.Monitoring;

public partial class MonitoringView : UserControl
{
    private MonitoringViewModel? _activeViewModel;

    public MonitoringView()
    {
        InitializeComponent();
        Loaded += OnLoaded;
        Unloaded += OnUnloaded;
    }

    private async void OnLoaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is not MonitoringViewModel viewModel)
            return;

        _activeViewModel = viewModel;
        try
        {
            await viewModel.ActivateAsync();
        }
        catch (ObjectDisposedException)
        {
            // 탭이 닫히는 중 발생한 Loaded 경합은 무시한다.
        }
    }

    private void OnUnloaded(object sender, RoutedEventArgs e)
    {
        var viewModel = _activeViewModel ?? DataContext as MonitoringViewModel;
        _activeViewModel = null;
        viewModel?.Deactivate();
    }

    private void WarehouseCanvas_OnMouseDoubleClick(
        object sender,
        MouseButtonEventArgs e)
    {
        if (e.ClickCount < 2)
            return;

        if (DataContext is not MonitoringViewModel viewModel)
            return;

        var element = FindNamedElement(e.OriginalSource as DependencyObject);
        if (element is null)
            return;

        if (TryReadSuffix(element.Name, "SC", out var craneNo) && craneNo is >= 1 and <= 7)
        {
            viewModel.OpenStackerWork(craneNo);
            e.Handled = true;
            return;
        }

        if (TryReadSuffix(element.Name, "PLT", out var trackNo) && trackNo is >= 1 and <= 84)
        {
            viewModel.OpenTrackingInfo(trackNo);
            e.Handled = true;
            return;
        }

        if (element.Name is "BottomCarrier25" or "TopCarrier82")
        {
            viewModel.OpenTrackingInfo(element.Name == "BottomCarrier25" ? 25 : 82);
            e.Handled = true;
            return;
        }

        if (element.Name.StartsWith("Rack", StringComparison.Ordinal) &&
            element.Name.Length >= 8 &&
            int.TryParse(element.Name.AsSpan(4, 2), out var bank) &&
            int.TryParse(element.Name.AsSpan(6, 2), out var bay))
        {
            viewModel.OpenRackOverview(bank, bay);
            e.Handled = true;
        }
    }

    private FrameworkElement? FindNamedElement(DependencyObject? source)
    {
        var current = source;
        while (current is not null && current != WarehouseCanvas)
        {
            if (current is FrameworkElement element &&
                (!string.IsNullOrEmpty(element.Name) &&
                 (element.Name.StartsWith("SC", StringComparison.Ordinal) ||
                  element.Name.StartsWith("PLT", StringComparison.Ordinal) ||
                  element.Name.StartsWith("Rack", StringComparison.Ordinal) ||
                  element.Name is "BottomCarrier25" or "TopCarrier82")))
            {
                return element;
            }

            current = current switch
            {
                Visual or Visual3D => VisualTreeHelper.GetParent(current),
                FrameworkContentElement content => content.Parent,
                _ => null
            };
        }

        return null;
    }

    private static bool TryReadSuffix(string name, string prefix, out int number)
    {
        number = 0;
        return name.StartsWith(prefix, StringComparison.Ordinal) &&
               int.TryParse(name.AsSpan(prefix.Length), out number);
    }
}
