using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Core.Interfaces.Outbounds;

namespace TOK.WMS.Api.Controllers.Outbounds;

[Route("api/outbounds/[controller]")]
[ApiController]
public class Frm4101Controller(
    IFrm4101Repository frm4101Repo) : ControllerBase
{
    [HttpPost("save")]
    public async Task<IActionResult> SaveAsync(
        [FromBody] Frm4101Dto.SaveReqDto reqDto) =>
        Ok(await frm4101Repo.SaveAsync(reqDto));
}