namespace TOK.WMS.UI.Views.Monitoring.Models;

/// <summary>SC1 컨베이어 트래킹 목록의 화면 표시 행입니다.</summary>
public sealed record Sc1TrackingRow(
    string Sequence,
    string StorageLocation,
    string Type,
    string RegisteredDate,
    string RegisteredTime,
    int TrackNo,
    string From,
    string To,
    string Flag,
    bool HasPhysicalPallet,
    bool HasTrackingData);
