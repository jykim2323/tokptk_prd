using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Infrastructure.Repositories.Outbounds;

namespace TOK.WMS.Api.Controllers.Outbounds;

[Route("api/outbounds/[controller]")]
[ApiController]
public class Frm4500Controller(
    IFrm4500Repository frm4500Repo)
    : ControllerBase
{
    // =========================================================
    // 품목별 조회
    // =========================================================

    [HttpGet("search")]
    public async Task<IEnumerable<Frm4500Dto.ItemSummaryDto>?> SearchAsync(
        [FromQuery] Frm4500Dto.ReqDto reqDto)
    {
        return await frm4500Repo
            .SearchAsync(
                reqDto);
    }


    // =========================================================
    // LOT별 조회
    // =========================================================

    [HttpGet("lotsearch")]
    public async Task<IEnumerable<Frm4500Dto.LotSummaryDto>?> LotSearchAsync(
        [FromQuery] Frm4500Dto.LotReqDto reqDto)
    {
        return await frm4500Repo
            .LotSearchAsync(
                reqDto);
    }
}