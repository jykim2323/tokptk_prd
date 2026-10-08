using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Controls;
using TOK.WMS.UI.Services.ETC;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;

using System.Windows.Controls;

namespace TOK.WMS.UI.ViewModels.MainMenus.Controls;

public partial class ErrorHistoryViewModel : DocumentViewModelBase
{
    private readonly IErrorHistoryApi _api;
    private readonly IDialogService _dialog;
    private readonly IExcelService _excel;
    private readonly ICurrentUserService _currentUser;

    public ErrorHistoryViewModel(
        IErrorHistoryApi api,
        IDialogService dialog,
        IExcelService excel,
        ICurrentUserService currentUser)
    {
        _api = api;
        _dialog = dialog;
        _excel = excel;
        _currentUser = currentUser;

        Title = "에러 이력 현황";
        ContentId = DocumentKeys.Frm2700;
    }

    public ObservableCollection<ErrorHistoryDto> Items { get; } = [];
    public bool CanDelete => _currentUser.User?.UserKind == 50;

    [ObservableProperty] private DateTime? _startDate = DateTime.Today;
    [ObservableProperty] private DateTime? _endDate = DateTime.Today;
    [ObservableProperty] private string _selectedCrane = string.Empty;
    [ObservableProperty] private ErrorHistoryDto? _selectedItem;
    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private string _statusMessage = "조회 대기 중";

    public Task ActivateAsync() => SearchAsync();

    [RelayCommand]
    private Task Search() => SearchAsync();

    [RelayCommand]
    private void ExportExcel(DataGrid? grid)
    {
        if (Items.Count == 0)
        {
            _dialog.ShowInfo("엑셀로 저장할 에러 이력이 없습니다.", "안내");
            return;
        }

        if (_excel.Export(Items, "에러이력현황", "에러이력", grid: grid))
            StatusMessage = $"에러 이력 {Items.Count}건을 엑셀로 저장했습니다.";
    }

    [RelayCommand]
    private async Task DeleteSelected()
    {
        if (!CanDelete)
        {
            _dialog.ShowWarning("관리자만 에러 이력을 삭제할 수 있습니다.", "권한 확인");
            return;
        }

        if (SelectedItem is null)
        {
            _dialog.ShowWarning("삭제할 에러 이력을 선택해 주세요.", "안내");
            return;
        }

        var target = SelectedItem;
        if (!_dialog.ShowConfirm(
                $"{target.OccurredAt} {target.CraneNo}호기 에러 이력을 삭제하시겠습니까?",
                "에러 이력 삭제 확인"))
        {
            return;
        }

        if (IsBusy)
            return;

        IsBusy = true;
        try
        {
            await _api.DeleteAsync(target.OccurredAtRaw, target.CraneNo);
            SelectedItem = null;
            StatusMessage = "에러 이력을 삭제했습니다.";
            await SearchCoreAsync();
        }
        catch (Exception ex)
        {
            StatusMessage = $"에러 이력 삭제 실패: {ex.Message}";
            _dialog.ShowWarning(StatusMessage, "오류");
        }
        finally
        {
            IsBusy = false;
        }
    }

    private async Task SearchAsync()
    {
        if (IsBusy)
            return;

        IsBusy = true;
        try
        {
            await SearchCoreAsync();
        }
        catch (Exception ex)
        {
            StatusMessage = $"에러 이력 조회 실패: {ex.Message}";
        }
        finally
        {
            IsBusy = false;
        }
    }

    private async Task SearchCoreAsync()
    {
        if (StartDate is null || EndDate is null)
            throw new InvalidOperationException("조회 시작일과 종료일을 선택해 주세요.");

        if (StartDate.Value.Date > EndDate.Value.Date)
            throw new InvalidOperationException("조회 시작일은 종료일보다 늦을 수 없습니다.");

        var craneNo = string.IsNullOrWhiteSpace(SelectedCrane)
            ? null
            : SelectedCrane.Trim();

        var rows = await _api.SearchAsync(StartDate.Value, EndDate.Value, craneNo);
        Items.Clear();
        foreach (var row in rows)
            Items.Add(row);

        StatusMessage = $"에러 이력 {Items.Count:N0}건";
    }
}
