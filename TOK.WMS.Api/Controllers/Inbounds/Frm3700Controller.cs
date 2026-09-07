using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;

namespace TOK.WMS.Api.Controllers.Inbounds;

[Route("api/inbounds/[controller]")]
[ApiController]
public class Frm3700Controller(IFrm3700Repository frm3700Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync(
        [FromQuery] Frm3700Dto.ReqDto reqDto)
    {
        return Ok(
            await frm3700Repo.SearchAsync(reqDto));
    }


    [HttpGet("lot-search")]
    public async Task<IActionResult> LotSearchAsync(
        [FromQuery] Frm3700Dto.LotReqDto reqDto)
    {
        return Ok(
            await frm3700Repo.LotSearchAsync(reqDto));
    }
}
