using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Core.Interfaces.Outbounds;

namespace TOK.WMS.Api.Controllers.Outbounds;

[Route("api/outbounds/[controller]")]
[ApiController]
public class Frm4102Controller(
    IFrm4102Repository frm4102Repo)
    : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync(
        [FromQuery] Frm4102Dto.ReqDto reqDto) =>
        Ok(await frm4102Repo.SearchAsync(reqDto));


    [HttpPost("reserve")]
    public async Task<IActionResult> ReserveAsync(
        [FromBody] Frm4102Dto.ReserveReqDto reqDto) =>
        Ok(await frm4102Repo.ReserveAsync(reqDto));


    [HttpDelete("delete")]
    public async Task<IActionResult> DeleteAsync(
        [FromBody] Frm4102Dto.DeleteReqDto reqDto) =>
        Ok(await frm4102Repo.DeleteAsync(reqDto));


    [HttpDelete("deleteall")]
    public async Task<IActionResult> DeleteAllAsync() =>
        Ok(await frm4102Repo.DeleteAllAsync());
}