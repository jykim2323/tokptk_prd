using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public class Frm6100ViewModel : DocumentViewModelBase
{


    private readonly IDialogService _dialog;
    private readonly IFrm6100Api _frm3100Api;

    public Frm6100ViewModel(IFrm6100Api frm6100Api, IDialogService dialog)
    {
        _frm6100Api = frm6100Api;
        _dialog = dialog;

        Title = "수동 입고 등록";
        ContentId = DocumentKeys.Frm3100;
    }
}
