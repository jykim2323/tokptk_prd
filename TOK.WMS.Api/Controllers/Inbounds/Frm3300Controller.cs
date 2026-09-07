using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;

namespace TOK.WMS.Api.Controllers.Inbounds;

[Route("api/inbounds/[controller]")]
[ApiController]
public class Frm3300Controller(IFrm3300Repository frm3300Repo) : ControllerBase
{
    // =========================================================
    // 조회
    // GET api/inventory/frm3300/search
    // =========================================================
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync()
    {
        return Ok(await frm3300Repo.SearchAsync());
    }


    // =========================================================
    // 삭제
    // DELETE api/inventory/frm3300/delete
    // =========================================================
    [HttpDelete("delete")]
    public async Task<IActionResult> DeleteAsync(
        [FromBody] Frm3300Dto.DeleteReqDto reqDto)
    {
        return Ok(await frm3300Repo.DeleteAsync(reqDto));
    }


    // =========================================================
    // 입고라벨 발행
    // PUT api/inventory/frm3300/label-print
    // =========================================================
    [HttpPut("label-print")]
    public async Task<IActionResult> LabelPrintAsync(
        [FromBody] Frm3300Dto.ReqDto reqDto)
    {
        return Ok(await frm3300Repo.LabelPrintAsync(reqDto));
    }


    // =========================================================
    // 입고라벨 발행 완료
    // PUT api/inventory/frm3300/label-complete
    // =========================================================
    [HttpPut("label-complete")]
    public async Task<IActionResult> LabelPrintCompleteAsync(
        [FromBody] Frm3300Dto.ReqDto reqDto)
    {
        return Ok(await frm3300Repo.LabelPrintCompleteAsync(reqDto));
    }

}
