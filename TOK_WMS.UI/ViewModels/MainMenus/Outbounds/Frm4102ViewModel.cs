using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Outbounds;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Outbounds;

public partial class Frm4102ViewModel
    : DocumentViewModelBase
{
    private readonly IFrm4102Api _frm4102Api;
    private readonly IDialogService _dialog;
    private readonly IExcelService _excelService;
    private readonly ICurrentUserService _currentUser;


    // =========================================================
    // 검색
    // =========================================================

    [ObservableProperty]
    private DateTime? _outDate =
        DateTime.Today;

    [ObservableProperty]
    private string _itemCode =
        string.Empty;


    // =========================================================
    // Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<
        Frm4102Dto.ResDto> _items = [];

    [ObservableProperty]
    private Frm4102Dto.ResDto? _selectedItem;


    // =========================================================
    // 전체 선택
    // =========================================================

    [ObservableProperty]
    private bool _isAllSelected;


    // =========================================================
    // 상태
    // =========================================================

    [ObservableProperty]
    private int _recordCount;

    [ObservableProperty]
    private string _statusMessage =
        string.Empty;


    public Frm4102ViewModel(
        IFrm4102Api frm4102Api,
        IDialogService dialog,
        IExcelService excelService,
        ICurrentUserService currentUser)
    {
        _frm4102Api =
            frm4102Api;

        _dialog =
            dialog;

        _excelService =
            excelService;

        _currentUser = currentUser;


        Title =
            "출고지시";

        ContentId =
            DocumentKeys.Frm4102;


        _ = Search();
    }


    // =========================================================
    // 조회
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var result =
                await _frm4102Api.SearchAsync(
                    new Frm4102Dto.ReqDto
                    {
                        OutDate =
                            OutDate?
                                .ToString(
                                    "yyyyMMdd"),

                        ItemCode =
                            ItemCode?
                                .Trim()
                    });


            Items.Clear();


            foreach (var item in result ?? [])
            {
                item.IsSelected =
                    IsAllSelected;

                Items.Add(
                    item);
            }


            RecordCount =
                Items.Count;


            StatusMessage =
                $"조회 {RecordCount:N0}건";
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 전체선택
    // =========================================================

    partial void OnIsAllSelectedChanged(
        bool value)
    {
        foreach (var item in Items)
        {
            item.IsSelected =
                value;
        }
    }


    // =========================================================
    // 출고확정
    // =========================================================

    [RelayCommand]
    private async Task Reserve()
    {
        try
        {
            var selected =
                Items
                    .Where(
                        x =>
                            x.IsSelected)
                    .ToList();


            if (selected.Count == 0)
            {
                _dialog.ShowMessage(
                    "출고확정할 데이터를 선택해주세요.",
                    "확인");

                return;
            }


            var chasu =
                selected.First()
                    .HoChasu
                ?? string.Empty;


            if (!_dialog.ShowConfirm(
                $"차수 [{chasu}] 출고 예약 작업을 실행합니까?",
                "확인"))
            {
                return;
            }


            var reqDto =
                new Frm4102Dto.ReserveReqDto
                {
                    // 실제 로그인 사용자
                    UserId =
                        _currentUser?.User?.UserId ?? string.Empty,

                    Items =
                        selected
                            .Select(
                                x =>
                                    new Frm4102Dto.ReserveItemDto
                                    {
                                        HoChasu =
                                            x.HoChasu,

                                        HoDate =
                                            x.HoDate,

                                        HoCode =
                                            x.HoCode,

                                        HoLotno =
                                            x.HoLotno,

                                        HoCust =
                                            x.HoCust,

                                        HoQty =
                                            x.HoQty,

                                        HoBoxno =
                                            x.HoBoxno,

                                        HoRemark =
                                            x.HoRemark
                                    })
                            .ToList()
                };


            var result =
                await _frm4102Api.ReserveAsync(
                    reqDto);


            if (result == null)
            {
                _dialog.ShowMessage(
                    "출고확정 결과를 확인할 수 없습니다.",
                    "오류");

                return;
            }


            if (!result.Success)
            {
                _dialog.ShowMessage(
                    result.Message
                    ?? "출고확정 실패",
                    "오류");

                return;
            }


            _dialog.ShowMessage(
                result.Message
                ?? "출고 예약 작업을 완료했습니다.",
                "완료");


            IsAllSelected =
                false;


            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"출고확정 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 선택삭제
    // =========================================================

    [RelayCommand]
    private async Task Delete()
    {
        try
        {
            var selected =
                Items
                    .Where(
                        x =>
                            x.IsSelected)
                    .ToList();


            if (selected.Count == 0)
            {
                _dialog.ShowMessage(
                    "삭제할 데이터를 선택해주세요.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                $"선택한 {selected.Count:N0}건을 삭제하시겠습니까?",
                "확인"))
            {
                return;
            }


            var deleted =
                0;


            foreach (var item in selected)
            {
                deleted +=
                    await _frm4102Api.DeleteAsync(
                        new Frm4102Dto.DeleteReqDto
                        {
                            HoDate =
                                item.HoDate,

                            HoChasu =
                                item.HoChasu,

                            HoCode =
                                item.HoCode,

                            HoLotno =
                                item.HoLotno,

                            HoCust =
                                item.HoCust
                        });
            }


            _dialog.ShowMessage(
                $"{deleted:N0}건 삭제했습니다.",
                "완료");


            IsAllSelected =
                false;


            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"삭제 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 전체삭제
    // =========================================================

    [RelayCommand]
    private async Task DeleteAll()
    {
        try
        {
            if (!_dialog.ShowConfirm(
                "정말로 출고지시 데이터를 전부 삭제하시겠습니까?",
                "확인"))
            {
                return;
            }


            var count =
                await _frm4102Api.DeleteAllAsync();


            _dialog.ShowMessage(
                $"{count:N0}건 삭제했습니다.",
                "완료");


            IsAllSelected =
                false;


            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"전체삭제 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // Excel
    // =========================================================

    [RelayCommand]
    private void Excel()
    {
        if (Items.Count == 0)
        {
            _dialog.ShowMessage(
                "엑셀로 저장할 데이터가 없습니다.",
                "확인");

            return;
        }


        if (!_dialog.ShowConfirm(
            "엑셀로 저장하시겠습니까?",
            "확인"))
        {
            return;
        }


        var result =
            _excelService.Export(
                Items,
                "출고지시",
                "출고 지시 데이터");


        if (result)
        {
            _dialog.ShowMessage(
                "엑셀 저장이 완료되었습니다.",
                "완료");
        }
    }


    // =========================================================
    // 종료
    // =========================================================

    [RelayCommand]
    private void End()
    {
        // 기존 Document 닫기 패턴 연결
    }
}