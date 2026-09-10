using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Standards;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Standards;

public partial class Frm1300ViewModel
    : DocumentViewModelBase
{
    private readonly IFrm1300Api _frm1300Api;

    private readonly IDialogService _dialog;

    private readonly ICurrentUserService _currentUser;


    // =========================================================
    // 검색
    // =========================================================

    [ObservableProperty]
    private string _searchText =
        string.Empty;


    // =========================================================
    // Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm1300Dto.ResDto> _items =
        [];


    [ObservableProperty]
    private Frm1300Dto.ResDto? _selectedItem;


    [ObservableProperty]
    private int _recordCount;


    [ObservableProperty]
    private string _statusMessage =
        string.Empty;


    // =========================================================
    // 상세
    // =========================================================

    [ObservableProperty]
    private string _userId =
        string.Empty;


    [ObservableProperty]
    private string _userPassword =
        string.Empty;


    [ObservableProperty]
    private string _userName =
        string.Empty;


    [ObservableProperty]
    private DateTime? _userWdate;


    [ObservableProperty]
    private int _userKind =
        10;


    // =========================================================
    // 등급
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm1300Dto.UserKindDto> _userKinds =
        [];


    [ObservableProperty]
    private Frm1300Dto.UserKindDto? _selectedUserKind;


    // =========================================================
    // 관리자
    // =========================================================

    [ObservableProperty]
    private bool _isAdmin;


    // =========================================================
    // 생성자
    // =========================================================

    public Frm1300ViewModel(
        IFrm1300Api frm1300Api,
        IDialogService dialog,
        ICurrentUserService currentUser)
    {
        _frm1300Api =
            frm1300Api;


        _dialog =
            dialog;


        _currentUser =
            currentUser;


        IsAdmin =
            _currentUser.User?.UserKind ==
            50;


        UserKinds =
        [
            new Frm1300Dto.UserKindDto
            {
                Value = 10,
                Name = "General"
            },

            new Frm1300Dto.UserKindDto
            {
                Value = 50,
                Name = "Super"
            }
        ];


        SelectedUserKind =
            UserKinds[0];


        Title =
            "사용자 ID 관리";


        ContentId =
            DocumentKeys.Frm1300;
    }


    // =========================================================
    // Loaded
    // =========================================================

    [RelayCommand]
    private async Task Loaded()
    {
        await AllSearch();
    }


    // =========================================================
    // 전체 조회
    // =========================================================

    [RelayCommand]
    private async Task AllSearch()
    {
        try
        {
            var result =
                await _frm1300Api
                    .AllSearchAsync();


            SetItems(
                result);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"전체 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 검색
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            if (string.IsNullOrWhiteSpace(
                SearchText))
            {
                _dialog.ShowMessage(
                    "사용자ID를 입력하세요.",
                    "확인");

                return;
            }


            var result =
                await _frm1300Api
                    .SearchAsync(
                        new Frm1300Dto.ReqDto
                        {
                            SearchText =
                                SearchText.Trim()
                        });


            SetItems(
                result);


            if (Items.Count == 0)
            {
                _dialog.ShowMessage(
                    "조회할 데이터가 없습니다.",
                    "확인");
            }
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // Grid 선택
    // =========================================================

    partial void OnSelectedItemChanged(
        Frm1300Dto.ResDto? value)
    {
        if (value == null)
        {
            ClearDetail();

            return;
        }


        SearchText =
            value.UserId
            ?? string.Empty;


        UserId =
            value.UserId
            ?? string.Empty;


        UserPassword =
            value.UserPassword
            ?? string.Empty;


        UserName =
            value.UserName
            ?? string.Empty;


        UserWdate =
            value.UserWdate;


        UserKind =
            value.UserKind;


        SelectedUserKind =
            UserKinds.FirstOrDefault(
                x => x.Value == value.UserKind)
            ?? UserKinds.FirstOrDefault();
    }


    // =========================================================
    // 등급 선택
    // =========================================================

    partial void OnSelectedUserKindChanged(
        Frm1300Dto.UserKindDto? value)
    {
        if (value == null)
            return;


        UserKind =
            value.Value;
    }


    // =========================================================
    // 등록
    // =========================================================

    [RelayCommand]
    private async Task Insert()
    {
        try
        {
            if (!IsAdmin)
            {
                _dialog.ShowMessage(
                    "관리자만 사용자를 등록할 수 있습니다.",
                    "확인");

                return;
            }


            if (!Validate())
                return;


            var duplicate =
                await _frm1300Api
                    .DuplicateCheckAsync(
                        new Frm1300Dto.DuplicateReqDto
                        {
                            UserId =
                                UserId.Trim()
                        });


            if (duplicate)
            {
                _dialog.ShowMessage(
                    "이미 사용자ID를 사용하고 있습니다.",
                    "오류");

                return;
            }


            if (!_dialog.ShowConfirm(
                "사용자ID를 등록합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1300Api
                    .InsertAsync(
                        CreateSaveDto());


            if (result <= 0)
            {
                _dialog.ShowMessage(
                    "사용자 등록 실패",
                    "오류");

                return;
            }


            SearchText =
                UserId;


            await Search();


            _dialog.ShowMessage(
                "사용자 등록 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"사용자 등록 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 수정
    // =========================================================

    [RelayCommand]
    private async Task Update()
    {
        try
        {
            if (!IsAdmin)
            {
                _dialog.ShowMessage(
                    "관리자만 사용자를 수정할 수 있습니다.",
                    "확인");

                return;
            }


            if (SelectedItem == null)
            {
                _dialog.ShowMessage(
                    "수정할 사용자를 선택해주세요.",
                    "확인");

                return;
            }


            if (!Validate())
                return;


            if (!_dialog.ShowConfirm(
                "사용자ID를 수정합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1300Api
                    .UpdateAsync(
                        CreateSaveDto());


            if (result <= 0)
            {
                _dialog.ShowMessage(
                    "수정할 사용자를 찾을 수 없습니다.",
                    "오류");

                return;
            }


            SearchText =
                UserId;


            await Search();


            _dialog.ShowMessage(
                "사용자 수정 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"사용자 수정 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 삭제
    // =========================================================

    [RelayCommand]
    private async Task Delete()
    {
        try
        {
            if (!IsAdmin)
            {
                _dialog.ShowMessage(
                    "관리자만 사용자를 삭제할 수 있습니다.",
                    "확인");

                return;
            }


            if (SelectedItem == null ||
                string.IsNullOrWhiteSpace(UserId))
            {
                _dialog.ShowMessage(
                    "삭제할 사용자를 선택해주세요.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                $"사용자 ID [{UserId}]를 삭제합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1300Api
                    .DeleteAsync(
                        new Frm1300Dto.DeleteReqDto
                        {
                            UserId =
                                UserId.Trim()
                        });


            if (result <= 0)
            {
                _dialog.ShowMessage(
                    "삭제할 사용자를 찾을 수 없습니다.",
                    "오류");

                return;
            }


            ClearDetail();


            SearchText =
                string.Empty;


            await AllSearch();


            _dialog.ShowMessage(
                "사용자 삭제 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"사용자 삭제 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // Collection
    // =========================================================

    private void SetItems(
        IEnumerable<Frm1300Dto.ResDto>? result)
    {
        Items.Clear();


        foreach (var item in
            result ?? [])
        {
            Items.Add(
                item);
        }


        RecordCount =
            Items.Count;


        StatusMessage =
            $"총 {RecordCount:N0}건";


        if (Items.Count > 0)
        {
            SelectedItem =
                Items[0];
        }
        else
        {
            SelectedItem =
                null;
        }
    }


    // =========================================================
    // Validation
    // =========================================================

    private bool Validate()
    {
        if (string.IsNullOrWhiteSpace(
            UserId))
        {
            _dialog.ShowMessage(
                "사용자 ID를 입력하세요.",
                "확인");

            return false;
        }


        if (string.IsNullOrWhiteSpace(
            UserPassword))
        {
            _dialog.ShowMessage(
                "비밀번호를 입력하세요.",
                "확인");

            return false;
        }


        if (string.IsNullOrWhiteSpace(
            UserName))
        {
            _dialog.ShowMessage(
                "사용자 성명을 입력하세요.",
                "확인");

            return false;
        }


        return true;
    }


    // =========================================================
    // DTO
    // =========================================================

    private Frm1300Dto.SaveReqDto CreateSaveDto()
    {
        return new Frm1300Dto.SaveReqDto
        {
            UserId =
                UserId.Trim(),

            UserPassword =
                UserPassword,

            UserName =
                UserName.Trim(),

            UserKind =
                SelectedUserKind?.Value
                ?? UserKind
        };
    }


    // =========================================================
    // Clear
    // =========================================================

    private void ClearDetail()
    {
        UserId =
            string.Empty;


        UserPassword =
            string.Empty;


        UserName =
            string.Empty;


        UserWdate =
            null;


        UserKind =
            10;


        SelectedUserKind =
            UserKinds.FirstOrDefault();
    }
}