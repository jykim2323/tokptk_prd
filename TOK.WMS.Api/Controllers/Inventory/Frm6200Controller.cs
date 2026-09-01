using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Repositories;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]
public class Frm6200Controller(IFrm6200Repository frm6200Repo, ICoreRepository coreRepo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync([FromQuery] Frm6200Dto.SearchReqDto searchDto) =>
        Ok(await frm6200Repo.SearchAsync(searchDto));

    [HttpPut("prohibition")]
    public async Task<IActionResult> ProhibitionAsync([FromBody] Frm6200Dto.ProhibitionReqDto reqDto) =>
        Ok(await frm6200Repo.ProhibitionAsync(reqDto));

}