using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inventory;
using TOK.WMS.UI.ViewModels.Base;
using System.Linq;

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


    [ObservableProperty] private ObservableCollection<Frm6100Dto.ResDto> _Items = [];

    public Frm6100ViewModel(IFrm6100Api frm6100Api, IDialogService dialog)
    {
        _frm6100Api = frm6100Api;
        _dialog = dialog;

        Title = "저장 위치 조회";
        ContentId = DocumentKeys.Frm6100;
    }

    partial void OnLstkLocaChanged(string value)
    {
        var digits = new string(value.Where(char.IsDigit).ToArray());

        if (digits.Length > 5)
            digits = digits[..5];

        var formatted = digits.Length switch
        {
            0 => "",
            1 => digits,
            2 => $"{digits[0]}-{digits[1]}",
            3 => $"{digits[0]}-{digits[1]}{digits[2]}",
            4 => $"{digits[0]}-{digits[1]}{digits[2]}-{digits[3]}",
            _ => $"{digits[0]}-{digits[1]}{digits[2]}-{digits[3]}{digits[4]}"
        };

        if (LstkLoca != formatted)
            LstkLoca = formatted;
    }

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var q = new Frm6100Dto
            {
                LstkLoca = LstkLoca
            };
            var result = await _frm6100Api.SearchAsync(q);
            Items.Clear();
            foreach (var h in result ?? []) Items.Add(h);
            //StatusMessage = $"총 {Items.Count:N0} 건 조회됨";
        }
        catch (Exception ex)
        {
            //StatusMessage = ex.Message;
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }
}

