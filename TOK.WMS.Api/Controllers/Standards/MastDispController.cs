using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Repositories.Standards;

namespace TOK.WMS.Api.Controllers.Standards;

[Route("api/standards/[controller]")]
[ApiController]
public class MastDispController(
    IMastDispRepository mastDispRepo)
    : ControllerBase
{
    // =========================================================
    // 검색
    // =========================================================

    [HttpGet("search")]
    public async Task<IEnumerable<MastDispDto.ResDto>?> SearchAsync(
        [FromQuery] MastDispDto.ReqDto reqDto)
    {
        return await mastDispRepo
            .SearchAsync(
                reqDto);
    }


    // =========================================================
    // 전체보기
    // =========================================================

    [HttpGet("all")]
    public async Task<IEnumerable<MastDispDto.ResDto>?> AllSearchAsync()
    {
        return await mastDispRepo
            .AllSearchAsync();
    }
}