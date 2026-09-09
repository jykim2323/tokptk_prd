using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Repositories.Standards;

namespace TOK.WMS.Api.Controllers.Standards;

[Route("api/standards/[controller]")]
[ApiController]
public class Frm1100Controller(
    IFrm1100Repository frm1100Repo)
    : ControllerBase
{
    // =========================================================
    // 품목 조회
    // =========================================================

    [HttpGet("search")]
    public async Task<IEnumerable<Frm1100Dto.ResDto>?> SearchAsync(
        [FromQuery] Frm1100Dto.ReqDto reqDto)
    {
        return await frm1100Repo
            .SearchAsync(
                reqDto);
    }


    // =========================================================
    // 구분1
    // =========================================================

    [HttpGet("gubn1")]
    public async Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn1SearchAsync()
    {
        return await frm1100Repo
            .Gubn1SearchAsync();
    }


    // =========================================================
    // 구분2
    // =========================================================

    [HttpGet("gubn2")]
    public async Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn2SearchAsync()
    {
        return await frm1100Repo
            .Gubn2SearchAsync();
    }


    // =========================================================
    // 구분3
    // =========================================================

    [HttpGet("gubn3")]
    public async Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn3SearchAsync()
    {
        return await frm1100Repo
            .Gubn3SearchAsync();
    }
}