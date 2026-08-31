using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Repositories;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]
public class Frm6100Controller(IFrm6100Repository frm6100Repo, ICoreRepository coreRepo) : ControllerBase
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

    [HttpGet("lstkpltnocheck")]
    public async Task<IActionResult> Lstkpltnocheck([FromQuery] string lstkLoca) =>
        Ok(await coreRepo.Lstk_pltno_check(lstkLoca));

    [HttpGet("subklocacheck")]
    public async Task<IActionResult> Subklocacheck([FromQuery] string lstkPltno) =>
        Ok(await coreRepo.Subk_loca_check(lstkPltno));

    [HttpPut("cancelsubk")]
    public async Task<IActionResult> CancelSubkAsync([FromBody] string subkPltno) =>
      Ok(await frm6100Repo.CancelSubkAsync(subkPltno));

    [HttpPut("cancellstk")]
    public async Task<IActionResult> CancelLstkAsync([FromBody] string subkPltno) =>
      Ok(await frm6100Repo.CancelLstkAsync(subkPltno));

    [HttpPut("deletepltno")]
    public async Task<IActionResult> DeletePltNoAsync([FromBody] Frm6100Dto.SubkDto subkDto) =>
      Ok(await frm6100Repo.DeletePltNoAsync(subkDto));

    [HttpPut("resetlstk")]
    public async Task<IActionResult> ResetLstkAsync([FromBody] string lstkLoca) =>
      Ok(await frm6100Repo.ResetLstkAsync(lstkLoca));
}
