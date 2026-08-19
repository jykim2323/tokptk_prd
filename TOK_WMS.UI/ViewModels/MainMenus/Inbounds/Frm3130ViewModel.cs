using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.EMMA;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections;
using System.Collections.ObjectModel;
using System.Reflection;
using System.Windows;
using TOK.WMS.Core.DTOs;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

public partial class Frm3130ViewModel : DocumentViewModelBase
{

    private readonly IDialogService _dialog;
    private readonly IFrm3130Api _frm3130Api;

    public Frm3130ViewModel(IFrm3130Api frm3130Api, IDialogService dialog)
    {
        _frm3130Api = frm3130Api;
        _dialog = dialog;

        Title = "핸드스캔 입고 등록";
        ContentId = DocumentKeys.Frm3130;
    }




}
