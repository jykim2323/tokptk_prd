using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Interfaces.Inbounds;

namespace TOK.WMS.Api.Controllers.Inbounds;

[Route("api/inbounds/[controller]")]
[ApiController]
public class Frm3900Controller(
    IFrm3900Repository frm3900Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync(
        [FromQuery] Frm3900Dto.ReqDto reqDto) =>
        Ok(await frm3900Repo.SearchAsync(reqDto));


    [HttpGet("floorstock")]
    public async Task<IActionResult> FloorStockSearchAsync(
        [FromQuery] string pltNo) =>
        Ok(await frm3900Repo.FloorStockSearchAsync(pltNo));


    [HttpGet("itemcheck")]
    public async Task<IActionResult> ItemCheckAsync(
        [FromQuery] string itemCode) =>
        Ok(await frm3900Repo.ItemCheckAsync(itemCode));


    [HttpGet("pltcheck")]
    public async Task<IActionResult> PltCheckAsync(
        [FromQuery] string pltNo) =>
        Ok(await frm3900Repo.PltCheckAsync(pltNo));


    [HttpPost("save")]
    public async Task<IActionResult> SaveAsync(
        [FromBody] Frm3900Dto.SaveReqDto reqDto) =>
        Ok(await frm3900Repo.SaveAsync(reqDto));
}