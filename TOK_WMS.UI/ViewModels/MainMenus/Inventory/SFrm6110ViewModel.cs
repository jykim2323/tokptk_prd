using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Office2019.Word.Cid;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml.Vml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Runtime.CompilerServices;
using System.Text;
using System.Windows;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.Api.Inventory;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public partial class SFrm6110ViewModel : ObservableObject
{
    private readonly ISFrm6110Api _sfrm6110Api;
    private readonly IDialogService _dialog;
    [ObservableProperty] private string _lstkLoca = string.Empty;
    [ObservableProperty] private string _lstkFlag = string.Empty;
    [ObservableProperty] private string _lstkIndate = string.Empty;
    [ObservableProperty] private string _lstkIntime = string.Empty;
    [ObservableProperty] private string _lstkPltno = string.Empty;




    public SFrm6110ViewModel(ISFrm6110Api api, IDialogService dialog)
    {
        _sfrm6110Api = api;
        _dialog = dialog;
    }

    public void Initialize(Frm6100Dto.ResDto? item)
    {
        LstkLoca = item?.LstkLoca ?? string.Empty;
        LstkFlag = item?.LstkFlag ?? string.Empty;
        LstkIndate = item?.LstkIndate ?? string.Empty;
        LstkIntime = item?.LstkIntime ?? string.Empty;
        LstkPltno = item?.LstkPltno ?? string.Empty;
    }


    [RelayCommand]
    private async Task Confirmed()
    {
        try
        {
            var q = new SFrm6110Dto.ReqDto
            {
                SubkFlag = LstkFlag,
                SubkIndate = LstkIndate,
                SubkIntime = LstkIntime,
                SubkLoca = LstkLoca

            };


            if(!_dialog.ShowConfirm($"정말로 확정 합니까?", "확인"))
            {
                return;
            }

            var result = await _sfrm6110Api.ConfirmedAsync(q);

            if (!result)
            {
                _dialog.ShowMessage($"{LstkLoca} 위치 수정 실패", "오류");
            }
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"수정 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private void Close(Window? window) => window?.Close();



}
