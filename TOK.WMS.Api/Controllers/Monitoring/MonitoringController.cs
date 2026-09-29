using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Monitoring;
using TOK.WMS.Core.Interfaces.Monitoring;

namespace TOK.WMS.Api.Controllers.Monitoring;

[ApiController]
[Route("api/monitoring")]
public sealed class MonitoringController(IMonitoringRepository repository) : ControllerBase
{
    [HttpGet("sc1-line")]
    [ProducesResponseType(typeof(Sc1LineSnapshotDto), StatusCodes.Status200OK)]
    public async Task<ActionResult<Sc1LineSnapshotDto>> GetSc1LineSnapshotAsync(
        CancellationToken cancellationToken)
    {
        return Ok(await repository.GetSc1LineSnapshotAsync(cancellationToken));
    }

    [HttpGet("equipment-positions")]
    [ProducesResponseType(typeof(EquipmentPositionSnapshotDto), StatusCodes.Status200OK)]
    public async Task<ActionResult<EquipmentPositionSnapshotDto>> GetEquipmentPositionsAsync(
        CancellationToken cancellationToken)
    {
        return Ok(await repository.GetEquipmentPositionsAsync(cancellationToken));
    }

    [HttpPost("bcr/{bcrNo:int}/toggle")]
    [ProducesResponseType(typeof(BcrToggleResultDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<BcrToggleResultDto>> ToggleBcrAsync(
        int bcrNo,
        CancellationToken cancellationToken)
    {
        if (bcrNo is < 1 or > 4)
        {
            return BadRequest("BCR 번호는 1~4만 허용됩니다.");
        }

        return Ok(await repository.ToggleBcrAsync(bcrNo, cancellationToken));
    }

    [HttpGet("tracks/{trackNo}")]
    [ProducesResponseType(typeof(MonitoringTrackDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<MonitoringTrackDetailDto>> GetTrackAsync(
        string trackNo,
        CancellationToken cancellationToken)
    {
        var item = await repository.GetTrackAsync(trackNo, cancellationToken);
        return item is null ? NotFound() : Ok(item);
    }

    [HttpPut("tracks/{trackNo}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> SaveTrackAsync(
        string trackNo,
        [FromBody] MonitoringTrackUpdateRequest request,
        CancellationToken cancellationToken)
    {
        return await ExecuteMutationAsync(
            () => repository.SaveTrackAsync(trackNo, request, cancellationToken));
    }

    [HttpDelete("tracks/{trackNo}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteTrackAsync(
        string trackNo,
        CancellationToken cancellationToken)
    {
        return await ExecuteMutationAsync(
            () => repository.DeleteTrackAsync(trackNo, cancellationToken));
    }

    [HttpPost("tracks/{sourceTrackNo}/move")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> MoveTrackAsync(
        string sourceTrackNo,
        [FromBody] MonitoringTrackMoveRequest request,
        CancellationToken cancellationToken)
    {
        return await ExecuteMutationAsync(
            () => repository.MoveTrackAsync(
                sourceTrackNo,
                request.DestinationTrackNo,
                cancellationToken));
    }

    [HttpGet("stackers/{craneNo:int}")]
    [ProducesResponseType(typeof(MonitoringStackerWorkDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<MonitoringStackerWorkDto>> GetStackerAsync(
        int craneNo,
        CancellationToken cancellationToken)
    {
        if (craneNo is < 1 or > 7)
            return BadRequest("스태커 크레인 호기는 1~7만 허용됩니다.");

        var item = await repository.GetStackerWorkAsync(craneNo, cancellationToken);
        return item is null ? NotFound() : Ok(item);
    }

    [HttpPost("stackers/{craneNo:int}/reissue")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> ReissueStackerAsync(
        int craneNo,
        [FromBody] MonitoringStackerReissueRequest request,
        CancellationToken cancellationToken)
    {
        if (craneNo is < 1 or > 7)
            return BadRequest("스태커 크레인 호기는 1~7만 허용됩니다.");

        return await ExecuteMutationAsync(
            () => repository.ReissueStackerAsync(
                craneNo, request.HasForkPallet, cancellationToken));
    }

    [HttpPost("stackers/{craneNo:int}/complete")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> CompleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken)
    {
        if (craneNo is < 1 or > 7)
            return BadRequest("스태커 크레인 호기는 1~7만 허용됩니다.");

        return await ExecuteMutationAsync(
            () => repository.CompleteStackerAsync(craneNo, cancellationToken));
    }

    [HttpPost("stackers/{craneNo:int}/force-delete")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> ForceDeleteStackerAsync(
        int craneNo,
        CancellationToken cancellationToken)
    {
        if (craneNo is < 1 or > 7)
            return BadRequest("스태커 크레인 호기는 1~7만 허용됩니다.");

        return await ExecuteMutationAsync(
            () => repository.ForceDeleteStackerAsync(craneNo, cancellationToken));
    }

    [HttpPost("stackers/{craneNo:int}/clear-error")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> ClearStackerErrorAsync(
        int craneNo,
        CancellationToken cancellationToken)
    {
        if (craneNo is < 1 or > 7)
            return BadRequest("스태커 크레인 호기는 1~7만 허용됩니다.");

        return await ExecuteMutationAsync(
            () => repository.ClearStackerErrorAsync(craneNo, cancellationToken));
    }

    [HttpGet("rack/{bank:int}/cells")]
    [ProducesResponseType(typeof(IReadOnlyList<MonitoringRackCellDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<MonitoringRackCellDto>>> GetRackCellsAsync(
        int bank,
        CancellationToken cancellationToken)
    {
        if (bank is < 1 or > 14)
            return BadRequest("랙 열은 1~14만 허용됩니다.");

        return Ok(await repository.GetRackCellsAsync(bank, cancellationToken));
    }

    [HttpGet("rack/cells/{location}")]
    [ProducesResponseType(typeof(MonitoringRackCellDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<MonitoringRackCellDetailDto>> GetRackCellAsync(
        string location,
        CancellationToken cancellationToken)
    {
        var item = await repository.GetRackCellDetailAsync(location, cancellationToken);
        return item is null ? NotFound() : Ok(item);
    }

    private async Task<IActionResult> ExecuteMutationAsync(Func<Task> action)
    {
        try
        {
            await action();
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
    }
}
