using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;

namespace TOK.WMS.Api.Controllers.Inbounds;

[Route("api/inbounds/[controller]")]
[ApiController]
public class Frm3400Controller(IFrm3400Repository frm3400Repo) : ControllerBase
{
    // =========================================================
    // 조회
    // GET api/inventory/frm3400/search
    // =========================================================
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync(
     [FromQuery] Frm3400Dto.ReqDto reqDto)
    {
        return Ok(await frm3400Repo.SearchAsync(reqDto));
    }


    // =========================================================
    // 삭제
    // DELETE api/inventory/frm3400/delete
    // =========================================================
    [HttpDelete("delete")]
    public async Task<IActionResult> DeleteAsync(
        [FromBody] Frm3400Dto.DeleteReqDto reqDto)
    {
        return Ok(await frm3400Repo.DeleteAsync(reqDto));
    }
}
