using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
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
    [ObservableProperty] private string _subkWgtTotal = string.Empty;


    [ObservableProperty] private ObservableCollection<Frm6100Dto.ResDto> _items = [];
    [ObservableProperty] private ObservableCollection<Frm6100Dto.SubkDto> _subkItems = [];
    [ObservableProperty] private Frm6100Dto.ResDto? _selectedItem;
    [ObservableProperty] private Frm6100Dto.SubkDto? _selectedSubkItem;

    public Frm6100ViewModel(IFrm6100Api frm6100Api, IDialogService dialog, IWindowService windowService)
    {
        _frm6100Api = frm6100Api;
        _dialog = dialog;
        _windowService = windowService;

        Title = "저장 위치 조회";
        ContentId = DocumentKeys.Frm6100;

        SelectedItem = new Frm6100Dto.ResDto
        {
            LstkLoca = "010101"
        };
    }

    [RelayCommand]
    private async Task Search()
    {
        try
        {

            var q = new Frm6100Dto
            {
                LstkLoca = SelectedItem?.LstkLoca ?? LstkLoca,
            };

            var result = await _frm6100Api.SearchAsync(q);
            Items.Clear();
            foreach (var h in result ?? []) Items.Add(h);


            this.SubkSearchCommand?.Execute(null);
        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
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
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task SubkSearch()
    {
        try
        {
            if(SelectedItem?.LstkLoca == null)
            {
                SelectedItem = new Frm6100Dto.ResDto
                {
                    LstkLoca = LstkLoca
                };
            }

            LstkLoca = SelectedItem?.LstkLoca ?? LstkLoca;

            var result = await _frm6100Api.SubkSearchAsync(LstkLoca);

            SubkItems.Clear();

            foreach (var h in result ?? []) SubkItems.Add(h);


            SubkWgtTotal = SubkItems.Sum(x => decimal.TryParse(x.SubkWgt, out var wgt) ? wgt : 0).ToString();

        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Delete(Frm6100Dto.ResDto? item)
    {
        try
        {
            if (!_dialog.ShowConfirm("정말로 확정 합니까.?", "확인"))
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
                    _dialog.ShowWarning($"재고위치(T2MISUBK) '{item.LstkLoca}' 삭제 {deleteCount} 건 오류", "오류");
                    return;
                }

                var lstkclearCount = await _frm6100Api.LstkClearAsync(item.LstkLoca ?? string.Empty);

                if (lstkclearCount <= 0)
                {
                    _dialog.ShowWarning($"재고위치(T2MILSTK) '{item.LstkLoca}' 삭제 {deleteCount} 건 오류", "오류");
                    return;
                }

                this.SearchCommand.Execute(null);
            }
        }
        catch (Exception ex)
        {
            //StatusMessage = ex.Message;
            _dialog.ShowWarning($"삭제 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Cellinsert(Frm6100Dto.ResDto? item)
    {
        try
        {
            item ??= Items.Select(x => x).FirstOrDefault();

            if (string.IsNullOrEmpty(item?.LstkLoca))
            {
                _dialog.ShowWarning($"선택한 행이 없습니다.", "오류");
                return;
            }


            if (!string.IsNullOrEmpty(item?.LstkPltno) || (item?.LstkFlag == "1"))
            {
                _dialog.ShowWarning($"이미 재고가 들어있는 위치입니다. 다른 위치를 선택해주세요.", "오류");
                return;
            }

            var reqDto = new Frm6100Dto.SubkDto
            {
                SubkLoca = item?.LstkLoca,
                SubkFlag = item?.LstkFlag,
            };

            _windowService.ShowSFrm6120(reqDto);

            this.SearchCommand.Execute(null);

        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Celladd(Frm6100Dto.ResDto? item)
    {
        try
        {
            if (string.IsNullOrEmpty(item?.LstkLoca))
            {
                _dialog.ShowWarning($"선택한 행이 없습니다.", "오류");
                return;
            }

            var lstk_pltno = await _frm6100Api.LstkpltnocheckAsync(item.LstkLoca ?? string.Empty);

            if (string.IsNullOrEmpty(lstk_pltno))
            {
                _dialog.ShowWarning($"해당 위치에 재고가 없습니다. 셀 재고 등록후 추가해 주세요", "오류");
                return;
            }



            if (!await _frm6100Api.SubklocacheckAsync(lstk_pltno ?? string.Empty))
            {
                _dialog.ShowWarning($"해당 PLTNO 정보가 없습니다. 확인후 다시 시도하십시오.", "오류");
                return;
            }

            var reqDto = new Frm6100Dto.SubkDto
            {
                SubkLoca = item.LstkLoca,
                SubkPltno = lstk_pltno,
                SubkFlag = item.LstkFlag,
            };

            _windowService.ShowLocaAdd(reqDto);

            this.SearchCommand.Execute(null);

        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Cellcancel(Frm6100Dto.ResDto? item)
    {
        try
        {
            if (!_dialog.ShowConfirm(" 정말로 셀 재고 취소를 확정 합니까.?", "확인"))
            {
                return;
            }

            // 셀 재고 취소
            // T2MISUBK loca '' 초기화 flag  '0' 초기화 gubun '' 초기화
            // T2MILSTK LSTK_INDATE, LSTK_INTIME, LSTK_PLTNO '' , LSTK_FLAG  '0' 초기화

            var result = await _frm6100Api.CancelSubkAsync(item?.LstkLoca ?? string.Empty);

            if (!result)
            {
                _dialog.ShowWarning($"재고위치 {item?.LstkLoca} 셀 재고 취소 에러!!!!(SUBK 초기화 에러) ", "오류");
                return;
            }

            var response = await _frm6100Api.CancelLstkAsync(item?.LstkLoca ?? string.Empty);

            if (!response)
            {
                _dialog.ShowWarning($"재고위치 {item?.LstkLoca} 셀 재고 취소 에러!!!!(LSTK 초기화 에러) ", "오류");
                return;
            }

            this.SearchCommand.Execute(null);

        }
        catch (Exception ex)
        {
            _dialog.ShowWarning($"조회 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task DeletePltNo()
    {
        try
        {
            if (!_dialog.ShowConfirm(" PLT 정보가 사라집니다..  정말로 삭제 확정 합니까.??", "확인"))
            {
                return;
            }

            if(SelectedSubkItem == null)
            {
                _dialog.ShowWarning($"삭제할 PLT 정보를 클릭하세요....!", "오류");
                return;
            }

            var reqDto = new Frm6100Dto.SubkDto
            {
                SubkLoca = SelectedSubkItem?.SubkLoca,
                SubkCode = SelectedSubkItem?.SubkCode,
                SubkLotno = SelectedSubkItem?.SubkLotno,
            };

            var result = await _frm6100Api.DeletePltNoAsync(reqDto);

            if (!result)
            {
                _dialog.ShowWarning($" 재고위치 { SelectedSubkItem?.SubkLoca } 삭제 에러!!!!  ", "오류");
                return;
            }

            var response = await _frm6100Api.SubkCheckAsync(SelectedSubkItem?.SubkLoca ?? string.Empty);

            if (response)
            {
                return;
            }

            await _frm6100Api.ResetLstkAsync(SelectedSubkItem?.SubkLoca ?? string.Empty);

            this.SearchCommand.Execute(null);
        }
        catch (Exception ex)
        {
            //StatusMessage = ex.Message;
            _dialog.ShowWarning($"삭제 실패: {ex.Message}", "오류");
        }
    }
}

