using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Infrastructure.Repositories.Outbounds;

namespace TOK.WMS.Api.Controllers.Outbounds;

[Route("api/outbounds/[controller]")]
[ApiController]
public class Frm4300Controller(
    IFrm4300Repository frm4300Repo)
    : ControllerBase
{
    // =========================================================
    // 조회
    // =========================================================

    [HttpGet("search")]
    public async Task<IEnumerable<Frm4300Dto.ResDto>?> SearchAsync(
        [FromQuery] Frm4300Dto.ReqDto reqDto)
    {
        return await frm4300Repo
            .SearchAsync(
                reqDto);
    }


    // =========================================================
    // 삭제
    // =========================================================

    [HttpDelete("delete")]
    public async Task<int> DeleteAsync(
        [FromBody] Frm4300Dto.DeleteReqDto reqDto)
    {
        return await frm4300Repo
            .DeleteAsync(
                reqDto);
    }


    // =========================================================
    // PLT 미출고 건수
    // =========================================================

    [HttpGet("pending-count")]
    public async Task<int> PendingCountAsync(
        [FromQuery] string pltNo)
    {
        return await frm4300Repo
            .PendingCountAsync(
                pltNo);
    }


    // =========================================================
    // 수동출고 완료
    // =========================================================

    [HttpPost("complete")]
    public async Task<Frm4300Dto.CompleteResultDto> CompleteAsync(
        [FromBody] Frm4300Dto.CompleteReqDto reqDto)
    {
        return await frm4300Repo
            .CompleteAsync(
                reqDto);
    }
}