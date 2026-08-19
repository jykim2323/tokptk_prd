using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

namespace TOK.WMS.UI.Views.MainMenus.Inbounds;

/// <summary>
/// Frm3100View.xaml에 대한 상호 작용 논리
/// </summary>
public partial class Frm3100View : UserControl
{
    public Frm3100View()
    {
        InitializeComponent();

        Loaded += (_, _) =>
        {
            if (DataContext is Frm3100ViewModel vm)
            {
                vm.WeightFocus += OnWeightFocusRequested;
                vm.OnLockOnHandle += OnLockOnHandle;
                vm.OnLockOffHandle += OnLockOffHandle;
            }
        };
    }

    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        if (DataContext is Frm3100ViewModel vm)
            _ = vm.SearchCommand.ExecuteAsync(null);
    }

    private void OnWeightFocusRequested()
    {
        WeightTextBox.Focus();
        Keyboard.Focus(WeightTextBox);
    }
    private void OnLockOnHandle()
    {
        ConfirmBtn.IsEnabled = false;
        CancelSB.IsEnabled = false;
        ReservedSB.IsEnabled = false;
    }
    private void OnLockOffHandle()
    {
        ConfirmBtn.IsEnabled = true;
        CancelSB.IsEnabled = true;
        ReservedSB.IsEnabled = true;
    }

    private void NumInput(object sender, TextCompositionEventArgs e)
    {
        if (e.Text.All(char.IsDigit))
            return;

        e.Handled = true;

        if (DataContext is Frm3100ViewModel vm &&
            vm.WarningCommand.CanExecute(null))
        {
            vm.WarningCommand.Execute(null);
        }
    }
}
