using System.ComponentModel;
using System.Windows;
using System.Windows.Input;
using TOK.WMS.UI.ViewModels.Dialogs;

namespace TOK.WMS.UI.Views.Dialogs;

public partial class AlertDialogWindow : Window
{
    private readonly AlertDialogViewModel _viewModel;
    private bool _closeRequested;

    public AlertDialogWindow(AlertDialogViewModel vm)
    {
        ArgumentNullException.ThrowIfNull(vm);
        InitializeComponent();
        _viewModel = vm;
        DataContext = vm;
        MaxWidth = Math.Max(MinWidth, Math.Min(520, SystemParameters.WorkArea.Width - 40));
        Width = Math.Min(Width, MaxWidth);
        MaxHeight = Math.Max(220, Math.Min(680, SystemParameters.WorkArea.Height - 40));
        MessageScroll.MaxHeight = Math.Max(80, MaxHeight - 220);
        vm.CloseRequested += OnCloseRequested;
    }

    private void Window_Loaded(object sender, RoutedEventArgs e)
    {
        var button = _viewModel.AllowCancel
            ? CancelButton
            : _viewModel.IsConfirmation ? SecondaryButton : PrimaryButton;
        button.Focus();
        Keyboard.Focus(button);
    }

    private void Window_PreviewKeyDown(object sender, KeyEventArgs e)
    {
        if (e.Key == Key.Escape)
        {
            _viewModel.CancelCommand.Execute(null);
            e.Handled = true;
            return;
        }

        // 내용 선택 중에도 Enter는 안전한 기본 버튼과 같은 결과를 낸다.
        if (e.Key != Key.Enter || Keyboard.Modifiers != ModifierKeys.None ||
            Keyboard.FocusedElement is System.Windows.Controls.Button)
            return;

        if (_viewModel.AllowCancel)
            _viewModel.CancelCommand.Execute(null);
        else if (_viewModel.IsConfirmation)
            _viewModel.RejectCommand.Execute(null);
        else
            _viewModel.AcceptCommand.Execute(null);

        e.Handled = true;
    }

    private void Header_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    {
        if (e.ButtonState == MouseButtonState.Pressed && !HeaderCloseButton.IsMouseOver)
        {
            try
            {
                DragMove();
            }
            catch (InvalidOperationException)
            {
                // DragMove 시작 직전에 마우스가 놓인 경우에는 이동을 생략한다.
            }
        }
    }

    private void OnCloseRequested(bool? result)
    {
        if (_closeRequested)
            return;

        _closeRequested = true;
        DialogResult = result ?? false;
    }

    protected override void OnClosing(CancelEventArgs e)
    {
        if (!_closeRequested)
        {
            _closeRequested = true;
            _viewModel.CancelCommand.Execute(null);
        }

        base.OnClosing(e);
    }

    protected override void OnClosed(EventArgs e)
    {
        _viewModel.CloseRequested -= OnCloseRequested;
        base.OnClosed(e);
    }
}
