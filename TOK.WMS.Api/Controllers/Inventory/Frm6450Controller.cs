using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Repositories;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]
public class Frm6450Controller(IFrm6450Repository frm6450Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync([FromQuery] Frm6450Dto.ReqDto reqDto) =>
        Ok(await frm6450Repo.SearchAsync(reqDto));

    [HttpGet("pltnocnt")]
    public async Task<IActionResult> PltnoCntAsync([FromQuery] Frm6450Dto.ReqDto reqDto) =>
        Ok(await frm6450Repo.PltnoCntAsync(reqDto));

}