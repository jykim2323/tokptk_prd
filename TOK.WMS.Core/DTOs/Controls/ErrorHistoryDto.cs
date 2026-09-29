using System.Globalization;
using TOK.WMS.Core.Attributes;

namespace TOK.WMS.Core.DTOs.Controls;

/// <summary>상품/제품 창고(T2)의 설비 에러 이력 한 건.</summary>
public sealed class ErrorHistoryDto
{
    /// <summary>
    /// dbo.TIMESG.MESG_DT 원본 값(yyyyMMddHHmmss).
    /// 화면 표시가 아니라 삭제 복합키로 사용한다.
    /// </summary>
    public string OccurredAtRaw { get; init; } = string.Empty;

    /// <summary>사용자에게 표시할 발생일시.</summary>
    [ExcelColumn("발생일시", Order = 1)]
    public string OccurredAt
    {
        get
        {
            return DateTime.TryParseExact(
                OccurredAtRaw,
                "yyyyMMddHHmmss",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out var occurredAt)
                ? occurredAt.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture)
                : OccurredAtRaw;
        }
    }

    [ExcelColumn("호기", Order = 2)]
    public string CraneNo { get; init; } = string.Empty;

    /// <summary>dbo.TIMESG.MESG_ELOCA 원본 6자리(BBYYLL).</summary>
    [ExcelColumn("열-연-단", Order = 3)]
    public string Location { get; init; } = string.Empty;

    [ExcelColumn("에러내용", Order = 4)]
    public string Description { get; init; } = string.Empty;
}
