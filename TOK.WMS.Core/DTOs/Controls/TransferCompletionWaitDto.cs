using TOK.WMS.Core.Attributes;

namespace TOK.WMS.Core.DTOs.Controls;

/// <summary>설비 작업 완료 후 업무 갱신을 기다리는 T2TIUPDT 항목.</summary>
public sealed class TransferCompletionWaitDto
{
    /// <summary>입출고 작업 순번(UPDT_INDEX).</summary>
    [ExcelColumn("입출고 순번", Order = 1)]
    public string Sequence { get; set; } = string.Empty;

    /// <summary>작업 위치(UPDT_LOCA).</summary>
    [ExcelColumn("저장위치", Order = 3)]
    public string Location { get; set; } = string.Empty;

    /// <summary>DB에 저장된 원본 작업 코드(UPDT_JOB).</summary>
    [ExcelColumn("작업구분", Order = 4)]
    public string JobCode { get; set; } = string.Empty;

    /// <summary>작업 코드의 화면 표시명.</summary>
    public string JobType { get; set; } = string.Empty;

    /// <summary>완료일자 표시값(yyyy-MM-dd, 원본이 잘못된 경우 원본값).</summary>
    [ExcelColumn("일자", Order = 5)]
    public string CompletionDate { get; set; } = string.Empty;

    /// <summary>완료시간 표시값(HH:mm:ss, 원본이 잘못된 경우 원본값).</summary>
    [ExcelColumn("시간", Order = 6)]
    public string CompletionTime { get; set; } = string.Empty;

    /// <summary>팔레트 번호(UPDT_PLTNO).</summary>
    [ExcelColumn("PLT-NO", Order = 2)]
    public string PalletNo { get; set; } = string.Empty;
}
