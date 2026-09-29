namespace TOK.WMS.Core.DTOs.Controls;

/// <summary>
/// 상품·제품창고 시스템 운전 설정.
/// 현재 DB의 dbo.T2TBSTAT/JPLS 행에 저장된 1층 설정만 다룬다.
/// </summary>
public sealed class SystemOperationDto
{
    public int[] CraneModes { get; set; } = [];
    public long InboundSequence { get; set; }
    public long OutboundSequence { get; set; }
    public long ReInboundSequence { get; set; }
    public long EmptyPalletSequence { get; set; }
    public int InboundCrane { get; set; }
}

/// <summary>
/// 시스템 운전 설정의 부분 수정 값.
/// 수정 그룹에 필요한 필드만 전송한다.
/// </summary>
public sealed class SystemOperationUpdateDto
{
    public int[]? CraneModes { get; set; }
    public long? InboundSequence { get; set; }
    public long? OutboundSequence { get; set; }
    public long? ReInboundSequence { get; set; }
    public long? EmptyPalletSequence { get; set; }
    public int? InboundCrane { get; set; }
}

public enum SystemOperationUpdateGroup
{
    Modes,
    Sequences,
    InboundCrane
}
