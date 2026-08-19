using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.Entities.Inbounds;

/// <summary>
/// Frm3130 화면의 조회 조건과 입력 컨트롤 값을 보관하는 모델입니다.
/// </summary>
public partial class Frm3130Model : ObservableObject
{
    // 컨트롤 영역

    [ObservableProperty]
    private string _mastNmEdit = string.Empty;  //품명

    [ObservableProperty]
    private string _subkCodeNmEdit = string.Empty;

    [ObservableProperty]
    private string _pltnoEdit = string.Empty;

    [ObservableProperty]
    private string _bcrEdit = string.Empty;

    [ObservableProperty]
    private string _recNoEdit = string.Empty;

    [ObservableProperty]
    private string _weightEdit = string.Empty;

    [ObservableProperty]
    private string _lotnoEdit = string.Empty;

    [ObservableProperty]
    private string _boxNoEdit = string.Empty;

    [ObservableProperty]
    private string _bigoEdit = string.Empty;




    // 쿼리 파라미터

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
    private object? _mastWeight;

    [ObservableProperty]
    private object? _mastGubn1;

    [ObservableProperty]
    private object? _gubn1Name;

    [ObservableProperty]
    private object? _subkCode;

    [ObservableProperty]
    private string? _subkLotno = string.Empty;

    [ObservableProperty]
    private object? _subkFlag;
}
