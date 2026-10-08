using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

namespace TOK.WMS.UI.Views.MainMenus.Inbounds;

/// <summary>
/// Frm3130View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class Frm3130View : UserControl
{
    private Frm3130ViewModel? _subscribedViewModel;

    public Frm3130View()
    {
        InitializeComponent();
        Unloaded += UserControl_Unloaded;
        DataContextChanged += UserControl_DataContextChanged;
    }

    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        UpdateFocusSubscriptions(DataContext as Frm3130ViewModel);

        if (_subscribedViewModel is not { } vm)
            return;

        _ = vm.SearchCommand.ExecuteAsync(null);
        FocusCurrentInput(vm);
    }

    private void UserControl_Unloaded(object sender, RoutedEventArgs e)
    {
        UpdateFocusSubscriptions(null);
    }

    private void UserControl_DataContextChanged(object sender, DependencyPropertyChangedEventArgs e)
    {
        UpdateFocusSubscriptions(IsLoaded ? e.NewValue as Frm3130ViewModel : null);

        if (_subscribedViewModel is { } vm)
            FocusCurrentInput(vm);
    }

    private void UpdateFocusSubscriptions(Frm3130ViewModel? vm)
    {
        if (ReferenceEquals(_subscribedViewModel, vm))
            return;

        if (_subscribedViewModel is { } previous)
        {
            previous.PltFocusRequested -= OnPltFocusRequested;
            previous.BarcodeFocusRequested -= OnBarcodeFocusRequested;
        }

        _subscribedViewModel = vm;

        if (vm is not null)
        {
            vm.PltFocusRequested += OnPltFocusRequested;
            vm.BarcodeFocusRequested += OnBarcodeFocusRequested;
        }
    }

    private void FocusCurrentInput(Frm3130ViewModel vm)
    {
        FocusInput(string.IsNullOrWhiteSpace(vm.PltnoEdit) ? txtPltNo : txtItemBcr);
    }

    private void OnPltFocusRequested()
    {
        FocusInput(txtPltNo);
    }

    private void OnBarcodeFocusRequested()
    {
        FocusInput(txtItemBcr);
    }

    private void FocusInput(TextBox input)
    {
        if (!IsLoaded || !IsVisible ||
            _subscribedViewModel is null ||
            !ReferenceEquals(DataContext, _subscribedViewModel))
            return;

        if (input.IsKeyboardFocusWithin)
        {
            if (ReferenceEquals(input, txtPltNo))
                input.SelectAll();
            return;
        }

        input.Focus();
        Keyboard.Focus(input);
        input.SelectAll();
    }
}
