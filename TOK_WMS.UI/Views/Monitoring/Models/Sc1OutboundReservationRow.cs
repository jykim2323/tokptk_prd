namespace TOK.WMS.UI.Views.Monitoring.Models;

/// <summary>SC1 출고 예약 목록의 화면 표시 행입니다.</summary>
public sealed record Sc1OutboundReservationRow(
    string OutboundSequence,
    string CraneNo,
    string StorageLocation,
    string StockType,
    string IsEmergency,
    string InstructionDate,
    string InstructionTime,
    string PalletNo,
    string JobType);
