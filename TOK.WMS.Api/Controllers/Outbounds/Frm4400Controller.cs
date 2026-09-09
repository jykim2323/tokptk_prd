using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Infrastructure.Repositories.Outbounds;

namespace TOK.WMS.Api.Controllers.Outbounds;

[Route("api/outbounds/[controller]")]
[ApiController]
public class Frm4400Controller(
    IFrm4400Repository frm4400Repo)
    : ControllerBase
{
    // =========================================================
    // 조회
    // =========================================================

    [HttpGet("search")]
    public async Task<IEnumerable<Frm4400Dto.ResDto>?> SearchAsync(
        [FromQuery] Frm4400Dto.ReqDto reqDto)
    {
        return await frm4400Repo
            .SearchAsync(
                reqDto);
    }


    // =========================================================
    // 납품처
    // =========================================================

    [HttpGet("customers")]
    public async Task<IEnumerable<Frm4400Dto.CustomerDto>?> CustomerSearchAsync()
    {
        return await frm4400Repo
            .CustomerSearchAsync();
    }


    // =========================================================
    // 삭제
    // =========================================================

    [HttpDelete("delete")]
    public async Task<int> DeleteAsync(
        [FromBody] Frm4400Dto.DeleteReqDto reqDto)
    {
        return await frm4400Repo
            .DeleteAsync(
                reqDto);
    }
}