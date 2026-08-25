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
}
