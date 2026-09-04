using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Collections.ObjectModel;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.Api.Inventory;
using TOK.WMS.UI.Services.Interfaces.Popup;
using TOK.WMS.UI.ViewModels.Base;
using TOK.WMS.UI.ViewModels.MainMenus;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inventory;

public partial class Frm6900ViewModel : DocumentViewModelBase
{
    private readonly IDialogService _dialog;
    private readonly IFrm6900Api _frm6900Api;
    private readonly IWindowService _windowService;

    private readonly MainViewModel _mainViewModel;

    [ObservableProperty] private string _lstkLoca = string.Empty;
    [ObservableProperty] private string _lstkBk = string.Empty;
    [ObservableProperty] private string _lstkBy = string.Empty;
    [ObservableProperty] private string _lstkLv = string.Empty;
    [ObservableProperty] private string _lstkFlag = string.Empty;
    [ObservableProperty] private string _lstkIndate = string.Empty;
    [ObservableProperty] private string _lstkIntime = string.Empty;
    [ObservableProperty] private string _lstkPltno = string.Empty;
    [ObservableProperty] private string _subkWgtTotal = string.Empty;


    [ObservableProperty] private ObservableCollection<Frm6900Dto.ResDto> _items = [];
    [ObservableProperty] private ObservableCollection<Frm6900Dto.SubkDto> _subkItems = [];
    [ObservableProperty] private Frm6900Dto.ResDto? _selectedItem;
    [ObservableProperty] private Frm6900Dto.SubkDto? _selectedSubkItem;



    public Frm6900ViewModel(IFrm6900Api frm6900Api, IDialogService dialog, IWindowService windowService, MainViewModel mainViewModel)
    {
        _frm6900Api = frm6900Api;
        _dialog = dialog;
        _windowService = windowService;
        _mainViewModel = mainViewModel;

        Title = "PLT-NO 관리";
        ContentId = DocumentKeys.Frm6900;

    }

    [RelayCommand]
    private async Task ValidateSelected()
    {
        //if (string.IsNullOrEmpty(SelectedItem?.SubkPltno))
        //{
        //    SelectedItem?.IsClicked = false;
        //    return;
        //}

        if(!await _frm6900Api.TrackingAsync(SelectedItem?.SubkPltno ?? string.Empty))
        {
            _dialog.ShowMessage($"{SelectedItem?.SubkPltno} 해당 PLT-NO는 현재 입/출고 작업이 진행 중입니다.", "오류");
            SelectedItem?.IsClicked = false;
            return;
        }

        if (!await _frm6900Api.LstkCheckAsync(SelectedItem?.SubkPltno ?? string.Empty))
        {
            _dialog.ShowMessage($"{SelectedItem?.SubkPltno}  이미 랙 재고로 등록된 파레트입니다.", "오류");
            SelectedItem?.IsClicked = false;
            return;
        }

        if (!await _frm6900Api.SubkLocaCheckAsync(SelectedItem?.SubkPltno ?? string.Empty))
        {
            _dialog.ShowMessage($"{SelectedItem?.SubkPltno}  위치  {SelectedItem?.SubkLoca} 가 지정된 파레트는 선택할 수 없습니다.", "오류");
            SelectedItem?.IsClicked = false;
            return;
        }

        SelectedItem?.IsClicked = true;

        // 검증 통과
    }

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var reqDto = new Frm6900Dto.ReqDto
            {
                SubkLoca = SelectedItem?.SubkLoca ?? string.Empty,
                SubkPltno = SelectedItem?.SubkPltno ?? string.Empty,
            };

            var result = await _frm6900Api.SearchAsync(reqDto);
            Items.Clear();
            foreach (var h in result ?? []) Items.Add(h);


            this.SubkSearchCommand?.Execute(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task SubkSearch()
    {
        try
        {
            if (SelectedItem?.SubkLoca == null)
            {
                return;
            }

            var result = await _frm6900Api.SubkSearchAsync(new Frm6900Dto.ReqDto
            {
                SubkLoca = SelectedItem?.SubkLoca,
                SubkPltno = SelectedItem?.SubkPltno
            });

            SubkItems.Clear();

            foreach (var h in result ?? []) SubkItems.Add(h);


            SubkWgtTotal = SubkItems.Sum(x => decimal.TryParse(x.SubkWgt, out var wgt) ? wgt : 0).ToString();

        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task SaveLocaSearch()
    {
        try
        {
            _mainViewModel.OpenDocumentCommand.Execute(DocumentKeys.Frm6100);

            this.SearchCommand.Execute(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"화면 생성 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task PltnoInsert() 
    {
        try
        {
            _mainViewModel.OpenDocumentCommand.Execute(DocumentKeys.Frm3100);

            this.SearchCommand.Execute(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"화면 생성 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Register(Frm6900Dto.SubkDto item)
    {
        try
        {
            if(string.IsNullOrEmpty(SelectedItem?.SubkPltno))
            {
                _dialog.ShowMessage($" 등록할 파렛트 번호(PLT-NO)를 입력해주세요 !", "오류");
                return;
            }

            if (item == null && SubkItems != null)
            {
                item = (SubkItems.FirstOrDefault());
                item?.Modify = false;
            }

            _windowService.ShowSFrm6130(item ?? new Frm6900Dto.SubkDto());

            this.SearchCommand.Execute(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"화면 생성 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Modify(Frm6900Dto.SubkDto item)
    {
        try
        {
            if (item == null && SubkItems != null)
            {
                item = (SubkItems.FirstOrDefault());
            }

            item?.Modify = true;
            item.SubkLotno = SelectedSubkItem?.SubkLotno ?? SubkItems.FirstOrDefault()?.SubkLotno ?? item?.SubkLotno;

            _windowService.ShowSFrm6130(item??new Frm6900Dto.SubkDto());

            this.SearchCommand.Execute(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage($"화면 생성 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task DeletePltNo(Frm6900Dto.SubkDto item)
    {
        try
        {
            if (!_dialog.ShowConfirm("정말로 확정 합니까.?", "확인"))
            {
                return;
            }

            //TRUE 재고 있음
            var subkCheck = await _frm6900Api.SubkCheckAsync(item?.SubkLoca ?? string.Empty);

            if (subkCheck)
            {
                if (!_dialog.ShowConfirm("재고가 있습니다.확정 합니까? (재고가 지워집니다)", "확인"))
                {
                    return;
                }

                var deleteCount = await _frm6900Api.DeleteAsync(item?.SubkLoca ?? string.Empty);

                if (deleteCount <= 0)
                {
                    _dialog.ShowMessage($"재고위치(T1MISUBK) '{item?.SubkLoca}' 삭제 {deleteCount} 건 오류", "오류");
                    return;
                }

                var lstkclearCount = await _frm6900Api.LstkClearAsync(item?.SubkLoca ?? string.Empty);

                if (lstkclearCount <= 0)
                {
                    _dialog.ShowMessage($"재고위치(T1MILSTK) '{item?.SubkLoca}' 삭제 {deleteCount} 건 오류", "오류");
                    return;
                }
                this.SearchCommand.Execute(null);
            }
        }
        catch (Exception ex)
        {
            //StatusMessage = ex.Message;
            _dialog.ShowMessage($"삭제 실패: {ex.Message}", "오류");
        }
    }
}

