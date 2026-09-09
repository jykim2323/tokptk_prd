using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Collections.ObjectModel;
using System.Windows;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Standards;

namespace TOK.WMS.UI.ViewModels.MainMenus.Standards;

public partial class SFrm1100ViewModel
    : ObservableObject
{
    private readonly ISFrm1100Api _sfrm1100Api;

    private readonly IDialogService _dialog;


    [ObservableProperty]
    private string _mode =
        "INSERT";


    [ObservableProperty]
    private string _title =
        "품목 코드 등록";


    [ObservableProperty]
    private string _mastCode =
        string.Empty;


    [ObservableProperty]
    private string _mastBcode =
        string.Empty;


    [ObservableProperty]
    private string _mastName =
        string.Empty;


    [ObservableProperty]
    private string _mastUnit =
        string.Empty;


    [ObservableProperty]
    private string _mastWeight =
        "0";


    [ObservableProperty]
    private string _mastRef1 =
        string.Empty;


    [ObservableProperty]
    private bool _isCodeReadOnly;


    [ObservableProperty]
    private bool _isEditReadOnly;


    [ObservableProperty]
    private string _statusMessage =
        string.Empty;


    // =========================================================
    // 구분
    // =========================================================

    [ObservableProperty]
    private ObservableCollection<SFrm1100Dto.GubnDto> _gubn1Items =
        [];


    [ObservableProperty]
    private ObservableCollection<SFrm1100Dto.GubnDto> _gubn2Items =
        [];


    [ObservableProperty]
    private ObservableCollection<SFrm1100Dto.GubnDto> _gubn3Items =
        [];


    [ObservableProperty]
    private SFrm1100Dto.GubnDto? _selectedGubn1;


    [ObservableProperty]
    private SFrm1100Dto.GubnDto? _selectedGubn2;


    [ObservableProperty]
    private SFrm1100Dto.GubnDto? _selectedGubn3;


    private string _gubn1Code =
        string.Empty;


    private string _gubn2Code =
        string.Empty;


    private string _gubn3Code =
        string.Empty;


    public SFrm1100ViewModel(
        ISFrm1100Api sfrm1100Api,
        IDialogService dialog)
    {
        _sfrm1100Api =
            sfrm1100Api;


        _dialog =
            dialog;
    }


    // =========================================================
    // 초기화
    // =========================================================

    public void Initialize(
        SFrm1100Dto.InitDto? item,
        string mode)
    {
        Mode =
            mode?.Trim()
                .ToUpperInvariant()
            ?? "INSERT";


        MastCode =
            item?.MastCode
            ?? string.Empty;


        MastBcode =
            item?.MastBcode
            ?? string.Empty;


        MastName =
            item?.MastName
            ?? string.Empty;


        MastUnit =
            item?.MastUnit
            ?? string.Empty;


        MastWeight =
            item == null
                ? "0"
                : item.MastWeight
                    .ToString("0.##");


        MastRef1 =
            item?.MastRef1
            ?? string.Empty;


        _gubn1Code =
            item?.MastGubn1
            ?? string.Empty;


        _gubn2Code =
            item?.MastGubn2
            ?? string.Empty;


        _gubn3Code =
            item?.MastGubn3
            ?? string.Empty;


        switch (Mode)
        {
            case "UPDATE":

                Title =
                    "품목 코드 수정";

                IsCodeReadOnly =
                    true;

                IsEditReadOnly =
                    false;

                break;


            case "DELETE":

                Title =
                    "품목 코드 삭제";

                IsCodeReadOnly =
                    true;

                IsEditReadOnly =
                    true;

                break;


            default:

                Mode =
                    "INSERT";

                Title =
                    "품목 코드 등록";

                IsCodeReadOnly =
                    false;

                IsEditReadOnly =
                    false;

                break;
        }
    }


    // =========================================================
    // Loaded
    // =========================================================

    [RelayCommand]
    private async Task Loaded()
    {
        try
        {
            await LoadGubn1();

            await LoadGubn2();

            await LoadGubn3();
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"구분 데이터 조회 실패: {ex.Message}",
                "오류");
        }
    }


    private async Task LoadGubn1()
    {
        var result =
            await _sfrm1100Api
                .Gubn1SearchAsync();


        Gubn1Items.Clear();


        Gubn1Items.Add(
            new SFrm1100Dto.GubnDto());


        foreach (var item in result ?? [])
        {
            Gubn1Items.Add(
                item);
        }


        SelectedGubn1 =
            Gubn1Items.FirstOrDefault(
                x => x.Code == _gubn1Code)
            ?? Gubn1Items.FirstOrDefault();
    }


    private async Task LoadGubn2()
    {
        var result =
            await _sfrm1100Api
                .Gubn2SearchAsync();


        Gubn2Items.Clear();


        Gubn2Items.Add(
            new SFrm1100Dto.GubnDto());


        foreach (var item in result ?? [])
        {
            Gubn2Items.Add(
                item);
        }


        SelectedGubn2 =
            Gubn2Items.FirstOrDefault(
                x => x.Code == _gubn2Code)
            ?? Gubn2Items.FirstOrDefault();
    }


    private async Task LoadGubn3()
    {
        var result =
            await _sfrm1100Api
                .Gubn3SearchAsync();


        Gubn3Items.Clear();


        Gubn3Items.Add(
            new SFrm1100Dto.GubnDto());


        foreach (var item in result ?? [])
        {
            Gubn3Items.Add(
                item);
        }


        SelectedGubn3 =
            Gubn3Items.FirstOrDefault(
                x => x.Code == _gubn3Code)
            ?? Gubn3Items.FirstOrDefault();
    }


    // =========================================================
    // 확정
    // =========================================================

    [RelayCommand]
    private async Task Confirm(
        Window? window)
    {
        try
        {
            if (!_dialog.ShowConfirm(
                "정말로 확정 합니까?",
                "확인"))
            {
                return;
            }


            if (string.IsNullOrWhiteSpace(
                MastCode))
            {
                _dialog.ShowMessage(
                    "품목코드를 입력 하십시오.",
                    "오류");

                return;
            }


            if (Mode != "DELETE" &&
                string.IsNullOrWhiteSpace(
                    MastName))
            {
                _dialog.ShowMessage(
                    "품목명을 입력 하십시오.",
                    "오류");

                return;
            }


            var weightText =
                string.IsNullOrWhiteSpace(
                    MastWeight)
                    ? "0"
                    : MastWeight
                        .Replace(",", "")
                        .Trim();


            if (!decimal.TryParse(
                weightText,
                out var weight))
            {
                _dialog.ShowMessage(
                    "단위중량을 숫자로 입력해주세요.",
                    "오류");

                return;
            }


            int result;


            if (Mode == "INSERT")
            {
                result =
                    await _sfrm1100Api
                        .InsertAsync(
                            CreateReqDto(
                                weight));


                if (result <= 0)
                {
                    _dialog.ShowMessage(
                        $"품목 코드 {MastCode} 등록 실패",
                        "오류");

                    return;
                }


                StatusMessage =
                    $"품목 코드 {MastCode}를 등록 하였습니다.";
            }

            else if (Mode == "UPDATE")
            {
                result =
                    await _sfrm1100Api
                        .UpdateAsync(
                            CreateReqDto(
                                weight));


                if (result <= 0)
                {
                    _dialog.ShowMessage(
                        $"품목 코드 {MastCode} 수정 실패",
                        "오류");

                    return;
                }


                StatusMessage =
                    $"품목 코드 {MastCode}를 수정 하였습니다.";
            }

            else if (Mode == "DELETE")
            {
                result =
                    await _sfrm1100Api
                        .DeleteAsync(
                            new SFrm1100Dto.DeleteReqDto
                            {
                                MastCode =
                                    MastCode.Trim()
                            });


                if (result <= 0)
                {
                    _dialog.ShowMessage(
                        $"품목 코드 {MastCode} 삭제 실패",
                        "오류");

                    return;
                }


                StatusMessage =
                    $"품목 코드 {MastCode}를 삭제 하였습니다.";
            }

            else
            {
                _dialog.ShowMessage(
                    "잘못된 작업 모드입니다.",
                    "오류");

                return;
            }


            _dialog.ShowMessage(
                StatusMessage,
                "완료");


            window?.Close();
        }
        catch (Exception ex)
        {
            _dialog.ShowMessage(
                $"{Title} 실패: {ex.Message}",
                "오류");
        }
    }


    private SFrm1100Dto.ReqDto CreateReqDto(
        decimal weight)
    {
        return new SFrm1100Dto.ReqDto
        {
            MastCode =
                MastCode.Trim(),

            MastBcode =
                MastBcode.Trim(),

            MastName =
                MastName.Trim(),

            MastUnit =
                MastUnit.Trim(),

            MastWeight =
                weight,

            MastGubn1 =
                SelectedGubn1?.Code
                ?? string.Empty,

            MastGubn2 =
                SelectedGubn2?.Code
                ?? string.Empty,

            MastGubn3 =
                SelectedGubn3?.Code
                ?? string.Empty,

            MastRef1 =
                MastRef1.Trim()
        };
    }


    [RelayCommand]
    private void Close(
        Window? window)
    {
        window?.Close();
    }
}