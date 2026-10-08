using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Standards;
using TOK.WMS.UI.Services.ETC;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.Services.Interfaces.Popup;
using TOK.WMS.UI.ViewModels.Base;

using System.Windows.Controls;

namespace TOK.WMS.UI.ViewModels.MainMenus.Standards;

public partial class Frm1100ViewModel : DocumentViewModelBase
{
    private readonly IFrm1100Api _frm1100Api;
    private readonly IDialogService _dialog;
    private readonly IExcelService _excelService;
    private readonly ICurrentUserService _currentUser;
    private readonly IWindowService _windowService;


    // =========================================================
    // 검색 조건
    // =========================================================

    [ObservableProperty]
    private string _itemCode = "0";


    // =========================================================
    // Grid
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<Frm1100Dto.ResDto> _items = [];


    [ObservableProperty]
    private Frm1100Dto.ResDto? _selectedItem;


    [ObservableProperty]
    private int _recordCount;


    [ObservableProperty]
    private string _statusMessage = string.Empty;


    // =========================================================
    // 관리자 여부
    // =========================================================

    [ObservableProperty]
    private bool _isAdmin;


    // =========================================================
    // 생성자
    // =========================================================

    public Frm1100ViewModel(
        IFrm1100Api frm1100Api,
        IDialogService dialog,
        IExcelService excelService,
        ICurrentUserService currentUser,
        IWindowService windowService)
    {
        _frm1100Api = frm1100Api;
        _dialog = dialog;
        _excelService = excelService;
        _currentUser = currentUser;
        _windowService = windowService;


        IsAdmin =
            _currentUser.User?.UserKind == 50;


        Title = "품목 코드 관리";

        ContentId = DocumentKeys.Frm1100;
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
    // 조회
    // =========================================================

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var reqDto =
                new Frm1100Dto.ReqDto
                {
                    ItemCode =
                        string.IsNullOrWhiteSpace(ItemCode)
                            ? "0"
                            : ItemCode.Trim()
                };


            var result =
                await _frm1100Api.SearchAsync(
                    reqDto);


            Items.Clear();


            foreach (var item in result ?? [])
            {
                Items.Add(item);
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
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"조회 실패: {ex.Message}",
                "오류");
        }
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
                _dialog.ShowWarning(
                    "관리자만 품목을 등록할 수 있습니다.",
                    "확인");

                return;
            }


            // =================================================
            // 등록은 빈 데이터 전달
            // =================================================

            var item =
                new SFrm1100Dto.InitDto();


            _windowService.ShowSFrm1100(
                item,
                "INSERT");


            // =================================================
            // 팝업 종료 후 재조회
            // =================================================

            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"등록 화면 실행 실패: {ex.Message}",
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
                _dialog.ShowWarning(
                    "관리자만 품목을 수정할 수 있습니다.",
                    "확인");

                return;
            }


            if (SelectedItem == null)
            {
                _dialog.ShowWarning(
                    "수정할 품목을 선택해주세요.",
                    "확인");

                return;
            }


            var item =
                new SFrm1100Dto.InitDto
                {
                    MastCode =
                        SelectedItem.MastCode,

                    MastBcode =
                        SelectedItem.MastBcode,

                    MastName =
                        SelectedItem.MastName,

                    MastUnit =
                        SelectedItem.MastUnit,

                    MastWeight =
                        SelectedItem.MastWeight,

                    MastGubn1 =
                        SelectedItem.MastGubn1,

                    MastGubn2 =
                        SelectedItem.MastGubn2,

                    MastGubn3 =
                        SelectedItem.MastGubn3,

                    MastRef1 =
                        SelectedItem.MastRef1
                };


            _windowService.ShowSFrm1100(
                item,
                "UPDATE");


            // =================================================
            // 팝업 종료 후 재조회
            // =================================================

            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"수정 화면 실행 실패: {ex.Message}",
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
                _dialog.ShowWarning(
                    "관리자만 품목을 삭제할 수 있습니다.",
                    "확인");

                return;
            }


            if (SelectedItem == null)
            {
                _dialog.ShowWarning(
                    "삭제할 품목을 선택해주세요.",
                    "확인");

                return;
            }


            var item =
                new SFrm1100Dto.InitDto
                {
                    MastCode =
                        SelectedItem.MastCode,

                    MastBcode =
                        SelectedItem.MastBcode,

                    MastName =
                        SelectedItem.MastName,

                    MastUnit =
                        SelectedItem.MastUnit,

                    MastWeight =
                        SelectedItem.MastWeight,

                    MastGubn1 =
                        SelectedItem.MastGubn1,

                    MastGubn2 =
                        SelectedItem.MastGubn2,

                    MastGubn3 =
                        SelectedItem.MastGubn3,

                    MastRef1 =
                        SelectedItem.MastRef1
                };


            _windowService.ShowSFrm1100(
                item,
                "DELETE");


            // =================================================
            // 팝업 종료 후 재조회
            // =================================================

            await Search();
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"삭제 화면 실행 실패: {ex.Message}",
                "오류");
        }
    }


    // =========================================================
    // Excel
    // =========================================================

    [RelayCommand]
    private void Excel(DataGrid? grid)
    {
        try
        {
            if (Items.Count == 0)
            {
                _dialog.ShowInfo(
                    "엑셀로 저장할 데이터가 없습니다.",
                    "확인");

                return;
            }


            if (!_dialog.ShowConfirm(
                "해당 조회건을 엑셀로 저장할까요?",
                "확인"))
            {
                return;
            }


            var result =
                _excelService.Export(
                    Items,
                    "품목코드관리",
                    "품목코드관리", grid: grid);


            if (result)
            {
                _dialog.ShowInfo(
                    "엑셀 저장이 완료되었습니다.",
                    "완료");
            }
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning(
                $"엑셀 저장 실패: {ex.Message}",
                "오류");
        }
    }
}
