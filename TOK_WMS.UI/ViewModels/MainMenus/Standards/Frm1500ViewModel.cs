using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Standards;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Standards;

public partial class Frm1500ViewModel
    : DocumentViewModelBase
{
    private readonly IFrm1500Api _frm1500Api;

    private readonly IDialogService _dialog;


    // =========================================================
    // 구분#1
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm1500Dto.Gubn1Dto> _gubn1Items = [];


    [ObservableProperty]
    private Frm1500Dto.Gubn1Dto? _selectedGubn1;


    [ObservableProperty]
    private string _gubn1Code = string.Empty;


    [ObservableProperty]
    private string _gubn1Name = string.Empty;


    // =========================================================
    // 구분#2
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm1500Dto.Gubn2Dto> _gubn2Items = [];


    [ObservableProperty]
    private Frm1500Dto.Gubn2Dto? _selectedGubn2;


    [ObservableProperty]
    private string _gubn2Code = string.Empty;


    [ObservableProperty]
    private string _gubn2Name = string.Empty;


    // =========================================================
    // 구분#3
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm1500Dto.Gubn3Dto> _gubn3Items = [];


    [ObservableProperty]
    private Frm1500Dto.Gubn3Dto? _selectedGubn3;


    [ObservableProperty]
    private string _gubn3Code = string.Empty;


    [ObservableProperty]
    private string _gubn3Name = string.Empty;


    // =========================================================
    // 상태
    // =========================================================

    [ObservableProperty]
    private string _statusMessage = string.Empty;


    // =========================================================
    // 생성자
    // =========================================================

    public Frm1500ViewModel(
        IFrm1500Api frm1500Api,
        IDialogService dialog)
    {
        _frm1500Api =
            frm1500Api;


        _dialog =
            dialog;


        Title =
            "구분코드 마스터 관리";


        ContentId =
            DocumentKeys.Frm1500;
    }


    // =========================================================
    // Loaded
    // =========================================================

    [RelayCommand]
    private async Task Loaded()
    {
        await Search();
    }


    // =========================================================
    // 전체 조회
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var task1 =
                _frm1500Api.Gubn1SearchAsync();

            var task2 =
                _frm1500Api.Gubn2SearchAsync();

            var task3 =
                _frm1500Api.Gubn3SearchAsync();


            await Task.WhenAll(
                task1,
                task2,
                task3);


            SetGubn1Items(
                await task1);

            SetGubn2Items(
                await task2);

            SetGubn3Items(
                await task3);


            StatusMessage =
                $"위험물 {Gubn1Items.Count:N0}건 / " +
                $"석유류 {Gubn2Items.Count:N0}건 / " +
                $"수용성 {Gubn3Items.Count:N0}건";
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#1 선택
    // Delphi DataSource1DataChange
    // =========================================================

    partial void OnSelectedGubn1Changed(
        Frm1500Dto.Gubn1Dto? value)
    {
        if (value == null)
        {
            Gubn1Code =
                string.Empty;

            Gubn1Name =
                string.Empty;

            return;
        }


        Gubn1Code =
            value.Gubn1Code
            ?? string.Empty;


        Gubn1Name =
            value.Gubn1Name
            ?? string.Empty;
    }


    // =========================================================
    // 구분#2 선택
    // =========================================================

    partial void OnSelectedGubn2Changed(
        Frm1500Dto.Gubn2Dto? value)
    {
        if (value == null)
        {
            Gubn2Code =
                string.Empty;

            Gubn2Name =
                string.Empty;

            return;
        }


        Gubn2Code =
            value.Gubn2Code
            ?? string.Empty;


        Gubn2Name =
            value.Gubn2Name
            ?? string.Empty;
    }


    // =========================================================
    // 구분#3 선택
    // =========================================================

    partial void OnSelectedGubn3Changed(
        Frm1500Dto.Gubn3Dto? value)
    {
        if (value == null)
        {
            Gubn3Code =
                string.Empty;

            Gubn3Name =
                string.Empty;

            return;
        }


        Gubn3Code =
            value.Gubn3Code
            ?? string.Empty;


        Gubn3Name =
            value.Gubn3Name
            ?? string.Empty;
    }


    // =========================================================
    // 구분#1 등록
    // =========================================================

    [RelayCommand]
    private async Task InsertGubn1()
    {
        try
        {
            if (!Validate(
                Gubn1Code,
                Gubn1Name,
                "구분#1"))
            {
                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#1 데이터를 등록 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .InsertGubn1Async(
                        CreateSaveDto(
                            Gubn1Code,
                            Gubn1Name));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#1 등록 실패",
                    "오류");

                return;
            }


            await RefreshGubn1();


            _dialog.ShowInfo(
                "구분#1 등록 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#1 등록 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#1 수정
    // =========================================================

    [RelayCommand]
    private async Task UpdateGubn1()
    {
        try
        {
            if (!Validate(
                Gubn1Code,
                Gubn1Name,
                "구분#1"))
            {
                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#1 데이터를 수정 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .UpdateGubn1Async(
                        CreateSaveDto(
                            Gubn1Code,
                            Gubn1Name));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#1 수정 대상이 없습니다.",
                    "오류");

                return;
            }


            await RefreshGubn1();


            _dialog.ShowInfo(
                "구분#1 수정 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#1 수정 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#1 삭제
    // =========================================================

    [RelayCommand]
    private async Task DeleteGubn1()
    {
        try
        {
            if (string.IsNullOrWhiteSpace(
                Gubn1Code))
            {
                _dialog.ShowWarning(
                    "구분#1 코드를 선택해주세요.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#1 데이터를 삭제 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .DeleteGubn1Async(
                        CreateDeleteDto(
                            Gubn1Code));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#1 삭제 대상이 없습니다.",
                    "오류");

                return;
            }


            await RefreshGubn1();


            _dialog.ShowInfo(
                "구분#1 삭제 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#1 삭제 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#2 등록
    // =========================================================

    [RelayCommand]
    private async Task InsertGubn2()
    {
        try
        {
            if (!Validate(
                Gubn2Code,
                Gubn2Name,
                "구분#2"))
            {
                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#2 데이터를 등록 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .InsertGubn2Async(
                        CreateSaveDto(
                            Gubn2Code,
                            Gubn2Name));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#2 등록 실패",
                    "오류");

                return;
            }


            await RefreshGubn2();


            _dialog.ShowInfo(
                "구분#2 등록 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#2 등록 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#2 수정
    // =========================================================

    [RelayCommand]
    private async Task UpdateGubn2()
    {
        try
        {
            if (!Validate(
                Gubn2Code,
                Gubn2Name,
                "구분#2"))
            {
                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#2 데이터를 수정 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .UpdateGubn2Async(
                        CreateSaveDto(
                            Gubn2Code,
                            Gubn2Name));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#2 수정 대상이 없습니다.",
                    "오류");

                return;
            }


            await RefreshGubn2();


            _dialog.ShowInfo(
                "구분#2 수정 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#2 수정 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#2 삭제
    // =========================================================

    [RelayCommand]
    private async Task DeleteGubn2()
    {
        try
        {
            if (string.IsNullOrWhiteSpace(
                Gubn2Code))
            {
                _dialog.ShowWarning(
                    "구분#2 코드를 선택해주세요.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#2 데이터를 삭제 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .DeleteGubn2Async(
                        CreateDeleteDto(
                            Gubn2Code));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#2 삭제 대상이 없습니다.",
                    "오류");

                return;
            }


            await RefreshGubn2();


            _dialog.ShowInfo(
                "구분#2 삭제 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#2 삭제 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#3 등록
    // =========================================================

    [RelayCommand]
    private async Task InsertGubn3()
    {
        try
        {
            if (!Validate(
                Gubn3Code,
                Gubn3Name,
                "구분#3"))
            {
                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#3 데이터를 등록 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .InsertGubn3Async(
                        CreateSaveDto(
                            Gubn3Code,
                            Gubn3Name));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#3 등록 실패",
                    "오류");

                return;
            }


            await RefreshGubn3();


            _dialog.ShowInfo(
                "구분#3 등록 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#3 등록 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#3 수정
    // =========================================================

    [RelayCommand]
    private async Task UpdateGubn3()
    {
        try
        {
            if (!Validate(
                Gubn3Code,
                Gubn3Name,
                "구분#3"))
            {
                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#3 데이터를 수정 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .UpdateGubn3Async(
                        CreateSaveDto(
                            Gubn3Code,
                            Gubn3Name));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#3 수정 대상이 없습니다.",
                    "오류");

                return;
            }


            await RefreshGubn3();


            _dialog.ShowInfo(
                "구분#3 수정 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#3 수정 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 구분#3 삭제
    // =========================================================

    [RelayCommand]
    private async Task DeleteGubn3()
    {
        try
        {
            if (string.IsNullOrWhiteSpace(
                Gubn3Code))
            {
                _dialog.ShowWarning(
                    "구분#3 코드를 선택해주세요.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "구분#3 데이터를 삭제 합니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm1500Api
                    .DeleteGubn3Async(
                        CreateDeleteDto(
                            Gubn3Code));


            if (result <= 0)
            {
                _dialog.ShowWarning(
                    "구분#3 삭제 대상이 없습니다.",
                    "오류");

                return;
            }


            await RefreshGubn3();


            _dialog.ShowInfo(
                "구분#3 삭제 완료",
                "완료");
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"구분#3 삭제 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // GUBN1 Refresh
    // =========================================================

    private async Task RefreshGubn1()
    {
        var result =
            await _frm1500Api
                .Gubn1SearchAsync();


        SetGubn1Items(
            result);


        Gubn1Code =
            string.Empty;

        Gubn1Name =
            string.Empty;

        SelectedGubn1 =
            null;
    }


    // =========================================================
    // GUBN2 Refresh
    // =========================================================

    private async Task RefreshGubn2()
    {
        var result =
            await _frm1500Api
                .Gubn2SearchAsync();


        SetGubn2Items(
            result);


        Gubn2Code =
            string.Empty;

        Gubn2Name =
            string.Empty;

        SelectedGubn2 =
            null;
    }


    // =========================================================
    // GUBN3 Refresh
    // =========================================================

    private async Task RefreshGubn3()
    {
        var result =
            await _frm1500Api
                .Gubn3SearchAsync();


        SetGubn3Items(
            result);


        Gubn3Code =
            string.Empty;

        Gubn3Name =
            string.Empty;

        SelectedGubn3 =
            null;
    }


    // =========================================================
    // Collection
    // =========================================================

    private void SetGubn1Items(
        IEnumerable<Frm1500Dto.Gubn1Dto>? result)
    {
        Gubn1Items.Clear();


        foreach (var item in
            result ?? [])
        {
            Gubn1Items.Add(
                item);
        }
    }


    private void SetGubn2Items(
        IEnumerable<Frm1500Dto.Gubn2Dto>? result)
    {
        Gubn2Items.Clear();


        foreach (var item in
            result ?? [])
        {
            Gubn2Items.Add(
                item);
        }
    }


    private void SetGubn3Items(
        IEnumerable<Frm1500Dto.Gubn3Dto>? result)
    {
        Gubn3Items.Clear();


        foreach (var item in
            result ?? [])
        {
            Gubn3Items.Add(
                item);
        }
    }


    // =========================================================
    // Validation
    // =========================================================

    private bool Validate(
        string code,
        string name,
        string title)
    {
        if (string.IsNullOrWhiteSpace(
            code))
        {
            _dialog.ShowWarning(
                $"{title} 코드를 입력해주세요.",
                "확인");

            return false;
        }


        if (string.IsNullOrWhiteSpace(
            name))
        {
            _dialog.ShowWarning(
                $"{title} 구분명을 입력해주세요.",
                "확인");

            return false;
        }


        return true;
    }


    // =========================================================
    // DTO
    // =========================================================

    private static Frm1500Dto.SaveReqDto CreateSaveDto(
        string code,
        string name)
    {
        return new Frm1500Dto.SaveReqDto
        {
            Code =
                code.Trim(),

            Name =
                name.Trim()
        };
    }


    private static Frm1500Dto.DeleteReqDto CreateDeleteDto(
        string code)
    {
        return new Frm1500Dto.DeleteReqDto
        {
            Code =
                code.Trim()
        };
    }
}