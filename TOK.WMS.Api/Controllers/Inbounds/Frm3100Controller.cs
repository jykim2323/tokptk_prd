using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;

namespace TOK.WMS.Api.Controllers.Inbounds;

[Route("api/inbounds/[controller]")]
[ApiController]
public class Frm3100Controller(IFrm3100Repository frm3100Repo) : ControllerBase
{
    [HttpGet("search")]
    public async Task<IActionResult> SearchAsync([FromQuery] Frm3100Dto query) =>
        Ok(await frm3100Repo.SearchAsync(query));

    [HttpPost("add")]
    public async Task<IActionResult> AddAsync([FromBody] Frm3100AddReqDto query)
    {
        try
        {
            await frm3100Repo.AddAsync(query.Model, query.Items);

            return Ok();
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpGet("track")]
    public async Task<IActionResult> TrackingAsync([FromQuery] string sPltno) =>
      Ok(await frm3100Repo.TrakingAsync(sPltno));

    [HttpGet("save/trak")]
    public async Task<IActionResult> TrakAsync([FromQuery] string sPltno) =>
      Ok(await frm3100Repo.Trak_check(sPltno));

    [HttpGet("save/lstk")]
    public async Task<IActionResult> LstkAsync([FromQuery] string sPltno) =>
      Ok(await frm3100Repo.Lstk_check(sPltno));

    [HttpGet("save/subk")]
    public async Task<IActionResult> SubkAsync([FromQuery] string sPltno) =>
      Ok(await frm3100Repo.Subk_check(sPltno));

    [HttpGet("save/subk/del")]
    public async Task<IActionResult> DelAsync([FromQuery] string sPltno) =>
      Ok(await frm3100Repo.Subk_Del(sPltno));


    [HttpPost("save/subk/insert")]
    public async Task<IActionResult> InsertAsync([FromBody] Frm3100ResDto sPltno) =>
      Ok(await frm3100Repo.Subk_insert(sPltno));

    [HttpGet("speed")]
    public async Task<IActionResult> SpeedAsync([FromQuery] string sPltno) =>
      Ok(await frm3100Repo.SpeedhAsync(sPltno));
    public class Frm3100AddReqDto
    {
        public Frm3100Dto Model { get; set; } = new();

        public IReadOnlyCollection<Frm3100ResDto> Items { get; set; }
            = Array.Empty<Frm3100ResDto>();
    }

}
