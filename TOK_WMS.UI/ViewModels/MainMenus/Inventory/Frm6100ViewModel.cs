using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inventory;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public class Frm6100ViewModel : DocumentViewModelBase
{


    private readonly IDialogService _dialog;
    private readonly IFrm6100Api _frm6100Api;

    public Frm6100ViewModel(IFrm6100Api frm6100Api, IDialogService dialog)
    {
        _frm6100Api = frm6100Api;
        _dialog = dialog;

        Title = "저장 위치 조회";
        ContentId = DocumentKeys.Frm6100;
    }
}
