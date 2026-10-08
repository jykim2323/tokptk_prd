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

public partial class ScReservationViewModel : DocumentViewModelBase
{
    private readonly IScReservationApi _api;
    private readonly IDialogService _dialog;
    private readonly IExcelService _excel;
    private readonly ICurrentUserService _currentUser;

    public ScReservationViewModel(
        IScReservationApi api,
        IDialogService dialog,
        IExcelService excel,
        ICurrentUserService currentUser)
    {
        _api = api;
        _dialog = dialog;
        _excel = excel;
        _currentUser = currentUser;

        Title = "스태커 예약현황";
        ContentId = DocumentKeys.Frm2200;
    }

    public ObservableCollection<ScReservationDto> Items { get; } = [];
    public bool CanDelete => _currentUser.User?.UserKind == 50;

    [ObservableProperty] private string _selectedCrane = string.Empty;
    [ObservableProperty] private ScReservationDto? _selectedItem;
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
            _dialog.ShowInfo("엑셀로 저장할 예약 데이터가 없습니다.", "안내");
            return;
        }

        if (_excel.Export(Items, "스태커예약현황", "예약현황", grid: grid))
            StatusMessage = $"예약 {Items.Count}건을 엑셀로 저장했습니다.";
    }

    [RelayCommand]
    private async Task DeleteSelected()
    {
        if (!CanDelete)
        {
            _dialog.ShowWarning("관리자만 예약을 삭제할 수 있습니다.", "권한 확인");
            return;
        }

        if (SelectedItem is null)
        {
            _dialog.ShowWarning("삭제할 예약을 선택해 주세요.", "안내");
            return;
        }

        var target = SelectedItem;
        if (!_dialog.ShowConfirm(
                $"입출고 순번 {target.Sequence} 예약을 삭제하시겠습니까?\n예약된 저장위치 상태도 함께 원복됩니다.",
                "예약 삭제 확인"))
        {
            return;
        }

        if (IsBusy)
            return;

        IsBusy = true;
        try
        {
            await _api.DeleteAsync(target.CraneNo, target.Sequence);
            SelectedItem = null;
            StatusMessage = $"{target.Sequence} 예약을 삭제했습니다.";
            await SearchCoreAsync();
        }
        catch (Exception ex)
        {
            StatusMessage = $"예약 삭제 실패: {ex.Message}";
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
            StatusMessage = $"예약 조회 실패: {ex.Message}";
        }
        finally
        {
            IsBusy = false;
        }
    }

    private async Task SearchCoreAsync()
    {
        int? craneNo = null;
        if (!string.IsNullOrWhiteSpace(SelectedCrane))
        {
            if (!int.TryParse(SelectedCrane, out var parsed) || parsed is < 1 or > 7)
                throw new InvalidOperationException("조회 호기는 1에서 7 사이여야 합니다.");
            craneNo = parsed;
        }

        var rows = await _api.GetAsync(new ScReservationQueryDto { CraneNo = craneNo });
        Items.Clear();
        foreach (var row in rows)
            Items.Add(row);

        StatusMessage = $"예약 {Items.Count:N0}건";
    }
}
