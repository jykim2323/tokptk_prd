using System.Windows;
using TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

namespace TOK.WMS.UI.Views.Monitoring.Popups;

public partial class StackerWorkView : Window
{
    private readonly StackerWorkViewModel _viewModel;

    public StackerWorkView(StackerWorkViewModel viewModel)
    {
        InitializeComponent();
        _viewModel = viewModel;
        DataContext = viewModel;
        Loaded += OnLoaded;
    }

    public void Initialize(int craneNo) => _viewModel.Initialize(craneNo);

    private async void OnLoaded(object sender, RoutedEventArgs e)
    {
        Loaded -= OnLoaded;
        await _viewModel.LoadAsync();
    }
}
