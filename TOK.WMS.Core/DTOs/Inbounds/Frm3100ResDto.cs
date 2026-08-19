using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.DTOs.Inbounds;


/// <summary>
/// Frm3100 수동 입고 등록 화면의 입고 예정/삭제 예정 그리드 한 행을 표현합니다.
/// </summary>

public partial class Frm3100ResDto : ObservableObject
{
    [ObservableProperty] private string _subkPltno = string.Empty;
    [ObservableProperty] private string _subkCode = string.Empty;
    [ObservableProperty] private string _mastName = string.Empty;
    [ObservableProperty] private string _subkLotno = string.Empty;
    [ObservableProperty] private string _subkWgt = string.Empty;
    [ObservableProperty] private string _subkBoxno = string.Empty;
    [ObservableProperty] private string _subkRemark = string.Empty;
    [ObservableProperty] private string _subkIndate = string.Empty;
    [ObservableProperty] private string _subkIntime = string.Empty;
    [ObservableProperty] private string _subkRowState = "1";
}
