using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.DTOs.Inbounds;

/// <summary>
/// Frm3100 수동 입고 등록 화면의 품목 조회 결과 한 행을 표현합니다.
/// </summary>
public partial class Frm3100Dto : ObservableObject
{
    [ObservableProperty] private string _mastCode = string.Empty;
    [ObservableProperty] private string _mastBcode = string.Empty;
    [ObservableProperty] private string _mastName = string.Empty;
    [ObservableProperty] private string _mastUnit = string.Empty;
    [ObservableProperty] private string _mastWeight = string.Empty;
    [ObservableProperty] private string _mastGubn1 = string.Empty;
    [ObservableProperty] private string _gubn1Name = string.Empty;
    [ObservableProperty] private string _mastGubn2 = string.Empty;
    [ObservableProperty] private string _gubn2Name = string.Empty;
    [ObservableProperty] private string _mastGubn3 = string.Empty;
    [ObservableProperty] private string _gubn3Name = string.Empty;
    [ObservableProperty] private string _mastDate = string.Empty;

    [ObservableProperty]
    private string _itemEdit = string.Empty;

    [ObservableProperty]
    private string _itemNmEdit = string.Empty;

    [ObservableProperty]
    private string _pltnoSrcEdit = string.Empty;

    [ObservableProperty]
    private string _bcrEdit = string.Empty;

    [ObservableProperty]
    private string _recNoEdit = string.Empty;

    [ObservableProperty]
    private string _pltnoEdit = string.Empty;

    [ObservableProperty]
    private string _itnbrEdit = string.Empty;

    [ObservableProperty]
    private string _nameEdit = string.Empty;

    [ObservableProperty]
    private string _weightEdit = string.Empty;

    [ObservableProperty]
    private string _lotnoEdit = string.Empty;

    [ObservableProperty]
    private string _boxNoEdit = string.Empty;

    [ObservableProperty]
    private string _bigoEdit = string.Empty;

    [ObservableProperty]
    private object? _lstkLv;

    [ObservableProperty]
    private object? _lstkBk;

    [ObservableProperty]
    private object? _cnt;

    [ObservableProperty]
    private string? _subkPltno = string.Empty;

    [ObservableProperty]
    private object? _subkCode;

    [ObservableProperty]
    private object? _subkLotno;

    [ObservableProperty]
    private object? _subkFlag;
}


