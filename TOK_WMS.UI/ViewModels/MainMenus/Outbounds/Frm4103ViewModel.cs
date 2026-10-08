using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Outbounds;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Outbounds;

public partial class Frm4103ViewModel
    : DocumentViewModelBase
{
    private readonly IFrm4103Api _frm4103Api;
    private readonly IDialogService _dialog;
    private readonly ICurrentUserService _currentUser;


    // =========================================================
    // 검색
    // =========================================================

    [ObservableProperty]
    private DateTime? _outDate =
        DateTime.Today;


    [ObservableProperty]
    private Frm4103Dto.ChasuDto? _selectedChasu;


    [ObservableProperty]
    private ObservableCollection<
        Frm4103Dto.ChasuDto> _chasuItems = [];


    // =========================================================
    // 상단 피킹리스트 현황
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<
        Frm4103Dto.SummaryDto> _summaryItems = [];


    [ObservableProperty]
    private Frm4103Dto.SummaryDto? _selectedSummary;


    // =========================================================
    // 하단 출고대기 현황
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<
        Frm4103Dto.ScheduleDto> _scheduleItems = [];


    [ObservableProperty]
    private Frm4103Dto.ScheduleDto? _selectedSchedule;


    // =========================================================
    // 상태
    // =========================================================

    [ObservableProperty]
    private string _statusMessage =
        string.Empty;


    // =========================================================
    // 중복 Search 방지용
    // =========================================================

    private bool _isInitializing;


    public Frm4103ViewModel(
        IFrm4103Api frm4103Api,
        IDialogService dialog,
        ICurrentUserService currentUser)
    {
        _frm4103Api =
            frm4103Api;

        _dialog =
            dialog;

        _currentUser =
            currentUser;


        Title =
            "피킹리스트 발행";

        ContentId =
            DocumentKeys.Frm4103;


        _ =
            InitializeAsync();
    }


    // =========================================================
    // 최초 로딩
    // =========================================================

    private async Task InitializeAsync()
    {
        try
        {
            _isInitializing =
                true;


            await LoadChasuAsync();


            _isInitializing =
                false;


            await Search();
        }
        catch (Exception ex)
        {
            _isInitializing =
                false;


            _dialog.ShowWarning(
                $"초기 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 날짜 변경
    // =========================================================

    partial void OnOutDateChanged(
        DateTime? value)
    {
        if (_isInitializing)
            return;


        _ =
            DateChangedAsync();
    }


    private async Task DateChangedAsync()
    {
        try
        {
            _isInitializing =
                true;


            await LoadChasuAsync();


            _isInitializing =
                false;


            await Search();
        }
        catch (Exception ex)
        {
            _isInitializing =
                false;


            _dialog.ShowWarning(
                $"날짜 변경 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 차수 변경
    // =========================================================

    partial void OnSelectedChasuChanged(
        Frm4103Dto.ChasuDto? value)
    {
        if (_isInitializing)
            return;


        _ =
            Search();
    }


    // =========================================================
    // 상단 Grid 클릭
    //
    // Delphi:
    // 선택 행의 차수를 ComboBox에 반영
    // =========================================================

    partial void OnSelectedSummaryChanged(
        Frm4103Dto.SummaryDto? value)
    {
        if (value == null)
            return;


        var selected =
            ChasuItems
                .FirstOrDefault(
                    x =>
                        x.Chasu ==
                        value.OuptChasu);


        if (selected == null)
            return;


        if (SelectedChasu != selected)
        {
            SelectedChasu =
                selected;
        }
    }


    // =========================================================
    // 차수 목록 조회
    // =========================================================

    private async Task LoadChasuAsync()
    {
        var outDate =
            OutDate?
                .ToString(
                    "yyyyMMdd")
            ?? string.Empty;


        var result =
            await _frm4103Api.SearchChasuAsync(
                outDate);


        ChasuItems.Clear();


        foreach (var item in result ?? [])
        {
            ChasuItems.Add(
                item);
        }


        // 차수가 하나라도 있으면 첫 번째 선택
        // 없으면 null
        SelectedChasu =
            ChasuItems.FirstOrDefault();
    }


    // =========================================================
    // 조회
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var outDate =
                OutDate?
                    .ToString(
                        "yyyyMMdd")
                ?? string.Empty;


            // =================================================
            // 상단 피킹리스트 현황
            //
            // SelectedChasu == null 이면
            // Chasu = null 그대로 보내도 API Client가 제외함
            // =================================================

            var summary =
                await _frm4103Api.SearchSummaryAsync(
                    new Frm4103Dto.ReqDto
                    {
                        OutDate =
                            outDate,

                        Chasu =
                            SelectedChasu?.Chasu
                    });


            SummaryItems.Clear();


            foreach (var item in summary ?? [])
            {
                SummaryItems.Add(
                    item);
            }


            // =================================================
            // 하단 출고대기 현황
            // =================================================

            var schedules =
                await _frm4103Api.SearchSchedulesAsync();


            ScheduleItems.Clear();


            foreach (var item in schedules ?? [])
            {
                ScheduleItems.Add(
                    item);
            }


            StatusMessage =
                $"피킹리스트 {SummaryItems.Count:N0}건 / " +
                $"출고대기 {ScheduleItems.Count:N0}건";
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 출고 대기 삭제
    // =========================================================

    [RelayCommand]
    private async Task Delete()
    {
        try
        {
            if (SelectedSchedule == null)
            {
                _dialog.ShowWarning(
                    "삭제할 출고지시를 선택해주세요.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "출고 지시 데이터를 삭제하시겠습니까?",
                "확인"))
            {
                return;
            }


            var count =
                await _frm4103Api.DeleteAsync(
                    new Frm4103Dto.DeleteReqDto
                    {
                        ScheIndex =
                            SelectedSchedule.ScheIndex,

                        ScheLoca =
                            SelectedSchedule.ScheLoca
                    });


            if (count <= 0)
            {
                _dialog.ShowInfo(
                    "삭제된 출고 데이터가 없습니다.",
                    "확인");
            }
            else
            {
                _dialog.ShowInfo(
                    "출고지시 삭제 및 재고 원복이 완료되었습니다.",
                    "완료");
            }


            SelectedSchedule =
                null;


            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"출고지시 삭제 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 출고지시 확정
    // =========================================================

    [RelayCommand]
    private async Task Confirm()
    {
        try
        {
            if (ScheduleItems.Count == 0)
            {
                _dialog.ShowWarning(
                    "출고 지시할 데이터가 없습니다.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "출고 지시를 확정하시겠습니까?",
                "확인"))
            {
                return;
            }


            // =================================================
            // 현재 로그인 User ID
            // =================================================

            var userId =
                _currentUser.User.UserId;


            var result =
                await _frm4103Api.ConfirmAsync(
                    new Frm4103Dto.ConfirmReqDto
                    {
                        UserId =
                            userId
                    });


            if (result == null)
            {
                _dialog.ShowWarning(
                    "출고지시 결과를 확인할 수 없습니다.",
                    "오류");

                return;
            }


            if (!result.Success)
            {
                _dialog.ShowWarning(
                    result.Message
                    ?? "출고지시 실패",
                    "오류");

                return;
            }


            _dialog.ShowInfo(
                result.Message
                ?? "출고지시가 완료되었습니다.",
                "완료");


            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"출고지시 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 종료
    // =========================================================

    [RelayCommand]
    private void End()
    {
        // 기존 Document 닫기 로직 연결
    }
}