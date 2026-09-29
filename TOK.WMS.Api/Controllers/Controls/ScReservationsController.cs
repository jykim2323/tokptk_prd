using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;

namespace TOK.WMS.Api.Controllers.Controls;

[ApiController]
[Route("api/sc-reservations")]
public sealed class ScReservationsController(IScReservationRepository repository) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<ScReservationDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<IReadOnlyList<ScReservationDto>>> GetAsync(
        [FromQuery] ScReservationQueryDto query,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await repository.GetAsync(query, cancellationToken));
        }
        catch (ArgumentException ex)
        {
            return InvalidRequest(ex.Message, "잘못된 스태커 예약 조회 요청");
        }
    }

    [HttpPut("{craneNo:int}/{sequence}/work-station")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> UpdateWorkStationAsync(
        int craneNo,
        string sequence,
        [FromBody] ScReservationWorkStationUpdateDto? values,
        CancellationToken cancellationToken)
    {
        if (values is null)
            return InvalidRequest("수정할 출고 ST 값이 필요합니다.", "잘못된 스태커 예약 수정 요청");

        try
        {
            await repository.UpdateWorkStationAsync(
                craneNo,
                sequence,
                values,
                cancellationToken);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return InvalidRequest(ex.Message, "잘못된 스태커 예약 수정 요청");
        }
        catch (KeyNotFoundException ex)
        {
            return ReservationNotFound(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return ConflictResult("스태커 예약 수정 실패", ex.Message);
        }
    }

    [HttpDelete("{craneNo:int}/{sequence}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> DeleteAsync(
        int craneNo,
        string sequence,
        CancellationToken cancellationToken)
    {
        try
        {
            await repository.DeleteAsync(craneNo, sequence, cancellationToken);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return InvalidRequest(ex.Message, "잘못된 스태커 예약 삭제 요청");
        }
        catch (KeyNotFoundException ex)
        {
            return ReservationNotFound(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return ConflictResult("스태커 예약 삭제 실패", ex.Message);
        }
    }

    private BadRequestObjectResult InvalidRequest(string detail, string title)
        => BadRequest(new ProblemDetails
        {
            Status = StatusCodes.Status400BadRequest,
            Title = title,
            Detail = detail
        });

    private NotFoundObjectResult ReservationNotFound(string detail)
        => NotFound(new ProblemDetails
        {
            Status = StatusCodes.Status404NotFound,
            Title = "스태커 예약을 찾을 수 없음",
            Detail = detail
        });

    private ObjectResult ConflictResult(string title, string detail)
        => Conflict(new ProblemDetails
        {
            Status = StatusCodes.Status409Conflict,
            Title = title,
            Detail = detail
        });
}
