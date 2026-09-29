namespace TOK.WMS.Core.DTOs.Controls;

/// <summary>CVC/RGV 통신 화면의 단일 신호 Grid(16 BIT 또는 4자리 값).</summary>
public sealed class ConveyorSignalGridDto
{
    public string Direction { get; set; } = string.Empty;
    public int GridNo { get; set; }
    public string Bits { get; set; } = string.Empty;
    public bool IsMapped { get; set; }
}
