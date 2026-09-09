using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Core.Interfaces.Outbounds;

namespace TOK.WMS.Api.Controllers.Outbounds;

[Route("api/outbounds/[controller]")]
[ApiController]
public class Frm4103Controller(
    IFrm4103Repository frm4103Repo)
    : ControllerBase
{
    [HttpGet("chasu")]
    public async Task<IActionResult> SearchChasuAsync(
        [FromQuery] string outDate) =>
        Ok(
            await frm4103Repo.SearchChasuAsync(
                outDate));


    [HttpGet("summary")]
    public async Task<IActionResult> SearchSummaryAsync(
        [FromQuery] Frm4103Dto.ReqDto reqDto) =>
        Ok(
            await frm4103Repo.SearchSummaryAsync(
                reqDto));


    [HttpGet("schedules")]
    public async Task<IActionResult> SearchSchedulesAsync() =>
        Ok(
            await frm4103Repo.SearchSchedulesAsync());


    [HttpDelete("delete")]
    public async Task<IActionResult> DeleteAsync(
        [FromBody] Frm4103Dto.DeleteReqDto reqDto) =>
        Ok(
            await frm4103Repo.DeleteAsync(
                reqDto));


    [HttpPost("confirm")]
    public async Task<IActionResult> ConfirmAsync(
        [FromBody] Frm4103Dto.ConfirmReqDto reqDto) =>
        Ok(
            await frm4103Repo.ConfirmAsync(
                reqDto));
}