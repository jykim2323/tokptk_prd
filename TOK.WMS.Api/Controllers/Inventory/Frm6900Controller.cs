using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Repositories;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]
public class Frm6900Controller(IFrm6900Repository frm6900Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync([FromQuery] Frm6900Dto.ReqDto reqDto) =>
        Ok(await frm6900Repo.SearchAsync(reqDto));

    [HttpGet("subksearch")]
    public async Task<IActionResult> SubkSearchAsync([FromQuery] Frm6900Dto.ReqDto reqDto) =>
       Ok(await frm6900Repo.SubkSearchAsync(reqDto));

    [HttpGet("track")]
    public async Task<IActionResult> TrackingAsync([FromQuery] string sPltno) =>
      Ok(await frm6900Repo.TrakingAsync(sPltno));

    [HttpGet("lstkcheck")]
    public async Task<IActionResult> LstkCheckAsync([FromQuery] string sPltno) =>
      Ok(await frm6900Repo.LstkCheckAsync(sPltno));

    [HttpGet("subklocacheck")]
    public async Task<IActionResult> SubkLocaCheckAsync([FromQuery] string sPltno) =>
        Ok(await frm6900Repo.SubkLocaCheck(sPltno));

    [HttpGet("subkcheck")]
    public async Task<IActionResult> SubkCheckAsync([FromQuery] string subkLoca) =>
        Ok(await frm6900Repo.SubkCheck(subkLoca));

    [HttpGet("delete")]
    public async Task<IActionResult> DeleteAsync([FromQuery] string subkLoca) =>
    Ok(await frm6900Repo.DeleteAsync(subkLoca));

    [HttpGet("lstkclear")]
    public async Task<IActionResult> LstkClearAsync([FromQuery] string lstkLoca) =>
        Ok(await frm6900Repo.LstkClearAsync(lstkLoca));
}