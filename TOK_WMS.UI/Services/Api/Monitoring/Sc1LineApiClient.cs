using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Monitoring;

namespace TOK.WMS.UI.Services.Api.Monitoring;

public interface ISc1LineApi
{
    Task<Sc1LineSnapshotDto> GetSnapshotAsync(
        CancellationToken cancellationToken = default);

    Task<EquipmentPositionSnapshotDto> GetEquipmentPositionsAsync(
        CancellationToken cancellationToken = default);

    Task<BcrToggleResultDto> ToggleBcrAsync(
        int bcrNo,
        CancellationToken cancellationToken = default);

    Task<MonitoringTrackDetailDto?> GetTrackAsync(
        string trackNo,
        CancellationToken cancellationToken = default);

    Task SaveTrackAsync(
        string trackNo,
        MonitoringTrackUpdateRequest request,
        CancellationToken cancellationToken = default);

    Task DeleteTrackAsync(
        string trackNo,
        CancellationToken cancellationToken = default);

    Task MoveTrackAsync(
        string sourceTrackNo,
        MonitoringTrackMoveRequest request,
        CancellationToken cancellationToken = default);

    Task<MonitoringStackerWorkDto?> GetStackerWorkAsync(
        int craneNo,
        CancellationToken cancellationToken = default);

    Task ReissueStackerAsync(
        int craneNo,
        bool hasForkPallet,
        CancellationToken cancellationToken = default);

    Task CompleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken = default);

    Task ForceDeleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken = default);

    Task ClearStackerErrorAsync(
        int craneNo,
        CancellationToken cancellationToken = default);

    Task<IReadOnlyList<MonitoringRackCellDto>> GetRackCellsAsync(
        int bank,
        CancellationToken cancellationToken = default);

    Task<MonitoringRackCellDetailDto?> GetRackCellDetailAsync(
        string location,
        CancellationToken cancellationToken = default);
}

/// <summary>상품·제품창고 전체 모니터링 조회 및 BCR 운전 제어 API.</summary>
public sealed class Sc1LineApiClient(HttpClient http) : ISc1LineApi
{
    public async Task<Sc1LineSnapshotDto> GetSnapshotAsync(
        CancellationToken cancellationToken = default)
    {
        return await http.GetFromJsonAsync<Sc1LineSnapshotDto>(
                   "api/monitoring/sc1-line", cancellationToken)
               ?? throw new InvalidOperationException(
                   "모니터링 API가 빈 응답을 반환했습니다.");
    }

    public async Task<EquipmentPositionSnapshotDto> GetEquipmentPositionsAsync(
        CancellationToken cancellationToken = default)
    {
        return await http.GetFromJsonAsync<EquipmentPositionSnapshotDto>(
                   "api/monitoring/equipment-positions", cancellationToken)
               ?? throw new InvalidOperationException(
                   "설비 위치 API가 빈 응답을 반환했습니다.");
    }

    public async Task<BcrToggleResultDto> ToggleBcrAsync(
        int bcrNo,
        CancellationToken cancellationToken = default)
    {
        if (bcrNo is < 1 or > 4)
            throw new ArgumentOutOfRangeException(nameof(bcrNo), "BCR 번호는 1~4만 허용됩니다.");

        using var response = await http.PostAsync(
            $"api/monitoring/bcr/{bcrNo}/toggle", null, cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);

        return await response.Content.ReadFromJsonAsync<BcrToggleResultDto>(
                   cancellationToken: cancellationToken)
               ?? throw new InvalidOperationException(
                   $"BCR #{bcrNo} 제어 API가 빈 응답을 반환했습니다.");
    }

    public async Task<MonitoringTrackDetailDto?> GetTrackAsync(
        string trackNo,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.GetAsync(
            $"api/monitoring/tracks/{Uri.EscapeDataString(trackNo)}", cancellationToken);
        if (response.StatusCode == System.Net.HttpStatusCode.NotFound)
            return null;
        await EnsureSuccessAsync(response, cancellationToken);
        return await response.Content.ReadFromJsonAsync<MonitoringTrackDetailDto>(
            cancellationToken: cancellationToken);
    }

    public async Task SaveTrackAsync(
        string trackNo,
        MonitoringTrackUpdateRequest request,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.PutAsJsonAsync(
            $"api/monitoring/tracks/{Uri.EscapeDataString(trackNo)}",
            request,
            cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    public async Task DeleteTrackAsync(
        string trackNo,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.DeleteAsync(
            $"api/monitoring/tracks/{Uri.EscapeDataString(trackNo)}", cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    public async Task MoveTrackAsync(
        string sourceTrackNo,
        MonitoringTrackMoveRequest request,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.PostAsJsonAsync(
            $"api/monitoring/tracks/{Uri.EscapeDataString(sourceTrackNo)}/move",
            request,
            cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    public async Task<MonitoringStackerWorkDto?> GetStackerWorkAsync(
        int craneNo,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.GetAsync(
            $"api/monitoring/stackers/{craneNo}", cancellationToken);
        if (response.StatusCode == System.Net.HttpStatusCode.NotFound)
            return null;
        await EnsureSuccessAsync(response, cancellationToken);
        return await response.Content.ReadFromJsonAsync<MonitoringStackerWorkDto>(
            cancellationToken: cancellationToken);
    }

    public async Task ReissueStackerAsync(
        int craneNo,
        bool hasForkPallet,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.PostAsJsonAsync(
            $"api/monitoring/stackers/{craneNo}/reissue",
            new MonitoringStackerReissueRequest { HasForkPallet = hasForkPallet },
            cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    public Task CompleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken = default) =>
        PostStackerActionAsync(craneNo, "complete", cancellationToken);

    public Task ForceDeleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken = default) =>
        PostStackerActionAsync(craneNo, "force-delete", cancellationToken);

    public Task ClearStackerErrorAsync(
        int craneNo,
        CancellationToken cancellationToken = default) =>
        PostStackerActionAsync(craneNo, "clear-error", cancellationToken);

    public async Task<IReadOnlyList<MonitoringRackCellDto>> GetRackCellsAsync(
        int bank,
        CancellationToken cancellationToken = default)
    {
        return await http.GetFromJsonAsync<IReadOnlyList<MonitoringRackCellDto>>(
                   $"api/monitoring/rack/{bank}/cells", cancellationToken)
               ?? [];
    }

    public async Task<MonitoringRackCellDetailDto?> GetRackCellDetailAsync(
        string location,
        CancellationToken cancellationToken = default)
    {
        using var response = await http.GetAsync(
            $"api/monitoring/rack/cells/{Uri.EscapeDataString(location)}", cancellationToken);
        if (response.StatusCode == System.Net.HttpStatusCode.NotFound)
            return null;
        await EnsureSuccessAsync(response, cancellationToken);
        return await response.Content.ReadFromJsonAsync<MonitoringRackCellDetailDto>(
            cancellationToken: cancellationToken);
    }

    private async Task PostStackerActionAsync(
        int craneNo,
        string action,
        CancellationToken cancellationToken)
    {
        using var response = await http.PostAsync(
            $"api/monitoring/stackers/{craneNo}/{action}", null, cancellationToken);
        await EnsureSuccessAsync(response, cancellationToken);
    }

    private static async Task EnsureSuccessAsync(
        HttpResponseMessage response,
        CancellationToken cancellationToken)
    {
        if (response.IsSuccessStatusCode)
            return;

        var body = await response.Content.ReadAsStringAsync(cancellationToken);
        var message = body.Trim();
        if (message.StartsWith('"') && message.EndsWith('"'))
        {
            try
            {
                message = JsonSerializer.Deserialize<string>(message) ?? message;
            }
            catch (JsonException)
            {
            }
        }

        throw new InvalidOperationException(
            string.IsNullOrWhiteSpace(message)
                ? $"요청 처리에 실패했습니다. ({(int)response.StatusCode})"
                : message);
    }
}
