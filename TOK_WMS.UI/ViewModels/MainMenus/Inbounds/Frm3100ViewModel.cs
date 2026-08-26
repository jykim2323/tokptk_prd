using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.EMMA;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections;
using System.Collections.ObjectModel;
using System.Reflection;
using System.Windows;
using TOK.WMS.Core.DTOs;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Inbounds;

public  partial class Frm3100ViewModel : DocumentViewModelBase
{
    //private readonly IExcelService _excel;

    private readonly IDialogService _dialog;
    private readonly IFrm3100Api _frm3100Api;

    [ObservableProperty] private string _itemEdit = "";
    [ObservableProperty] private string _itemNmEdit = "";
    [ObservableProperty] private string _pltnoSrcEdit = "";
    [ObservableProperty] private string _bcrEdit = "";
    [ObservableProperty] private string _recnoEdit = "";
    [ObservableProperty] private string _pltnoEdit = "";
    [ObservableProperty] private string _itnbrEdit = "";
    [ObservableProperty] private string _nameEdit = "";
    [ObservableProperty] private string _weightEdit = "";
    [ObservableProperty] private string _lotnoEdit = "";
    [ObservableProperty] private string _boxNoEdit = "";
    [ObservableProperty] private string _bigoEdit = "";

    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private string _statusMessage = "";

    [ObservableProperty] private ObservableCollection<Frm3100Dto> _Items = [];
    [ObservableProperty] private ObservableCollection<Frm3100Dto.resDto> _reservationItems  = [];
    public ObservableCollection<Frm3100Dto.resDto> deItems  = [];

    [ObservableProperty] private string _statusText = string.Empty;
    [ObservableProperty] private string _lastActionName = "-";
    [ObservableProperty] private Frm3100Dto.resDto? _selectedResItem;
    [ObservableProperty] private bool isTrackingValid;

    public event Action? WeightFocus;
    public event Action? OnLockOnHandle;
    public event Action? OnLockOffHandle;


    public Frm3100ViewModel(IFrm3100Api frm3100Api, IDialogService dialog)
    {
        _frm3100Api = frm3100Api;
        _dialog = dialog;

        Title = "수동 입고 등록";
        ContentId = DocumentKeys.Frm3100;
    }

    [RelayCommand]
    private async Task Search()
    {
        try
        {
            var q = new Frm3100Dto
            {
                MastCode = ItemEdit,
                MastName = ItemNmEdit
            };
            var result = await _frm3100Api.SearchAsync(q);
            Items.Clear();
            foreach (var h in result ?? []) Items.Add(h);
            StatusMessage = $"총 {Items.Count:N0} 건 조회됨";
        }
        catch (Exception ex)
        {

            StatusMessage = ex.Message;
            _dialog.ShowMessage($"조회 실패: {ex.Message}", "오류");
        }
    }

  

    [RelayCommand]
    private async Task Add()
    {
        try
        {
            var items = new Frm3100Dto.resDto
            {
                SubkPltno = PltnoEdit,
                SubkCode = ItnbrEdit,
                SubkLotno = LotnoEdit,
                SubkWgt = WeightEdit,
                SubkBoxno = BoxNoEdit,
                SubkRemark = BigoEdit,
                MastName = NameEdit,
                SubkRowState = "2"
            };

            var model = new Frm3100Dto
            {
                PltnoEdit = items.SubkPltno,
                ItnbrEdit = items.SubkCode,
                LotnoEdit = items.SubkLotno,
                WeightEdit = items.SubkWgt,
                BoxNoEdit = items.SubkBoxno,
                BigoEdit = items.SubkRemark,
                MastName = items.MastName
            };

            await _frm3100Api.AddAsync(model, ReservationItems);

            ReservationItems.Add(items);

        }
        catch (Exception ex)
        {
            StatusMessage = ex.Message;
            _dialog.ShowMessage($"추가 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Cancel()
    {
        try
        {
            if (ReservationItems.Count <= 0)
            {
                throw new InvalidOperationException("삭제 할 데이터가 없습니다. ");
            }

            if (!_dialog.ShowConfirm("현재 라인을 취소(수정) 하겠습니까?",
                                                                "확인"))
            {
                return;
            }

            PltnoEdit = SelectedResItem?.SubkPltno ?? "";
            ItnbrEdit = SelectedResItem?.SubkCode ?? "";
            NameEdit = SelectedResItem?.MastName ?? "";
            WeightEdit = SelectedResItem?.SubkWgt?.Replace(",", "") ?? "";
            LotnoEdit = SelectedResItem?.SubkLotno ?? "";  
            BoxNoEdit = SelectedResItem?.SubkBoxno ?? "";
            BigoEdit = SelectedResItem?.SubkRemark ?? "";

            var strFlag = SelectedResItem?.SubkRowState ?? ""; // 신규 구분 (1 : 기존, 2: 신규)

            if(strFlag == "1")
            {
                deItems.Add(SelectedResItem);
            }

            ReservationItems.Remove(SelectedResItem);

        }
        catch (Exception ex)
        {
            StatusMessage = ex.Message;
            _dialog.ShowMessage($"취소 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private async Task Save()
    {
        try
        {
            if (ReservationItems.Count <= 0 && string.IsNullOrEmpty(PltnoEdit))
            {
                throw new InvalidOperationException($"작업할 PLT-NO가 지정되지 않았습니다.{Environment.NewLine}조회 후 다시 시도하세요!");
            }

            if(ReservationItems.GroupBy(x => x.SubkPltno).Count() > 1)
            {
                throw new InvalidOperationException($"하나의 작업에는 동일한 PLT-NO만 등록할 수 있습니다.{Environment.NewLine}Grid의 PLT-NO를 확인해 주세요.");
            }

            if(!await _frm3100Api.TrakAsync(PltnoEdit))
            {
                throw new InvalidOperationException($"해당 PLT-NO는 현재 입/출고 작업이 진행 중입니다.");
            }

            if (!await _frm3100Api.LstkAsync(PltnoEdit))
            {
                throw new InvalidOperationException($"해당 PLT-NO는 이미 재고에 등록된 팔레트입니다.");
            }

            if (ReservationItems.Count == 0)
            {
                if (await _frm3100Api.SubkAsync(PltnoEdit))
                {
                    throw new InvalidOperationException("저장할 데이터가 없습니다.");
                }

                if (!_dialog.ShowConfirm($"해당 {PltnoEdit} 파레트의 데이터를 삭제하시겠습니까?", "데이터 삭제")) return;

                if (!await _frm3100Api.Subk_delAsync(PltnoEdit))
                {
                    throw new InvalidOperationException($"Delete Error");
                }

                _dialog.ShowMessage($"작업 완료:{Environment.NewLine}해당 {PltnoEdit} 파레트의 삭제가 완료되었습니다.", "성공");

            }
            else
            {
                if (!_dialog.ShowConfirm($"해당 {PltnoEdit} 제품을 입고 등록(저장) 하시겠습니까?", "입고 등록")) return;

                if (deItems.Count > 0)
                {
                    foreach (Frm3100Dto.resDto item in deItems) 
                    {
                        await _frm3100Api.Subk_delAsync(item.SubkPltno, item.SubkCode, item.SubkLotno);
                    }
                }

                foreach(Frm3100Dto.resDto item in ReservationItems)
                {
                    var cnt = await _frm3100Api.Subk_InsertAsync(item);
                }

                _dialog.ShowMessage($"저장 완료:{Environment.NewLine}해당 {PltnoEdit} 파레트의 수동 입고가 완료되었습니다.", "성공");
            }


        }
        catch (Exception ex)
        {
            StatusMessage = ex.Message;
            _dialog.ShowMessage($"입고확정 실패:{Environment.NewLine}{ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private void MimastCellClick(Frm3100Dto dto)
    {
        ItnbrEdit = dto.MastCode;
        NameEdit = dto.MastCode;
    }

    [RelayCommand]
    private async Task Tracking()
    {
        try
        {
            if (string.IsNullOrEmpty(PltnoSrcEdit))
            {
                IsTrackingValid = false;
                return;
            }

            ItnbrEdit = "";
            NameEdit = "";
            WeightEdit = "";
            LotnoEdit = "";
            BoxNoEdit = "";
            BigoEdit = "";
            ReservationItems.Clear();

            PltnoEdit = PltnoSrcEdit;

            var trCheack = await _frm3100Api.TrackingAsync(PltnoEdit);

            var spcheach = await _frm3100Api.SpeedAsync(PltnoEdit);

            if (!trCheack)
            {
                OnLockOnHandle?.Invoke();
            }
            else
            {
                OnLockOffHandle?.Invoke();
            }

            foreach (var h in spcheach ?? Enumerable.Empty<Frm3100Dto.resDto>())
            { 
                ReservationItems.Add(h);
            }

            WeightFocus?.Invoke();

            if (!string.IsNullOrEmpty(PltnoEdit)) 
            {
                IsTrackingValid = true;
            }
        }
        catch (Exception ex)
        {
            StatusMessage = ex.Message;
            _dialog.ShowMessage($"취소 실패: {ex.Message}", "오류");
        }
    }

    [RelayCommand]
    private void Warning()
    {
        _dialog.ShowMessage($"키 입력 실패:{Environment.NewLine} 숫자만 입력 할 수 있습니다.", "오류");
    }

}
