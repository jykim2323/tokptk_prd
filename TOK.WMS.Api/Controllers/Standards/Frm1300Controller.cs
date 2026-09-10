using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Repositories.Standards;

namespace TOK.WMS.Api.Controllers.Standards;

[Route("api/standards/[controller]")]
[ApiController]
public class Frm1300Controller(
    IFrm1300Repository frm1300Repo)
    : ControllerBase
{
    // =========================================================
    // 검색
    // =========================================================

    [HttpGet("search")]
    public async Task<IEnumerable<Frm1300Dto.ResDto>?> SearchAsync(
        [FromQuery] Frm1300Dto.ReqDto reqDto)
    {
        return await frm1300Repo
            .SearchAsync(
                reqDto);
    }


    // =========================================================
    // 전체 조회
    // =========================================================

    [HttpGet("all")]
    public async Task<IEnumerable<Frm1300Dto.ResDto>?> AllSearchAsync()
    {
        return await frm1300Repo
            .AllSearchAsync();
    }


    // =========================================================
    // 중복 체크
    // =========================================================

    [HttpGet("duplicate")]
    public async Task<bool> DuplicateCheckAsync(
        [FromQuery] Frm1300Dto.DuplicateReqDto reqDto)
    {
        return await frm1300Repo
            .DuplicateCheckAsync(
                reqDto);
    }


    // =========================================================
    // 등록
    // =========================================================

    [HttpPost("insert")]
    public async Task<int> InsertAsync(
        [FromBody] Frm1300Dto.SaveReqDto reqDto)
    {
        return await frm1300Repo
            .InsertAsync(
                reqDto);
    }


    // =========================================================
    // 수정
    // =========================================================

    [HttpPut("update")]
    public async Task<int> UpdateAsync(
        [FromBody] Frm1300Dto.SaveReqDto reqDto)
    {
        return await frm1300Repo
            .UpdateAsync(
                reqDto);
    }


    // =========================================================
    // 삭제
    // =========================================================

    [HttpDelete("delete")]
    public async Task<int> DeleteAsync(
        [FromBody] Frm1300Dto.DeleteReqDto reqDto)
    {
        return await frm1300Repo
            .DeleteAsync(
                reqDto);
    }
}