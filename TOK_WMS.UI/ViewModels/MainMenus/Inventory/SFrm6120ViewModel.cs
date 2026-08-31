using ClosedXML.Graphics;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Text;
using System.Windows;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.Api.Inventory;
using TOK.WMS.UI.Services.Interfaces;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public partial class SFrm6120ViewModel : ObservableObject
{

    private readonly ISFrm6120Api _sfrm6120Api;
    private readonly IDialogService _dialog;
    private readonly ICurrentUserService _currentUsers;

    [ObservableProperty] private DateTime? _selectedInDate;
    [ObservableProperty] private string _lstkLoca = string.Empty;
    [ObservableProperty] private string _lstkFlag = string.Empty;
    [ObservableProperty] private string _lstkIndate = string.Empty;
    [ObservableProperty] private string _lstkIntime = string.Empty;
    [ObservableProperty] private string _lstkPltno = string.Empty;


    [ObservableProperty] private ObservableCollection<SFrm6120Dto.ReqDto> _subkItems = [];



    public SFrm6120ViewModel(ISFrm6120Api api, IDialogService dialog, ICurrentUserService currentUsers)
    {
        _sfrm6120Api = api;
        _dialog = dialog;
        _currentUsers = currentUsers;
    }

    public void Initialize(Frm6100Dto.SubkDto? item)
    {
        LstkLoca = item?.SubkLoca ?? string.Empty;
        LstkFlag = item?.SubkFlag ?? string.Empty;
        SelectedInDate = DateTime.Now;
        LstkIntime = item?.SubkIntime ?? string.Empty;
        LstkPltno = item?.SubkPltno ?? string.Empty;

    }


    [RelayCommand]
    private async Task Pltcheck()
    {
        try
        {
            if (string.IsNullOrEmpty(LstkPltno))
            {
                _dialog.ShowMessage("PLT_NO를입력하세요..'\n' 확인한 후 다시 하십시요!!!", "알림");
                return;
            }

            var item = new SFrm6120Dto.ReqDto
            {
                SubkPltno = LstkPltno
            };

            var result = await _sfrm6120Api.SubklocacheckAsync(item?.SubkPltno ?? string.Empty);

            if (result == "0")
            {
                _dialog.ShowMessage($"{LstkPltno}는 신규 파레트 번호 입니다.. 등록후 수정 하십시요!!!", "알림");
                return;
            }

            if (result != "")
            {
                _dialog.ShowMessage($"{LstkPltno}는  이미 랙 재고에 등록되어 있는 PLTNO 입니다..\n 확인 후 다시 하십시오!!!", "알림");
                return;
            }

            var lstkcheck = await _sfrm6120Api.LstkcheckAsync(item?.SubkPltno ?? string.Empty);

            if (!lstkcheck)
            {
                _dialog.ShowMessage($"{LstkPltno}는  이미 랙 재고에 등록되어 있는 PLTNO 입니다..\n 확인 후 다시 하십시오!!!", "알림");
                return;
            }

            this.SubkSearchCommand.Execute(null);

        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task SubkSearch()
    {
        try
        {

            var result = await _sfrm6120Api.SubkSearchAsync(LstkPltno);
            SubkItems.Clear();
            foreach (var h in result ?? []) SubkItems.Add(h);

        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Confirmed()
    {
        try
        {
            if(_dialog.ShowConfirm("정말로 확정 합니까?", "확인") != true)
            {
                return;
            }


            if (string.IsNullOrEmpty(LstkPltno))
            {
                _dialog.ShowMessage("PLTNO를 입력 하십시오.....", "오류");
                return;
            };


            if (SubkItems.Count != 0)
            {
                foreach (var item in SubkItems)
                {
                    item.SubkLoca = LstkLoca;
                    item.SubkFlag = LstkFlag;
                    item.SubkPltno = LstkPltno;
                    item.SubkIntime = string.IsNullOrEmpty(LstkIntime) ? DateTime.Now.ToString("HHmmss") : LstkIntime;
                    item.SubkIndate = SelectedInDate?.ToString("yyyyMMdd") ?? DateTime.Now.ToString("yyyyMMdd");
                    item.UserId = _currentUsers?.User?.UserId ?? string.Empty;

                    if (!await _sfrm6120Api.MilstkUpdateAsync(item))
                    {
                        _dialog.ShowMessage($"{LstkLoca} 재고 마스터 위치 수정 실패", "오류");
                        return;
                    }

                    if (!await _sfrm6120Api.MisubkUpdateAsync(item))
                    {
                        _dialog.ShowMessage($"{LstkLoca} 재고 상세 위치 수정 실패", "오류");
                        return;
                    }
                }
            }

            _dialog.ShowMessage($"작업 성공", "확인");
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"수정 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private void Close(Window? window) => window?.Close();

}
