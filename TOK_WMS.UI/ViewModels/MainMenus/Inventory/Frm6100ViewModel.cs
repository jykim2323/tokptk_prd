using CommunityToolkit.Mvvm.ComponentModel;
using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inventory;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public partial class Frm6100ViewModel : DocumentViewModelBase
{


    private readonly IDialogService _dialog;
    private readonly IFrm6100Api _frm6100Api;


    [ObservableProperty] private string _lstkLoca = string.Empty;
    [ObservableProperty] private string _lstkBk = string.Empty;
    [ObservableProperty] private string _lstkBy = string.Empty;
    [ObservableProperty] private string _lstkLv = string.Empty;
    [ObservableProperty] private string _lstkFlag = string.Empty;
    [ObservableProperty] private string _lstkIndate = string.Empty;
    [ObservableProperty] private string _lstkIntime = string.Empty;
    [ObservableProperty] private string _lstkPltno = string.Empty;

    public Frm6100ViewModel(IFrm6100Api frm6100Api, IDialogService dialog)
    {
        _frm6100Api = frm6100Api;
        _dialog = dialog;

        Title = "저장 위치 조회";
        ContentId = DocumentKeys.Frm6100;
    }
}
