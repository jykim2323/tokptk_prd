namespace TOK.WMS.Core.DTOs.Controls;

/// <summary>CVC/RGV 단일 Grid 수정 값(16 BIT 또는 4자리 값).</summary>
public sealed class ConveyorSignalUpdateDto
{
    public string Bits { get; set; } = string.Empty;
}
