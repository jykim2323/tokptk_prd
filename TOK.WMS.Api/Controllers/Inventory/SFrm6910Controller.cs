using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces.Inventory;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]

public class SFrm6910Controller(ISFrm6910Repository sfrm6910Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync(
    [FromQuery] string pltNo)
    {
        return Ok(await sfrm6910Repo.SearchAsync(pltNo));
    }

    [HttpPut("save")]
    public async Task<IActionResult> SaveAsync(
    [FromBody] SFrm6910Dto.SaveReqDto reqDto)
    {
        return Ok(await sfrm6910Repo.SaveAsync(reqDto));
    }

}

