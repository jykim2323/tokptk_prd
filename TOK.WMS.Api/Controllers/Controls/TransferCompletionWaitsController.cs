using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;

namespace TOK.WMS.Api.Controllers.Controls;

[ApiController]
[Route("api/transfer-completion-waits")]
public sealed class TransferCompletionWaitsController(
    ITransferCompletionWaitRepository repository) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(
        typeof(IReadOnlyList<TransferCompletionWaitDto>),
        StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<IReadOnlyList<TransferCompletionWaitDto>>> GetAsync(
        [FromQuery] TransferCompletionWaitQueryDto? query,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await repository.GetAsync(query, cancellationToken));
        }
        catch (ArgumentException ex)
        {
            return BadRequestProblem("잘못된 완료 대기 조회 조건", ex.Message);
        }
    }

    [HttpDelete("{sequence}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status409Conflict)]
    public async Task<IActionResult> DeleteAsync(
        string sequence,
        CancellationToken cancellationToken)
    {
        try
        {
            var deleted = await repository.DeleteAsync(sequence, cancellationToken);
            if (!deleted)
            {
                return NotFound(new ProblemDetails
                {
                    Status = StatusCodes.Status404NotFound,
                    Title = "완료 대기 항목 없음",
                    Detail = $"작업 순번 {sequence}은 이미 처리되었거나 삭제되었습니다."
                });
            }

            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return BadRequestProblem("잘못된 완료 대기 삭제 요청", ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new ProblemDetails
            {
                Status = StatusCodes.Status409Conflict,
                Title = "완료 대기 항목 삭제 충돌",
                Detail = ex.Message
            });
        }
    }

    private BadRequestObjectResult BadRequestProblem(string title, string detail)
        => BadRequest(new ProblemDetails
        {
            Status = StatusCodes.Status400BadRequest,
            Title = title,
            Detail = detail
        });
}
