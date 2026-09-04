using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]

public class SFrm6130Controller(ISFrm6130Repository sf6130Repo) : ControllerBase
{
    [HttpGet("subkcheck")]
    public async Task<IActionResult> SubkCheckAsync([FromQuery] SFrm6130Dto.ReqDto reqDto) =>
        Ok(await sf6130Repo.SubkCheckAsync(reqDto));

    [HttpPut("confirmed")]
    public async Task<IActionResult> ConfirmedAsync([FromBody] SFrm6130Dto.ReqDto reqDto) =>
        Ok(await sf6130Repo.ConfirmedAsync(reqDto));

    [HttpPost("subkinsert")]
    public async Task<IActionResult> SubkInsertAsync([FromBody] SFrm6130Dto.ReqDto sPltno) =>
      Ok(await sf6130Repo.SubkInsert(sPltno));

    [HttpPut("subkupdate")]
    public async Task<IActionResult> SubkUpdateAsync([FromBody] SFrm6130Dto.ReqDto reqDto) =>
        Ok(await sf6130Repo.SubkUpdateAsync(reqDto));

}

