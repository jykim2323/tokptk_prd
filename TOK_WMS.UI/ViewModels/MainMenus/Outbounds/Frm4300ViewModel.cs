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

public partial class Frm4300ViewModel : DocumentViewModelBase
{
    private readonly IFrm4300Api _frm4300Api;

    private readonly IDialogService _dialog;

    private readonly IExcelService _excelService;

    private readonly ICurrentUserService _currentUser;


    // =========================================================
    // 검색
    // =========================================================

    [ObservableProperty]
    private string _searchText =
        string.Empty;


    [ObservableProperty]
    private Frm4300Dto.SearchTypeDto? _selectedSearchType;


    // =========================================================
    // Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm4300Dto.ResDto> _items =
        [];


    [ObservableProperty]
    private Frm4300Dto.ResDto? _selectedItem;


    [ObservableProperty]
    private int _recordCount;


    [ObservableProperty]
    private string _statusMessage =
        string.Empty;


    // =========================================================
    // 권한
    // =========================================================

    [ObservableProperty]
    private bool _isAdmin;


    // =========================================================
    // 검색조건
    // =========================================================

    public ObservableCollection<Frm4300Dto.SearchTypeDto> SearchTypes { get; } =
    [
        new()
        {
            Name = "ALL",
            Value = "ALL"
        },

        new()
        {
            Name = "품목코드",
            Value = "CODE"
        },

        new()
        {
            Name = "품목명",
            Value = "NAME"
        },

        new()
        {
            Name = "LOT-NO",
            Value = "LOTNO"
        },

        new()
        {
            Name = "재고위치",
            Value = "LOCA"
        }
    ];


    public Frm4300ViewModel(
        IFrm4300Api frm4300Api,
        IDialogService dialog,
        IExcelService excelService,
        ICurrentUserService currentUser)
    {
        _frm4300Api =
            frm4300Api;


        _dialog =
            dialog;


        _excelService =
            excelService;


        _currentUser =
            currentUser;


        SelectedSearchType =
            SearchTypes[0];


        IsAdmin =
            _currentUser.User?.UserKind ==
            50;


        Title =
            "미출고 현황";


        ContentId =
            DocumentKeys.Frm4300;
    }


    // =========================================================
    // 조회
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var reqDto =
                new Frm4300Dto.ReqDto
                {
                    SearchType =
                        SelectedSearchType?.Value
                        ?? "ALL",

                    SearchText =
                        SearchText?.Trim()
                };


            var result =
                await _frm4300Api
                    .SearchAsync(
                        reqDto);


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
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"조회 실패: {ex.Message}",
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
                    "관리자만 삭제할 수 있습니다.",
                    "확인");

                return;
            }


            if (SelectedItem == null)
            {
                _dialog.ShowMessage(
                    "삭제할 데이터를 선택해주세요.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "출고 이력 데이터를 삭제하시겠습니까?",
                "확인"))
            {
                return;
            }


            var reqDto =
                new Frm4300Dto.DeleteReqDto
                {
                    Items =
                    [
                        new Frm4300Dto.DeleteItemDto
                        {
                            OuptIndex =
                                SelectedItem.OuptIndex,

                            OuptCode =
                                SelectedItem.OuptCode,

                            OuptLotno =
                                SelectedItem.OuptLotno,

                            OuptCust =
                                SelectedItem.OuptCust,

                            OuptLoca =
                                SelectedItem.OuptLoca
                        }
                    ]
                };


            var result =
                await _frm4300Api
                    .DeleteAsync(
                        reqDto);


            _dialog.ShowMessage(
                $"삭제 완료: {result:N0}건",
                "완료");


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
    // 수동출고 완료
    // =========================================================

    [RelayCommand]
    private async Task Complete()
    {
        try
        {
            if (SelectedItem == null)
            {
                _dialog.ShowMessage(
                    "출고 완료할 데이터를 선택해주세요.",
                    "확인");

                return;
            }


            var pltNo =
                SelectedItem.OuptPltno?
                    .Trim()
                ?? string.Empty;


            if (string.IsNullOrWhiteSpace(
                pltNo))
            {
                _dialog.ShowMessage(
                    "PLT-NO가 없습니다.",
                    "오류");

                return;
            }


            // =================================================
            // 동일 PLT 미출고 건수
            // =================================================

            var count =
                await _frm4300Api
                    .PendingCountAsync(
                        pltNo);


            string message;


            if (count > 1)
            {
                message =
                    $"선택하신 파렛트 [{pltNo}]에는 총 {count:N0}건의 출고 지시가 있습니다.\n\n" +
                    "이 작업은 해당 파렛트의 모든 품목을 일괄 출고 완료 처리합니다.\n\n" +
                    "계속 진행하시겠습니까?";
            }
            else
            {
                message =
                    "제품을 출고 완료하시겠습니까?";
            }


            if (!_dialog.ShowConfirm(
                message,
                "수동출고 완료"))
            {
                return;
            }


            var reqDto =
                new Frm4300Dto.CompleteReqDto
                {
                    OuptIndex =
                        SelectedItem.OuptIndex,

                    OuptPltno =
                        SelectedItem.OuptPltno,

                    OuptLoca =
                        SelectedItem.OuptLoca,

                    UserId =
                        _currentUser.User?.UserId
                        ?? string.Empty
                };


            var result =
                await _frm4300Api
                    .CompleteAsync(
                        reqDto);


            if (result == null)
            {
                _dialog.ShowMessage(
                    "수동출고 처리 결과가 없습니다.",
                    "오류");

                return;
            }


            if (!result.Success)
            {
                _dialog.ShowMessage(
                    result.Message
                    ?? "수동출고 처리에 실패했습니다.",
                    "오류");

                return;
            }


            _dialog.ShowMessage(
                $"{result.Message}\n\n" +
                $"처리건수 : {result.CompleteCount:N0}건",
                "완료");


            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"수동출고 완료 실패: {ex.Message}",
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
            "현재 조회 결과를 엑셀로 저장하시겠습니까?",
            "확인"))
        {
            return;
        }


        var result =
            _excelService.Export(
                Items,
                "미출고현황",
                "미출고현황");


        if (result)
        {
            _dialog.ShowMessage(
                "엑셀 저장이 완료되었습니다.",
                "완료");
        }
    }
}