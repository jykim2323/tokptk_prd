using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Repositories;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]
public class Frm6300Controller(IFrm6300Repository frm6300Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync([FromQuery] Frm6300Dto.ReqDto reqDto) =>
        Ok(await frm6300Repo.SearchAsync(reqDto));

    [HttpGet("lotnosearch")]
    public async Task<IActionResult> LotnoSearchAsync([FromQuery] Frm6300Dto.ReqDto reqDto) =>
        Ok(await frm6300Repo.LotnoSearchAsync(reqDto));


}