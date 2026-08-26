using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces.Inventory;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]
public class Frm6100Controller(IFrm6100Repository frm6100Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync([FromQuery] Frm6100Dto reqDto) =>
        Ok(await frm6100Repo.SearchAsync(reqDto));

    [HttpGet("subksearch")]
    public async Task<IActionResult> SubkSearchAsync([FromQuery] string lstkLoca) =>
        Ok(await frm6100Repo.SubkSearchAsync(lstkLoca));

    [HttpGet("subkcheck")]
    public async Task<IActionResult> SubkCheckAsync([FromQuery] string lstkLoca) =>
        Ok(await frm6100Repo.SubkCheckAsync(lstkLoca));

    [HttpGet("delete")]
    public async Task<IActionResult> DeleteAsync([FromQuery] string subkLoca) =>
        Ok(await frm6100Repo.DeleteAsync(subkLoca));
    [HttpGet("lstkclear")]
    public async Task<IActionResult> LstkClearAsync([FromQuery] string lstkLoca) =>
        Ok(await frm6100Repo.LstkClearAsync(lstkLoca));
}
