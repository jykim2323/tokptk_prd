using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Core.Interfaces;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]

public class LocaAddController(ILocaAddRepository locaAddRepo) : ControllerBase
{

    [HttpGet("subkcheck")]
    public async Task<IActionResult> SubkCheckAsync([FromQuery] LocaAddDto.ReqDto reqDto) =>
        Ok(await locaAddRepo.SubkCheckAsync(reqDto));

    [HttpPut("confirmed")]
    public async Task<IActionResult> ConfirmedAsync([FromBody] LocaAddDto.ReqDto reqDto) =>
        Ok(await locaAddRepo.ConfirmedAsync(reqDto));

}

