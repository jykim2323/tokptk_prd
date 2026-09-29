namespace TOK.WMS.Core.DTOs.Controls;

/// <summary>
/// 입출고 완료 대기 조회 조건. 모든 값이 비어 있으면 T2TIUPDT 전체를 조회한다.
/// </summary>
public sealed class TransferCompletionWaitQueryDto
{
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }

    /// <summary>
    /// 입고/출고 표시명 또는 I, R, A, O, T, P, U 원본 작업 코드.
    /// </summary>
    public string? JobType { get; set; }

    /// <summary>작업 순번 부분 검색값.</summary>
    public string? Sequence { get; set; }

    /// <summary>작업 위치 부분 검색값.</summary>
    public string? Location { get; set; }
}
