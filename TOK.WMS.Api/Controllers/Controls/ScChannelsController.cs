using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.Core.Interfaces.Controls;

namespace TOK.WMS.Api.Controllers.Controls;

[ApiController]
[Route("api/sc-channels")]
public sealed class ScChannelsController(IScChannelRepository repository) : ControllerBase
{
    [HttpGet("{scNo:int}")]
    [ProducesResponseType(typeof(IReadOnlyList<ScChannelDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<IReadOnlyList<ScChannelDto>>> GetChannelsAsync(int scNo)
    {
        if (scNo is < 1 or > 7)
        {
            return BadRequest(new ProblemDetails
            {
                Status = StatusCodes.Status400BadRequest,
                Title = "잘못된 스태커 크레인 호기",
                Detail = "스태커 크레인 호기는 1에서 7 사이여야 합니다."
            });
        }

        return Ok(await repository.GetChannelsAsync(scNo));
    }

    [HttpPut("{scNo:int}/{sr}/{group}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> UpdateChannelGroupAsync(
        int scNo,
        string sr,
        string group,
        [FromBody] ScChannelUpdateDto values)
    {
        if (scNo is < 1 or > 7)
            return InvalidRequest("스태커 크레인 호기는 1에서 7 사이여야 합니다.");

        var normalizedSr = (sr ?? string.Empty).Trim().ToUpperInvariant();
        if (normalizedSr is not ("R" or "S"))
            return InvalidRequest("송·수신 구분은 R 또는 S여야 합니다.");

        if (!Enum.TryParse<ScChannelUpdateGroup>(group, true, out var updateGroup)
            || !Enum.IsDefined(updateGroup))
        {
            return InvalidRequest("수정 영역은 ch01, ch06, words 중 하나여야 합니다.");
        }

        try
        {
            await repository.UpdateChannelGroupAsync(
                scNo,
                normalizedSr,
                updateGroup,
                values);
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
                Title = "신호 수정 실패",
                Detail = ex.Message
            });
        }
    }

    private BadRequestObjectResult InvalidRequest(string detail)
        => BadRequest(new ProblemDetails
        {
            Status = StatusCodes.Status400BadRequest,
            Title = "잘못된 신호 수정 요청",
            Detail = detail
        });
}
