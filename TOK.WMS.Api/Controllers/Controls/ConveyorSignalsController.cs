using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;

namespace TOK.WMS.Api.Controllers.Controls;

[ApiController]
[Route("api/conveyor-signals")]
public sealed class ConveyorSignalsController(IConveyorSignalRepository repository) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<ConveyorSignalGridDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<ConveyorSignalGridDto>>> GetAsync(
        CancellationToken cancellationToken)
        => Ok(await repository.GetAsync(cancellationToken));

    [HttpPut("{direction}/{gridNo:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> UpdateAsync(
        string direction,
        int gridNo,
        [FromBody] ConveyorSignalUpdateDto values,
        CancellationToken cancellationToken)
    {
        var normalizedDirection = (direction ?? string.Empty).Trim().ToUpperInvariant();
        if (normalizedDirection is not ("R" or "S"))
            return InvalidRequest("송·수신 구분은 R 또는 S여야 합니다.");

        if (gridNo is < 1 or > 12)
            return InvalidRequest("컨베이어 신호 Grid 번호는 1에서 12 사이여야 합니다.");

        try
        {
            await repository.UpdateAsync(
                normalizedDirection,
                gridNo,
                values,
                cancellationToken);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return InvalidRequest(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new ProblemDetails
            {
                Status = StatusCodes.Status409Conflict,
                Title = "컨베이어 신호 수정 실패",
                Detail = ex.Message
            });
        }
    }

    [HttpPatch("{direction}/{gridNo:int}/bits/{bitIndex:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> UpdateBitAsync(
        string direction,
        int gridNo,
        int bitIndex,
        [FromBody] ConveyorSignalBitUpdateDto values,
        CancellationToken cancellationToken)
    {
        var normalizedDirection = (direction ?? string.Empty).Trim().ToUpperInvariant();
        if (normalizedDirection is not ("R" or "S"))
            return InvalidRequest("송·수신 구분은 R 또는 S여야 합니다.");

        if (gridNo is < 1 or > 12)
            return InvalidRequest("컨베이어 신호 Grid 번호는 1에서 12 사이여야 합니다.");

        if (bitIndex is < 0 or > 15)
            return InvalidRequest("컨베이어 신호 BIT 번호는 0에서 15 사이여야 합니다.");

        try
        {
            await repository.UpdateBitAsync(
                normalizedDirection,
                gridNo,
                bitIndex,
                values,
                cancellationToken);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return InvalidRequest(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new ProblemDetails
            {
                Status = StatusCodes.Status409Conflict,
                Title = "컨베이어 단일 BIT 수정 실패",
                Detail = ex.Message
            });
        }
    }

    private BadRequestObjectResult InvalidRequest(string detail)
        => BadRequest(new ProblemDetails
        {
            Status = StatusCodes.Status400BadRequest,
            Title = "잘못된 컨베이어 신호 수정 요청",
            Detail = detail
        });
}
