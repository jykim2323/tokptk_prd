using TOK.WMS.Core.Attributes;

namespace TOK.WMS.Core.DTOs.Controls;

/// <summary>스태커 크레인의 입·출고 작업 예약.</summary>
public sealed class ScReservationDto
{
    [ExcelColumn("호기", Order = 1)]
    public int CraneNo { get; set; }

    [ExcelColumn("입출고 순번", Order = 2)]
    public string Sequence { get; set; } = string.Empty;

    /// <summary>DB에 저장된 SCHE_JOBGUBUN 원본 코드.</summary>
    [ExcelColumn("구분", Order = 4)]
    public string JobCode { get; set; } = string.Empty;

    /// <summary>원본 코드를 사용자에게 표시할 한글 명칭.</summary>
    public string JobDisplayName { get; set; } = string.Empty;

    [ExcelColumn("저장위치", Order = 3)]
    public string Location { get; set; } = string.Empty;

    [ExcelColumn("출고 ST", Order = 5)]
    public string WorkStation { get; set; } = string.Empty;

    [ExcelColumn("긴급코드", Order = 6)]
    public string EmergencyCode { get; set; } = string.Empty;
    public bool IsEmergency { get; set; }

    /// <summary>DB에 저장된 yyyyMMdd 형식의 원본 일자.</summary>
    public string InstructionDate { get; set; } = string.Empty;

    /// <summary>yyyy-MM-dd로 변환된 표시용 일자.</summary>
    [ExcelColumn("일자", Order = 7)]
    public string InstructionDateDisplay { get; set; } = string.Empty;

    /// <summary>DB에 저장된 HHmmss 형식의 원본 시간.</summary>
    public string InstructionTime { get; set; } = string.Empty;

    /// <summary>HH:mm:ss로 변환된 표시용 시간.</summary>
    [ExcelColumn("시간", Order = 8)]
    public string InstructionTimeDisplay { get; set; } = string.Empty;

    public string PalletNo { get; set; } = string.Empty;

    public string EmergencyDisplayName => IsEmergency ? "긴급" : "일반";
}

/// <summary>스태커 작업 예약 조회 조건. 모든 값은 선택 사항이다.</summary>
public sealed class ScReservationQueryDto
{
    public int? CraneNo { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public string? JobCode { get; set; }
    public string? Sequence { get; set; }
}

/// <summary>스태커 작업 예약의 출고 ST 수정 값.</summary>
public sealed class ScReservationWorkStationUpdateDto
{
    public string WorkStation { get; set; } = string.Empty;
}
