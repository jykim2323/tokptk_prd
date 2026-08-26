using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Interfaces.Inventory;

namespace TOK.WMS.Api.Controllers.Inventory;


[Route("api/inventory/[controller]")]
[ApiController]

public class SFrm6110Controller(ISFrm6110Repository sfrm6110Repo) : ControllerBase
{
    [HttpPut("confirmed")]
    public async Task<IActionResult> ConfirmedAsync([FromBody] SFrm6110Dto.ReqDto reqDto) =>
        Ok(await sfrm6110Repo.ConfirmedAsync(reqDto));

}

