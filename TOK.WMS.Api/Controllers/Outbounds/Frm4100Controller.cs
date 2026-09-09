using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Infrastructure.Repositories.Outbounds;

namespace TOK.WMS.Api.Controllers.Outbounds;

[Route("api/outbounds/[controller]")]
[ApiController]
public class Frm4100Controller(
    IFrm4100Repository frm4100Repo)
    : ControllerBase
{
    [HttpGet("search")]
    public Task<IEnumerable<Frm4100Dto.StockDto>?> SearchAsync(
        [FromQuery] Frm4100Dto.ReqDto reqDto)
        =>
        frm4100Repo.SearchAsync(
            reqDto);


    [HttpGet("pallet")]
    public Task<IEnumerable<Frm4100Dto.PalletItemDto>?> PalletSearchAsync(
        [FromQuery] string loca)
        =>
        frm4100Repo.PalletSearchAsync(
            loca);


    [HttpGet("station")]
    public Task<Frm4100Dto.StationStatusDto?> StationStatusAsync(
        [FromQuery] string loca)
        =>
        frm4100Repo.StationStatusAsync(
            loca);


    [HttpPost("reserve")]
    public Task<Frm4100Dto.ReserveResultDto> ReserveAsync(
        [FromBody] Frm4100Dto.ReserveReqDto reqDto)
        =>
        frm4100Repo.ReserveAsync(
            reqDto);


    [HttpPost("direct")]
    public Task<Frm4100Dto.DirectOutputResultDto> DirectOutputAsync(
        [FromBody] Frm4100Dto.DirectOutputReqDto reqDto)
        =>
        frm4100Repo.DirectOutputAsync(
            reqDto);
}