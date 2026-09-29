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

namespace TOK.WMS.UI.ViewModels.MainMenus.Controls;

public partial class TransferCompletionWaitViewModel : DocumentViewModelBase
{
    private readonly ITransferCompletionWaitApi _api;
    private readonly IDialogService _dialog;
    private readonly IExcelService _excel;
    private readonly ICurrentUserService _currentUser;

    public TransferCompletionWaitViewModel(
        ITransferCompletionWaitApi api,
        IDialogService dialog,
        IExcelService excel,
        ICurrentUserService currentUser)
    {
        _api = api;
        _dialog = dialog;
        _excel = excel;
        _currentUser = currentUser;

        Title = "입출고 완료 대기";
        ContentId = DocumentKeys.Frm2300;
    }

    public ObservableCollection<TransferCompletionWaitDto> Items { get; } = [];
    public bool CanDelete => _currentUser.User?.UserKind == 50;

    [ObservableProperty] private TransferCompletionWaitDto? _selectedItem;
    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private string _statusMessage = "조회 대기 중";

    public Task ActivateAsync() => SearchAsync();

    [RelayCommand]
    private Task Search() => SearchAsync();

    [RelayCommand]
    private void ExportExcel()
    {
        if (Items.Count == 0)
        {
            _dialog.ShowMessage("엑셀로 저장할 완료 대기 데이터가 없습니다.", "안내");
            return;
        }

        if (_excel.Export(Items, "입출고완료대기", "완료대기"))
            StatusMessage = $"완료 대기 {Items.Count}건을 엑셀로 저장했습니다.";
    }

    [RelayCommand]
    private async Task DeleteSelected()
    {
        if (!CanDelete)
        {
            _dialog.ShowMessage("관리자만 완료 대기 데이터를 삭제할 수 있습니다.", "권한 확인");
            return;
        }

        if (SelectedItem is null)
        {
            _dialog.ShowMessage("삭제할 완료 대기 데이터를 선택해 주세요.", "안내");
            return;
        }

        var target = SelectedItem;
        if (!_dialog.ShowConfirm(
                $"입출고 순번 {target.Sequence}을 삭제하시겠습니까?\n삭제하면 후속 재고·완료 처리가 진행되지 않을 수 있습니다.",
                "완료 대기 삭제 확인"))
        {
            return;
        }

        if (IsBusy)
            return;

        IsBusy = true;
        try
        {
            await _api.DeleteAsync(target.Sequence);
            SelectedItem = null;
            StatusMessage = $"{target.Sequence} 완료 대기 데이터를 삭제했습니다.";
            await SearchCoreAsync();
        }
        catch (Exception ex)
        {
            StatusMessage = $"완료 대기 삭제 실패: {ex.Message}";
            _dialog.ShowMessage(StatusMessage, "오류");
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
            StatusMessage = $"완료 대기 조회 실패: {ex.Message}";
        }
        finally
        {
            IsBusy = false;
        }
    }

    private async Task SearchCoreAsync()
    {
        var rows = await _api.GetAsync();
        Items.Clear();
        foreach (var row in rows)
            Items.Add(row);

        StatusMessage = $"완료 대기 {Items.Count:N0}건";
    }
}
