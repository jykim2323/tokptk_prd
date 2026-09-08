using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Interfaces.Inbounds;

namespace TOK.WMS.Api.Controllers.Inbounds;

[Route("api/inbounds/[controller]")]
[ApiController]
public class Frm3130Controller(
    IFrm3130Repository frm3130Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync(
        [FromQuery] Frm3130Dto.ReqDto reqDto) =>
        Ok(await frm3130Repo.SearchAsync(reqDto));


    [HttpGet("pltcheck")]
    public async Task<IActionResult> PltCheckAsync(
        [FromQuery] string pltNo) =>
        Ok(await frm3130Repo.PltCheckAsync(pltNo));


    [HttpPost("insert")]
    public async Task<IActionResult> InsertAsync(
        [FromBody] Frm3130Dto.InsertReqDto reqDto) =>
        Ok(await frm3130Repo.InsertAsync(reqDto));


    [HttpPost("empty")]
    public async Task<IActionResult> EmptyInsertAsync(
        [FromQuery] string pltNo,
        [FromQuery] string userId) =>
        Ok(await frm3130Repo.EmptyInsertAsync(
            pltNo,
            userId));


    [HttpDelete("delete")]
    public async Task<IActionResult> DeleteAsync(
        [FromBody] Frm3130Dto.DeleteReqDto reqDto) =>
        Ok(await frm3130Repo.DeleteAsync(reqDto));


    [HttpDelete("deleteall")]
    public async Task<IActionResult> DeleteAllAsync(
        [FromQuery] string pltNo) =>
        Ok(await frm3130Repo.DeleteAllAsync(pltNo));
}