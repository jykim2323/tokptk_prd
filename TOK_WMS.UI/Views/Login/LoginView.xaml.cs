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
using TOK.WMS.UI.ViewModels.Login;

namespace TOK.WMS.UI.Views.Login;

/// <summary>
/// LoginView.xaml에 대한 상호 작용 논리
/// </summary>
public partial class LoginView : Window
{

    private readonly LoginViewModel _viewModel;
    public event EventHandler? LoginSucceeded;
    private bool _isLogin;

    public LoginView(LoginViewModel vm)
    {
        InitializeComponent();


        _viewModel = vm;
        DataContext = vm;
        _viewModel.LoginSucceeded += ViewModel_LoginSucceeded;

        Loaded += (_, _) => UserIdInput.Focus();
    }

    protected override void OnClosed(EventArgs e)
    {
        _viewModel.LoginSucceeded -= ViewModel_LoginSucceeded;

        if (!_isLogin && Application.Current?.ShutdownMode == ShutdownMode.OnExplicitShutdown)
        {
            Application.Current.Shutdown();
        }

        base.OnClosed(e);
    }

    private void ViewModel_LoginSucceeded(object? sender, EventArgs e)
    {
        _isLogin = true;
        LoginSucceeded?.Invoke(this, EventArgs.Empty);
    }

    private void UserIdInput_KeyDown(object sender, KeyEventArgs e)
    {
        if (e.Key != Key.Enter)
        {
            return;
        }

        PasswordInput.Focus();
        e.Handled = true;
    }
}
