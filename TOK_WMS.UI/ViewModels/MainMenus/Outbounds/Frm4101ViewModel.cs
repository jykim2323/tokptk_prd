using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Outbounds;
using TOK.WMS.UI.Services.ETC;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Outbounds;

public partial class Frm4101ViewModel : DocumentViewModelBase
{
    private readonly IDialogService _dialog;
    private readonly IFrm4101Api _frm4101Api;
    private readonly IExcelService _excelService;


    // =========================================================
    // 시작 Line
    // Delphi LineEd
    // =========================================================

    [ObservableProperty]
    private string _startLine = "9";


    // =========================================================
    // 상태
    // =========================================================

    [ObservableProperty]
    private string _statusMessage = string.Empty;


    // =========================================================
    // Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<
        Frm4101Dto.ExcelRowDto> _items = [];


    [ObservableProperty]
    private Frm4101Dto.ExcelRowDto? _selectedItem;


    public Frm4101ViewModel(
        IFrm4101Api frm4101Api,
        IDialogService dialog,
        IExcelService excelService)
    {
        _frm4101Api = frm4101Api;
        _dialog = dialog;
        _excelService = excelService;

        Title = "출고 엑셀 UP LOAD";
        ContentId = DocumentKeys.Frm4101;
    }


    // =========================================================
    // Excel → Grid
    // Delphi ExlBtnClick
    // =========================================================

    [RelayCommand]
    private void ExcelLoad()
    {
        try
        {
            // Delphi:
            // If StringGrid1.Cells[1, 1] <> '' Then Exit;
            if (Items.Count > 0)
                return;


            // Delphi:
            // if Length(Trim(LineEd.Text)) = 0 then exit;
            if (string.IsNullOrWhiteSpace(StartLine))
                return;


            if (!int.TryParse(
                    StartLine.Trim(),
                    out var startLine))
            {
                _dialog.ShowMessage(
                    "시작 Line을 숫자로 입력해주세요.",
                    "오류");

                return;
            }


            if (startLine < 0)
            {
                _dialog.ShowMessage(
                    "시작 Line은 0 이상이어야 합니다.",
                    "오류");

                return;
            }


            // =====================================================
            // 여기서 실제 OpenFileDialog 뜸
            // =====================================================

            var result =
                _excelService.ImportFrm4101(startLine);


            // 파일 선택 취소
            if (result == null)
                return;


            Items.Clear();


            foreach (var item in result)
            {
                Items.Add(item);
            }


            StatusMessage =
                $"Total = {Items.Count:N0} 엑셀 데이터.";
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"Excel 불러오기 실패: {ex.Message}",
                "오류");
        }
    }

    // =========================================================
    // 출고등록
    // Delphi UpdateBitBtnClick
    // =========================================================

    [RelayCommand]
    private async Task Save()
    {
        try
        {
            if (Items.Count == 0)
            {
                _dialog.ShowMessage(
                    "등록할 출고 데이터가 없습니다.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "출고 지시에 등록합니까?",
                "확인"))
            {
                return;
            }


            if (!_dialog.ShowConfirm(
                "기존 출고지시 데이터는 전부 삭제됩니다.\n" +
                "계속하시겠습니까?",
                "확인"))
            {
                return;
            }


            var result =
                await _frm4101Api.SaveAsync(
                    new Frm4101Dto.SaveReqDto
                    {
                        Items =
                            Items.ToList()
                    });


            if (result == null)
            {
                _dialog.ShowMessage(
                    "출고지시 등록 결과가 없습니다.",
                    "오류");

                return;
            }


            _dialog.ShowMessage(
                $"출고지시 등록 건수\n\n" +
                $"차수 [{result.Chasu}]\n" +
                $"등록 {result.Count:N0}건",
                "완료");


            StatusMessage =
                $"출고지시 등록건수 " +
                $"차수 [{result.Chasu}] = {result.Count:N0}";


            Clear();
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"출고지시 등록 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // 선택 Line 삭제
    // Delphi CancelSBClick
    // =========================================================

    [RelayCommand]
    private void DeleteRow()
    {
        if (SelectedItem == null)
        {
            _dialog.ShowMessage(
                "삭제할 데이터를 선택해주세요.",
                "확인");

            return;
        }


        if (!_dialog.ShowConfirm(
            "선택한 Line을 삭제하시겠습니까?",
            "확인"))
        {
            return;
        }


        Items.Remove(
            SelectedItem);


        SelectedItem =
            null;


        // NO 재정렬
        Renumber();


        StatusMessage =
            $"Total = {Items.Count:N0} 엑셀 데이터.";
    }


    // =========================================================
    // 전체삭제
    // Delphi DeleteBitBtnClick
    //
    // DB 삭제 아님
    // 화면 Grid 전체 초기화
    // =========================================================

    [RelayCommand]
    private void Clear()
    {
        Items.Clear();

        SelectedItem =
            null;


        StatusMessage =
            string.Empty;
    }


    // =========================================================
    // 종료
    // =========================================================

    [RelayCommand]
    private void End()
    {
        Clear();

    }


    // =========================================================
    // NO 재정렬
    // =========================================================

    private void Renumber()
    {
        for (var i = 0;
             i < Items.Count;
             i++)
        {
            Items[i].No =
                i + 1;
        }
    }
}