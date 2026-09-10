using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Repositories.Standards;

namespace TOK.WMS.Api.Controllers.Standards;

[Route("api/standards/[controller]")]
[ApiController]
public class Frm1500Controller(
    IFrm1500Repository frm1500Repo)
    : ControllerBase
{
    // =========================================================
    // 조회
    // =========================================================

    [HttpGet("gubn1")]
    public async Task<IEnumerable<Frm1500Dto.Gubn1Dto>?> Gubn1SearchAsync()
    {
        return await frm1500Repo
            .Gubn1SearchAsync();
    }


    [HttpGet("gubn2")]
    public async Task<IEnumerable<Frm1500Dto.Gubn2Dto>?> Gubn2SearchAsync()
    {
        return await frm1500Repo
            .Gubn2SearchAsync();
    }


    [HttpGet("gubn3")]
    public async Task<IEnumerable<Frm1500Dto.Gubn3Dto>?> Gubn3SearchAsync()
    {
        return await frm1500Repo
            .Gubn3SearchAsync();
    }


    // =========================================================
    // 구분#1
    // =========================================================

    [HttpPost("gubn1")]
    public async Task<int> InsertGubn1Async(
        [FromBody] Frm1500Dto.SaveReqDto reqDto)
    {
        return await frm1500Repo
            .InsertGubn1Async(
                reqDto);
    }


    [HttpPut("gubn1")]
    public async Task<int> UpdateGubn1Async(
        [FromBody] Frm1500Dto.SaveReqDto reqDto)
    {
        return await frm1500Repo
            .UpdateGubn1Async(
                reqDto);
    }


    [HttpDelete("gubn1")]
    public async Task<int> DeleteGubn1Async(
        [FromBody] Frm1500Dto.DeleteReqDto reqDto)
    {
        return await frm1500Repo
            .DeleteGubn1Async(
                reqDto);
    }


    // =========================================================
    // 구분#2
    // =========================================================

    [HttpPost("gubn2")]
    public async Task<int> InsertGubn2Async(
        [FromBody] Frm1500Dto.SaveReqDto reqDto)
    {
        return await frm1500Repo
            .InsertGubn2Async(
                reqDto);
    }


    [HttpPut("gubn2")]
    public async Task<int> UpdateGubn2Async(
        [FromBody] Frm1500Dto.SaveReqDto reqDto)
    {
        return await frm1500Repo
            .UpdateGubn2Async(
                reqDto);
    }


    [HttpDelete("gubn2")]
    public async Task<int> DeleteGubn2Async(
        [FromBody] Frm1500Dto.DeleteReqDto reqDto)
    {
        return await frm1500Repo
            .DeleteGubn2Async(
                reqDto);
    }


    // =========================================================
    // 구분#3
    // =========================================================

    [HttpPost("gubn3")]
    public async Task<int> InsertGubn3Async(
        [FromBody] Frm1500Dto.SaveReqDto reqDto)
    {
        return await frm1500Repo
            .InsertGubn3Async(
                reqDto);
    }


    [HttpPut("gubn3")]
    public async Task<int> UpdateGubn3Async(
        [FromBody] Frm1500Dto.SaveReqDto reqDto)
    {
        return await frm1500Repo
            .UpdateGubn3Async(
                reqDto);
    }


    [HttpDelete("gubn3")]
    public async Task<int> DeleteGubn3Async(
        [FromBody] Frm1500Dto.DeleteReqDto reqDto)
    {
        return await frm1500Repo
            .DeleteGubn3Async(
                reqDto);
    }
}