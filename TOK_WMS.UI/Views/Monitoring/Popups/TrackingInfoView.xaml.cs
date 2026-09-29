using System.Windows;
using System.Windows.Controls;
using TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;

namespace TOK.WMS.UI.Views.Monitoring.Popups;

public partial class TrackingInfoView : Window
{
    private bool _loaded;
    private bool _suppressTrackSelectionReload;

    public TrackingInfoView(TrackingInfoViewModel viewModel)
    {
        InitializeComponent();
        ViewModel = viewModel;
        DataContext = viewModel;
    }

    public TrackingInfoViewModel ViewModel { get; }

    public void Initialize(string trackNo) => ViewModel.Initialize(trackNo);

    private async void Window_Loaded(object sender, RoutedEventArgs e)
    {
        if (_loaded)
            return;

        _loaded = true;
        await ViewModel.LoadAsync();
    }

    private async void TrackNoComboBox_SelectionChanged(
        object sender,
        SelectionChangedEventArgs e)
    {
        if (!_loaded || !IsLoaded || _suppressTrackSelectionReload)
            return;

        await ViewModel.LoadAsync();
    }

    private async void MoveTargetComboBox_SelectionChanged(
        object sender,
        SelectionChangedEventArgs e)
    {
        if (!_loaded || !IsLoaded ||
            !ViewModel.IsMoveTargetVisible ||
            e.AddedItems.Count == 0 ||
            e.AddedItems[0] is not string targetTrackNo)
        {
            return;
        }

        if (!await ViewModel.MoveToAsync(targetTrackNo))
            return;

        _suppressTrackSelectionReload = true;
        try
        {
            ViewModel.SelectedTrackNo = targetTrackNo;
        }
        finally
        {
            _suppressTrackSelectionReload = false;
        }

        await ViewModel.LoadAsync();
    }
}
