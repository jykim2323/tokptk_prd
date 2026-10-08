using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Bibliography;
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

public partial class SFrm6130ViewModel : ObservableObject
{
    private readonly ISFrm6130Api _sfrm6130Api;
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
    [ObservableProperty] private string _titleText = "재고 상세 등록";
    [ObservableProperty] private bool _isSubkCodeReadOnly = false;


    public bool IsStatusModify = false;

    public SFrm6130ViewModel(ISFrm6130Api api, IDialogService dialog, ICurrentUserService currentUsers)
    {
        _sfrm6130Api = api;
        _dialog = dialog;
        _currentUsers = currentUsers;
    }

    public void Initialize(Frm6900Dto.SubkDto? item)
    {
        if(item?.Modify == true)
        {
            IsSubkCodeReadOnly = true;
            IsStatusModify = true;
            TitleText = "재고 상세 수정";

            SubkLoca = item?.SubkLoca ?? string.Empty;
            MastName = item?.MastName ?? string.Empty;
            SubkCode = item?.SubkCode ?? string.Empty;
            SubkLotno = item?.SubkLotno ?? string.Empty;
            SubkFlag = !string.IsNullOrWhiteSpace(item?.SubkLoca) ? "1" : "0";
            SubkWgt = item?.SubkWgt ?? string.Empty;
            SubkRwgt = item?.SubkRwgt ?? string.Empty;
            SubkBoxno = item?.SubkBoxno ?? string.Empty;
            SubkIndate = item?.SubkIndate ?? string.Empty;
            SubkIntime = item?.SubkIntime ?? string.Empty;
            SubkPltno = item?.SubkPltno ?? string.Empty;
            SubkRemark = item?.SubkRemark ?? string.Empty;
            SelectedInDate = DateTime.Now;

        }
        else
        {
            SubkLoca = item?.SubkLoca ?? string.Empty;
            SubkFlag = !string.IsNullOrWhiteSpace(item?.SubkLoca) ? "1" : "0";
            SubkPltno = item?.SubkPltno ?? string.Empty;
            SelectedInDate = DateTime.Now;
        }
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

            if (string.IsNullOrEmpty(SubkFlag))
            {
                _dialog.ShowWarning($"재고 상태를 입력 하십시요.....'", "오류");
                return;
            }

            if (string.IsNullOrEmpty(SubkCode))
            {
                _dialog.ShowWarning($" 품번코드를 입력 하세요.", "오류");
                return;
            }

            //if (string.IsNullOrEmpty(SubkLotno))
            //{
            //    _dialog.ShowWarning($" LOT-NO 입력 하세요.", "오류");
            //    return;
            //}

            if (string.IsNullOrEmpty(SubkWgt))
            {
                _dialog.ShowWarning($" 재고 중량을 입력 하세요.", "오류");
                return;
            }

            if (string.IsNullOrEmpty(SubkRwgt))
            {
                SubkRwgt = "0";
            }

            var q = new SFrm6130Dto.ReqDto
            {
                SubkLoca = SubkLoca ?? string.Empty,
                MastName = MastName ?? string.Empty,
                SubkCode = SubkCode ?? string.Empty,
                SubkLotno = SubkLotno ?? string.Empty,
                SubkFlag = SubkFlag,
                SubkWgt = SubkWgt ?? string.Empty,
                SubkRwgt = SubkRwgt ?? string.Empty,
                SubkBoxno = SubkBoxno ?? string.Empty,
                SubkIndate = SelectedInDate?.Date.ToString("yyyyMMdd") ?? string.Empty,
                SubkIntime = DateTime.Now.ToString("HHmmss") ?? string.Empty,
                SubkPltno = SubkPltno ?? string.Empty,
                SubkRemark = SubkRemark ?? string.Empty
            };


            if (!IsStatusModify) //Insert into Mode
            {
                var result = await InsertFunc(q);

                if (!result)
                {
                    return;
                }

                _dialog.ShowInfo($"저장위치: {SubkLoca} 를 등록 하였습니다..! ", "확인");
                return;
            }
            else
            {
                var result =  await ModifyFunc(q);

                if (!result)
                {
                    return;
                }

                _dialog.ShowInfo($"저장위치: {SubkLoca} 를 등록 하였습니다..! ", "확인");
                return;
            }

        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"수정 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private void Close(Window? window) => window?.Close();

    private async Task<bool> ModifyFunc(SFrm6130Dto.ReqDto reqDto)
    {
        try
        {
            if (string.IsNullOrEmpty(SubkPltno))
            {
                _dialog.ShowWarning($"파렛트 번호(PLT-NO)는 필수 입력항목입니다.", "오류");
                return false;
            }

            var subkUpdateCheck = await _sfrm6130Api.SubkUpdateAsync(reqDto);

            if (!subkUpdateCheck)
            {
                _dialog.ShowWarning($" 재고상세(T2MISUBK) 수정 에러!!!!", "오류");
                return false;
            }

            var lstkUpdateCheck = await _sfrm6130Api.ConfirmedAsync(reqDto);

            if (!lstkUpdateCheck)
            {
                _dialog.ShowWarning($" 재고위치(T2MILSTK)  ' + StrLoca + ' 상태변경 에러!!!!", "오류");
                return false;
            }
            _dialog.ShowInfo($" 재고 등록 완료 (PLT: {SubkPltno})!!!!", "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"수정 실패: {ex.Message}", "오류");
        }

        return true;
    }


    private async Task<bool> InsertFunc(SFrm6130Dto.ReqDto reqDto)
    {
        try
        {
            if (string.IsNullOrEmpty(SubkPltno))
            {
                _dialog.ShowWarning($"파렛트 번호(PLT-NO)는 필수 입력항목입니다.", "오류");
                return false;
            }


            var subkCheck = await _sfrm6130Api.SubkCheckAsync(reqDto);

            if (!subkCheck)
            {
                _dialog.ShowWarning($" 해당 PLT-NO 에 동일 품목/LOT가 이미 등록되어 있습니다. \n PLT-NO : {SubkPltno} 품번: {SubkCode} LOT-NO : {SubkLotno}", "오류");
                return false;
            }

            var lstkUpdateCheck = await _sfrm6130Api.ConfirmedAsync(reqDto);

            if (!lstkUpdateCheck)
            {
                _dialog.ShowWarning($" 재고위치(T2MILSTK)  ' + StrLoca + ' 상태변경 에러!!!!", "오류");
                return false;
            }

            var subkInsertCheck = await _sfrm6130Api.SubkInsertAsync(reqDto);

            if (subkInsertCheck <= 0)
            {
                _dialog.ShowWarning($" 재고상세(T2MISUBK) 등록 에러!!!!", "오류");
                return false;
            }

            _dialog.ShowInfo($" 재고 등록 완료 (PLT: {SubkPltno})!!!!", "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"수정 실패: {ex.Message}", "오류");
        }

        return true;
    }
}
