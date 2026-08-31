using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]

public class SFrm6120Controller(ISFrm6120Repository sfrm6120Repo, ICoreRepository coreRepo) : ControllerBase
{
    [HttpGet("lstkpltnocheck")]
    public async Task<IActionResult> LstkpltnocheckAsync([FromQuery] SFrm6120Dto.ReqDto reqDto) =>
    Ok(await sfrm6120Repo.LstkpltnocheckAsync(reqDto));

    [HttpGet("subklocacheck")]
    public async Task<IActionResult> SubklocacheckAsync([FromQuery] string subkpltno) 
    {
        var result = await sfrm6120Repo.SubklocacheckAsync(subkpltno);

        return new JsonResult(result ?? "");
    }

    [HttpPut("confirmed")]
    public async Task<IActionResult> ConfirmedAsync([FromBody] SFrm6120Dto.ReqDto reqDto) =>
        Ok(await sfrm6120Repo.ConfirmedAsync(reqDto));

    [HttpGet("subksearch")]
    public async Task<IActionResult> SubkSearchAsync([FromQuery] string subkpltno) =>
        Ok(await sfrm6120Repo.SubkSearchAsync(subkpltno));

    [HttpGet("lstkcheck")]
    public async Task<IActionResult> LstkcheckAsync([FromQuery] string subkpltno) =>
        Ok(await coreRepo.Lstk_check(subkpltno));

    [HttpPut("milstkupdate")]
    public async Task<IActionResult> MilstkUpdateAsync([FromBody] SFrm6120Dto.ReqDto reqDto) =>
        Ok(await sfrm6120Repo.MilstkUpdateAsync(reqDto));
    
    [HttpPut("misubkupdate")]
    public async Task<IActionResult> MisubkUpdateAsync([FromBody] SFrm6120Dto.ReqDto reqDto) =>
        Ok(await sfrm6120Repo.MisubkUpdateAsync(reqDto));
}

