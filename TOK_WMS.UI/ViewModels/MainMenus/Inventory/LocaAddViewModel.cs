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
using TOK.WMS.UI.Services.Interfaces;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public partial class LocaAddViewModel : ObservableObject
{
    private readonly ILocaAddApi _locaAddApi;
    private readonly IDialogService _dialog;
    private readonly ICurrentUserService _currentUsers;

    [ObservableProperty] private DateTime? _selectedInDate;
    [ObservableProperty] private string _subkLoca = string.Empty;
    [ObservableProperty] private string _subkFlag = string.Empty;
    [ObservableProperty] private string _subkIndate = string.Empty;
    [ObservableProperty] private string _subkIntime = string.Empty;
    [ObservableProperty] private string _subkPltno = string.Empty;
    [ObservableProperty] private string _subkCode = string.Empty;
    [ObservableProperty] private string _mastName = string.Empty;
    [ObservableProperty] private string _subkLotno = string.Empty;
    [ObservableProperty] private string _subkWgt = string.Empty;
    [ObservableProperty] private string _subkRwgt = string.Empty;
    [ObservableProperty] private string _subkBoxno = string.Empty;
    [ObservableProperty] private string _subkRemark = string.Empty;

    public LocaAddViewModel(ILocaAddApi api, IDialogService dialog, ICurrentUserService currentUsers)
    {
        _locaAddApi = api;
        _dialog = dialog;
        _currentUsers = currentUsers;
    }

    public void Initialize(Frm6100Dto.SubkDto? item)
    {
        SubkLoca = item?.SubkLoca ?? string.Empty;
        SubkFlag = item?.SubkFlag ?? string.Empty;
        SubkIndate = item?.SubkIndate ?? string.Empty;
        SubkIntime = item?.SubkIntime ?? string.Empty;
        SubkPltno = item?.SubkPltno ?? string.Empty;
        SelectedInDate = DateTime.Now;
    }


    [RelayCommand]
    private async Task Confirmed()
    {
        try
        {
            if (!_dialog.ShowConfirm($"정말로 확정 합니까?", "확인"))
            {
                return;
            }


            if (string.IsNullOrEmpty(SubkCode))
            {
                _dialog.ShowWarning($" 품번코드를 입력 하세요.", "오류");
                return;
            }

            if (string.IsNullOrEmpty(SubkLotno))
            {
                _dialog.ShowWarning($" LOT-NO 입력 하세요.", "오류");
                return;
            }

            if (string.IsNullOrEmpty(SubkWgt))
            {
                _dialog.ShowWarning($" 재고 수량을 입력 하세요.", "오류");
                return;
            }

            if (string.IsNullOrEmpty(SubkRwgt))
            {
                SubkRwgt = "0";
            }

            if(int.Parse(SubkWgt) < int.Parse(SubkRwgt))
            {
                _dialog.ShowWarning($" 예약 중량이 재고 중량보다 클 수 없습니다....", "오류");
                return;
            }

            var q = new LocaAddDto.ReqDto
            {
                SubkPltno = SubkPltno,
                SubkCode = SubkCode,
                SubkLotno = SubkLotno
            };


            var result = await _locaAddApi.SubkCheckAsync(q);

            if (!result)
            {
                _dialog.ShowWarning($" 해당 PLT-NO 에 동일 품목/LOT가 이미 등록되어 있습니다. \n PLT-NO : {SubkPltno} 품번: {SubkCode} LOT-NO : {SubkLotno}", "오류");
                return;
            }

            var req = new LocaAddDto.ReqDto
            {
                SubkLoca = SubkLoca,
                SubkCode = SubkCode,
                SubkLotno = SubkLotno,
                SubkPltno = SubkPltno,
                SubkWgt = SubkWgt,
                SubkRwgt = SubkRwgt,
                SubkFlag = SubkFlag,
                SubkGubun = "1",
                SubkRemark = SubkRemark,
                SubkBoxno = SubkBoxno,
                SubkIndate = SelectedInDate?.ToString("yyyyMMdd") ?? DateTime.Now.ToString("yyyyMMdd"),
                SubkIntime = string.IsNullOrEmpty(SubkIndate) ? DateTime.Now.ToString("HHmmss") : SubkIntime,
                UserId = _currentUsers.User?.UserId ?? string.Empty,
            };
            
            if (!await _locaAddApi.ConfirmedAsync(req))
            {
                _dialog.ShowWarning($"저장 실패", "오류");
                return;
            }

            _dialog.ShowInfo($"저장위치: {SubkLoca} 를 등록 하였습니다..! ", "확인");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"수정 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private void Close(Window? window) => window?.Close();

}
