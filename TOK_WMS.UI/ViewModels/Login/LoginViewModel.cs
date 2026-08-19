using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Login;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Login;
using TOK.WMS.UI.Services.Interfaces;

namespace TOK.WMS.UI.ViewModels.Login;

public partial class LoginViewModel : ObservableObject
{
    private readonly ILoginApi _loginApi;
    private readonly ICurrentUserService _currnetUsers;

    [ObservableProperty]
    private string _id = string.Empty;

    [ObservableProperty]
    private string _password = string.Empty;

    [ObservableProperty]
    private string _errorMessage = string.Empty;

    [ObservableProperty]
    private bool _isLoading;


    [ObservableProperty]
    private int _userKind;

    [ObservableProperty]
    private string _userUses = string.Empty;

    public event EventHandler? LoginSucceeded;

    public LoginViewModel(
        ILoginApi loginApi,
        ICurrentUserService currentUsers)
    {
        _loginApi = loginApi;
        _currnetUsers = currentUsers;
    }
    

    [RelayCommand]
    private async Task Login()
    {
        if (IsLoading)
        {
            return;
        }

        IsLoading = true;
        ErrorMessage = string.Empty;

        try
        {

            var user = new LoginUserDto
            {
                UserId = Id,
                UserPassword = Password
            };

            var success_user = await _loginApi.Login(user);

            if (success_user != null)
            {
                _currnetUsers.User = success_user;
                LoginSucceeded?.Invoke(this, EventArgs.Empty);
                return;
            }

            ErrorMessage = $"로그인 성공.";

        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            ErrorMessage = $"로그인 처리 중 오류가 발생했습니다. {ex.Message}";
        }
        finally
        {
            IsLoading = false;
        }
    }

}
