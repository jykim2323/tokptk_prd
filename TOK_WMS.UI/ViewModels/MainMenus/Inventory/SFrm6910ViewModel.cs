using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Office2019.Word.Cid;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml.Vml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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

public partial class SFrm6910ViewModel : ObservableObject
{
    private readonly ISFrm6910Api _api;
    private readonly IDialogService _dialog;

    public SFrm6910ViewModel(
        ISFrm6910Api api,
        IDialogService dialog)
    {
        _api = api;
        _dialog = dialog;
    }

    [ObservableProperty]
    private string _leftPltNo = string.Empty;

    [ObservableProperty]
    private string _rightPltNo = string.Empty;


    [ObservableProperty]
    private ObservableCollection<SFrm6910Dto.ResDto> _leftItems = [];

    [ObservableProperty]
    private ObservableCollection<SFrm6910Dto.ResDto> _rightItems = [];


    [ObservableProperty]
    private SFrm6910Dto.ResDto? _selectedLeftItem;

    [ObservableProperty]
    private SFrm6910Dto.ResDto? _selectedRightItem;

    [RelayCommand]
    private void MoveToRight()
    {
        if (SelectedLeftItem == null)
            return;

        var item = SelectedLeftItem;

        LeftItems.Remove(item);
        RightItems.Add(item);

        SelectedLeftItem = null;
    }

    [RelayCommand]
    private void MoveToLeft()
    {
        if (SelectedRightItem == null)
            return;

        var item = SelectedRightItem;

        RightItems.Remove(item);
        LeftItems.Add(item);

        SelectedRightItem = null;
    }

    private bool HasDuplicate(
    IEnumerable<SFrm6910Dto.ResDto> items)
    {
        return items
            .GroupBy(x => new
            {
                x.SubkCode,
                x.SubkLotno
            })
            .Any(g => g.Count() > 1);
    }

    public async Task Initialize(string leftPltNo, string rightPltNo)
    {
        LeftPltNo = leftPltNo;
        RightPltNo = rightPltNo;

        var left = await _api.SearchAsync(leftPltNo);
        var right = await _api.SearchAsync(rightPltNo);

        LeftItems.Clear();
        RightItems.Clear();

        foreach (var item in left ?? [])
        {
            LeftItems.Add(item);
        }

        foreach (var item in right ?? [])
        {
            RightItems.Add(item);
        }
    }
    [RelayCommand]
    private async Task SaveAsync()
    {
        try
        {
            if (string.IsNullOrWhiteSpace(LeftPltNo) ||
                string.IsNullOrWhiteSpace(RightPltNo))
            {
                _dialog.ShowWarning(
                    "파렛트 번호가 입력되지 않았습니다.", "오류");

                return;
            }

            if (LeftPltNo == RightPltNo)
            {
                _dialog.ShowWarning(
                    "상단과 하단 파렛트 번호가 동일합니다.", "오류");

                return;
            }

            // 화면 상태 기준 중복검사
            if (HasDuplicate(LeftItems))
            {
                _dialog.ShowWarning(
                    $"상단 파렛트 [{LeftPltNo}]에 동일한 품목/LOT가 존재합니다.", "오류");

                return;
            }

            if (HasDuplicate(RightItems))
            {
                _dialog.ShowWarning(
                    $"하단 파렛트 [{RightPltNo}]에 동일한 품목/LOT가 존재합니다.", "오류");

                return;
            }

            var reqDto = new SFrm6910Dto.SaveReqDto
            {
                LeftPltNo = LeftPltNo,
                RightPltNo = RightPltNo,

                Items =
                [
                    .. LeftItems.Select(x => new SFrm6910Dto.MoveDto
                {
                    OriginalPltNo = x.OriginalPltNo,
                    TargetPltNo = LeftPltNo,

                    SubkCode = x.SubkCode,
                    SubkLotno = x.SubkLotno
                }),

                .. RightItems.Select(x => new SFrm6910Dto.MoveDto
                {
                    OriginalPltNo = x.OriginalPltNo,
                    TargetPltNo = RightPltNo,

                    SubkCode = x.SubkCode,
                    SubkLotno = x.SubkLotno
                })
                ]
            };

            var result = await _api.SaveAsync(reqDto);

            if (!result)
            {
                _dialog.ShowWarning("저장하지 못했습니다.", "오류");
                return;
            }


            _dialog.ShowInfo("PLT-NO 저장 완료.", "완료");
            // DB 기준으로 다시 조회
            await Initialize(
                LeftPltNo,
                RightPltNo);
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"파렛트 합짐 처리 실패 : {ex.Message}",
                "오류");
        }
    }

    [RelayCommand]
    private void Close(Window? window) => window?.Close();



}
