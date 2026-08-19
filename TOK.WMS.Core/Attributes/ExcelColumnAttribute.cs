namespace TOK.WMS.Core.Attributes;

/// <summary>엑셀 내보내기 열 헤더/순서 지정. IExcelService 가 이 메타를 읽어 출력.</summary>
[AttributeUsage(AttributeTargets.Property)]
public sealed class ExcelColumnAttribute(string header) : Attribute
{
    public string Header { get; } = header;
    public int Order { get; set; }
    public bool IsDateTime14 { get; set; }  // "yyyyMMddHHmmss" → "yyyy-MM-dd HH:mm:ss"
}
