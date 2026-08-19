using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.DTOs.Login;

public partial class LoginUserDto : ObservableObject
{
    [ObservableProperty]
    private string _userId = string.Empty;

    [ObservableProperty]
    private string _userPassword = string.Empty;

    [ObservableProperty]
    private string _userName = string.Empty;

    [ObservableProperty]
    private string _userJobNumber = string.Empty;

    [ObservableProperty]
    private int _userKind;

    [ObservableProperty]
    private string _userUses = string.Empty;
}
