using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inventory;
using TOK.WMS.UI.Services.Interfaces.Popup;
using TOK.WMS.UI.ViewModels.Base;
using TOK.WMS.UI.Views.MainMenus.Inventory;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public partial class Frm6100ViewModel : DocumentViewModelBase
{
    private readonly IDialogService _dialog;
    private readonly IFrm6100Api _frm6100Api;
    private readonly IWindowService _windowService;

    [ObservableProperty] private string _lstkLoca = string.Empty;
    [ObservableProperty] private string _lstkBk = string.Empty;
    [ObservableProperty] private string _lstkBy = string.Empty;
    [ObservableProperty] private string _lstkLv = string.Empty;
    [ObservableProperty] private string _lstkFlag = string.Empty;
    [ObservableProperty] private string _lstkIndate = string.Empty;
    [ObservableProperty] private string _lstkIntime = string.Empty;
    [ObservableProperty] private string _lstkPltno = string.Empty;


    [ObservableProperty] private ObservableCollection<Frm6100Dto.ResDto> _items = [];

    [ObservableProperty] private ObservableCollection<Frm6100Dto.SubkDto> _subkItems = [];

    public Frm6100ViewModel(IFrm6100Api frm6100Api, IDialogService dialog, IWindowService windowService)
    {
        _frm6100Api = frm6100Api;
        _dialog = dialog;
        _windowService = windowService;

        Title = "저장 위치 조회";
        ContentId = DocumentKeys.Frm6100;
    }

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var q = new Frm6100Dto
            {
                LstkLoca = LstkLoca
            };
            var result = await _frm6100Api.SearchAsync(q);
            Items.Clear();
            foreach (var h in result ?? []) Items.Add(h);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Modify(Frm6100Dto.ResDto item)
    {
        try
        {
            if (item == null)
                return;

            _windowService.ShowSFrm6110(item);

            this.SearchCommand.Execute(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task SubkSearch(Frm6100Dto.ResDto? item)
    {
        try
        {
            string loca = item?.LstkLoca ?? LstkLoca;

            var result = await _frm6100Api.SubkSearchAsync(loca);
            SubkItems.Clear();
            foreach (var h in result ?? []) SubkItems.Add(h);

        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }


    [RelayCommand]
    private async Task Delete(Frm6100Dto.ResDto? item)
    {
        try
        {
            if(!_dialog.ShowConfirm("정말로 확정 합니까.?", "확인"))
            {
                return;
            }

            //TRUE 재고 있음
            var subkcheckResult = await _frm6100Api.SubkCheckAsync(item?.LstkLoca ?? string.Empty); 

            if (subkcheckResult)
            {
                if (!_dialog.ShowConfirm("재고가 있습니다.확정 합니까? (재고가 지워집니다)", "확인"))
                {
                    return;
                }

                var deleteCount = await _frm6100Api.DeleteAsync(item.LstkLoca ?? string.Empty);

                if (deleteCount <= 0)
                {
                    _dialog.ShowMessage($"재고위치(T2MISUBK) '{item.LstkLoca}' 삭제 {deleteCount} 건 오류", "오류");
                    return;
                }

                var lstkclearCount = await _frm6100Api.LstkClearAsync(item.LstkLoca ?? string.Empty);

                if (lstkclearCount <= 0)
                {
                    _dialog.ShowMessage($"재고위치(T2MISUBK) '{item.LstkLoca}' 삭제 {deleteCount} 건 오류", "오류");
                    return;
                }

                this.SearchCommand.Execute(null);
                this.subkSearchCommand?.Execute(null);
            }
        }
        catch (Exception ex)
        {
            //StatusMessage = ex.Message;
            _dialog.ShowMessage($"삭제 실패: {ex.Message}", "오류");
        }
    }
}

