using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Outbounds;
using TOK.WMS.UI.Services.ETC;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Outbounds;

public partial class Frm4400ViewModel : DocumentViewModelBase
{
    private readonly IFrm4400Api _frm4400Api;

    private readonly IDialogService _dialog;

    private readonly IExcelService _excelService;

    private readonly ICurrentUserService _currentUser;


    // =========================================================
    // 날짜
    // =========================================================

    [ObservableProperty]
    private DateTime? _fromDate =
        DateTime.Today;


    [ObservableProperty]
    private DateTime? _toDate =
        DateTime.Today;


    // =========================================================
    // 검색
    // =========================================================

    [ObservableProperty]
    private string _searchText =
        string.Empty;


    [ObservableProperty]
    private Frm4400Dto.SearchTypeDto? _selectedSearchType;


    // =========================================================
    // 납품처
    // =========================================================

    [ObservableProperty]
    private Frm4400Dto.CustomerDto? _selectedCustomer;


    [ObservableProperty]
    private ObservableCollection<Frm4400Dto.CustomerDto> _customers =
        [];


    // =========================================================
    // Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm4400Dto.ResDto> _items =
        [];


    [ObservableProperty]
    private Frm4400Dto.ResDto? _selectedItem;


    [ObservableProperty]
    private int _recordCount;


    // =========================================================
    // 상태
    // =========================================================

    [ObservableProperty]
    private string _statusMessage =
        string.Empty;


    [ObservableProperty]
    private bool _isAdmin;


    // =========================================================
    // 검색 조건
    // =========================================================

    public ObservableCollection<Frm4400Dto.SearchTypeDto> SearchTypes { get; } =
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


    public Frm4400ViewModel(
        IFrm4400Api frm4400Api,
        IDialogService dialog,
        IExcelService excelService,
        ICurrentUserService currentUser)
    {
        _frm4400Api =
            frm4400Api;


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
            "출고 이력 현황";


        ContentId =
            DocumentKeys.Frm4400;
    }


    // =========================================================
    // Loaded
    // =========================================================

    [RelayCommand]
    private async Task Loaded()
    {
        await LoadCustomers();

        await Search();
    }


    // =========================================================
    // 납품처 조회
    // =========================================================

    private async Task LoadCustomers()
    {
        try
        {
            var result =
                await _frm4400Api
                    .CustomerSearchAsync();


            Customers.Clear();


            // 전체 조회용
            Customers.Add(
                new Frm4400Dto.CustomerDto
                {
                    Name =
                        "ALL"
                });


            foreach (var item in
                result ?? [])
            {
                Customers.Add(
                    item);
            }


            SelectedCustomer =
                Customers[0];
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"납품처 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 조회
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            if (FromDate == null ||
                ToDate == null)
            {
                _dialog.ShowMessage(
                    "출고일자를 선택해주세요.",
                    "확인");

                return;
            }


            if (FromDate >
                ToDate)
            {
                _dialog.ShowMessage(
                    "시작일자가 종료일자보다 클 수 없습니다.",
                    "확인");

                return;
            }


            var customer =
                SelectedCustomer?.Name;


            if (customer ==
                "ALL")
            {
                customer =
                    string.Empty;
            }


            var reqDto =
                new Frm4400Dto.ReqDto
                {
                    FromDate =
                        FromDate.Value
                            .ToString(
                                "yyyyMMdd"),

                    ToDate =
                        ToDate.Value
                            .ToString(
                                "yyyyMMdd"),

                    SearchType =
                        SelectedSearchType?.Value
                        ?? "ALL",

                    SearchText =
                        SearchText?
                            .Trim(),

                    Customer =
                        customer
                };


            var result =
                await _frm4400Api
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
                "선택한 출고 이력 데이터를 삭제하시겠습니까?",
                "확인"))
            {
                return;
            }


            var reqDto =
                new Frm4400Dto.DeleteReqDto
                {
                    OuptIndex =
                        SelectedItem.OuptIndex,

                    OuptCode =
                        SelectedItem.OuptCode,

                    OuptLotno =
                        SelectedItem.OuptLotno
                };


            var result =
                await _frm4400Api
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
            "현재 출고이력 조회 결과를 엑셀로 저장하시겠습니까?",
            "확인"))
        {
            return;
        }


        var result =
            _excelService.Export(
                Items,
                "출고이력현황",
                "출고이력현황");


        if (result)
        {
            _dialog.ShowMessage(
                "엑셀 저장이 완료되었습니다.",
                "완료");
        }
    }
}