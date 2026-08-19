using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.Entities.Inbounds;

/// <summary>
/// Frm3100 화면의 조회 조건과 입력 컨트롤 값을 보관하는 모델입니다.
/// </summary>
public partial class Frm3100Model : ObservableObject
{
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
    private string? _mastCode = string.Empty;

    [ObservableProperty]
    private string? _mastBcode = string.Empty;

    [ObservableProperty]
    private string? _mastName = string.Empty;

    [ObservableProperty]
    private string? _subkPltno = string.Empty;

    [ObservableProperty]
    private object? _mastUnit;

    [ObservableProperty]
    private object? _mastWeight;

    [ObservableProperty]
    private object? _mastGubn1;

    [ObservableProperty]
    private object? _gubn1Name;

    [ObservableProperty]
    private object? _subkCode;

    [ObservableProperty]
    private object? _subkLotno;

    [ObservableProperty]
    private object? _subkFlag;
}

