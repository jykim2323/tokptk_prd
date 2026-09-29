using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;

namespace TOK.WMS.Api.Controllers.Controls;

[ApiController]
[Route("api/error-histories")]
public sealed class ErrorHistoriesController(IErrorHistoryRepository repository) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<ErrorHistoryDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<IReadOnlyList<ErrorHistoryDto>>> SearchAsync(
        [FromQuery] DateOnly? startDate,
        [FromQuery] DateOnly? endDate,
        [FromQuery] string? craneNo,
        CancellationToken cancellationToken)
    {
        if (startDate is null || endDate is null)
            return InvalidRequest("시작일과 종료일이 필요합니다.");

        try
        {
            return Ok(await repository.SearchAsync(
                startDate.Value,
                endDate.Value,
                craneNo,
                cancellationToken));
        }
        catch (ArgumentException ex)
        {
            return InvalidRequest(ex.Message);
        }
    }

    [HttpDelete("{occurredAtRaw}/{craneNo}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> DeleteAsync(
        string occurredAtRaw,
        string craneNo,
        CancellationToken cancellationToken)
    {
        try
        {
            await repository.DeleteAsync(occurredAtRaw, craneNo, cancellationToken);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return InvalidRequest(ex.Message);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new ProblemDetails
            {
                Status = StatusCodes.Status404NotFound,
                Title = "에러 이력을 찾을 수 없음",
                Detail = ex.Message
            });
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new ProblemDetails
            {
                Status = StatusCodes.Status409Conflict,
                Title = "에러 이력 삭제 실패",
                Detail = ex.Message
            });
        }
    }

    private BadRequestObjectResult InvalidRequest(string detail)
        => BadRequest(new ProblemDetails
        {
            Status = StatusCodes.Status400BadRequest,
            Title = "잘못된 에러 이력 요청",
            Detail = detail
        });
}
