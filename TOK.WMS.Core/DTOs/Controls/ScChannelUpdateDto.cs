namespace TOK.WMS.Core.DTOs.Controls;

/// <summary>
/// 스태커 크레인 PLC 통신 버퍼의 부분 수정 값.
/// null인 채널은 수정 대상에서 제외한다.
/// </summary>
public sealed class ScChannelUpdateDto
{
    public string? Ch01 { get; set; }
    public string? Ch02 { get; set; }
    public string? Ch03 { get; set; }
    public string? Ch04 { get; set; }
    public string? Ch05 { get; set; }
    public string? Ch06 { get; set; }
}

public enum ScChannelUpdateGroup
{
    Ch01,
    Ch06,
    Words
}
