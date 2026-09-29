using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;

namespace TOK.WMS.Api.Controllers.Controls;

[ApiController]
[Route("api/system-operation")]
public sealed class SystemOperationController(ISystemOperationRepository repository) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(SystemOperationDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<SystemOperationDto>> GetAsync(CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await repository.GetAsync(cancellationToken));
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new ProblemDetails
            {
                Status = StatusCodes.Status409Conflict,
                Title = "시스템 운전 설정 조회 실패",
                Detail = ex.Message
            });
        }
    }

    [HttpPut("{group}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> UpdateAsync(
        string group,
        [FromBody] SystemOperationUpdateDto? values,
        CancellationToken cancellationToken)
    {
        if (!Enum.TryParse<SystemOperationUpdateGroup>(group, true, out var updateGroup)
            || !Enum.IsDefined(updateGroup))
        {
            return InvalidRequest("수정 영역은 modes, sequences, inboundcrane 중 하나여야 합니다.");
        }

        if (values is null)
            return InvalidRequest("수정할 시스템 운전 설정 값이 필요합니다.");

        try
        {
            await repository.UpdateAsync(updateGroup, values, cancellationToken);
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
                Title = "시스템 운전 설정 수정 실패",
                Detail = ex.Message
            });
        }
    }

    private BadRequestObjectResult InvalidRequest(string detail)
        => BadRequest(new ProblemDetails
        {
            Status = StatusCodes.Status400BadRequest,
            Title = "잘못된 시스템 운전 설정 수정 요청",
            Detail = detail
        });
}
