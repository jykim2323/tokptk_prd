using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.ObjectModel;
using System.Windows;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Standards;
using TOK.WMS.UI.Views.MainMenus.Standards;

namespace TOK.WMS.UI.ViewModels.MainMenus.Standards;

public partial class MastDispViewModel
    : ObservableObject
{
    private readonly IMastDispApi _mastDispApi;

    private readonly IDialogService _dialog;


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
    private ObservableCollection<MastDispDto.ResDto> _items =
        [];


    [ObservableProperty]
    private MastDispDto.ResDto? _selectedItem;


    [ObservableProperty]
    private int _recordCount;


    [ObservableProperty]
    private string _statusMessage =
        string.Empty;


    // =========================================================
    // 최종 반환값
    // =========================================================

    public MastDispDto.ResDto? SelectedResult { get; private set; }


    public MastDispViewModel(
        IMastDispApi mastDispApi,
        IDialogService dialog)
    {
        _mastDispApi =
            mastDispApi;


        _dialog =
            dialog;
    }


    // =========================================================
    // Window 열기 전 초기화
    // =========================================================

    public void Initialize(
        string? searchText)
    {
        SearchText =
            searchText
            ?? string.Empty;


        SelectedItem =
            null;


        SelectedResult =
            null;


        Items.Clear();


        RecordCount =
            0;


        StatusMessage =
            string.Empty;
    }


    // =========================================================
    // Loaded
    //
    // Delphi FormCreate → SB_AllViewClick
    // =========================================================

    [RelayCommand]
    private async Task Loaded()
    {
        await AllSearch();
    }


    // =========================================================
    // 검색
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var reqDto =
                new MastDispDto.ReqDto
                {
                    SearchText =
                        SearchText.Trim()
                };


            var result =
                await _mastDispApi
                    .SearchAsync(
                        reqDto);


            SetItems(
                result);
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"품목 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 전체보기
    // =========================================================

    [RelayCommand]
    private async Task AllSearch()
    {
        try
        {
            var result =
                await _mastDispApi
                    .AllSearchAsync();


            SetItems(
                result);
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"품목 전체 조회 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 조회 결과
    // =========================================================

    private void SetItems(
        IEnumerable<MastDispDto.ResDto>? result)
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


        SelectedItem =
            null;
    }


    // =========================================================
    // 품목 선택
    //
    // Delphi DBGrid1CellClick
    // jj_code / jj_name 대신 DTO 반환
    // =========================================================

    [RelayCommand]
    private void SelectItem(
        MastDispDto.ResDto? item)
    {
        if (item == null)
            return;


        SelectedResult =
            item;


        var window =
            Application.Current.Windows
                .OfType<MastDispView>()
                .FirstOrDefault();


        window?.Close();
    }


    // =========================================================
    // 종료
    // =========================================================

    [RelayCommand]
    private void Close(
        Window? window)
    {
        SelectedResult =
            null;


        window?.Close();
    }
}