using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Repositories.Standards;

namespace TOK.WMS.Api.Controllers.Standards;

[Route("api/standards/[controller]")]
[ApiController]
public class SFrm1100Controller(
    ISFrm1100Repository sfrm1100Repo)
    : ControllerBase
{
    [HttpGet("gubn1")]
    public async Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn1SearchAsync()
    {
        return await sfrm1100Repo
            .Gubn1SearchAsync();
    }


    [HttpGet("gubn2")]
    public async Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn2SearchAsync()
    {
        return await sfrm1100Repo
            .Gubn2SearchAsync();
    }


    [HttpGet("gubn3")]
    public async Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn3SearchAsync()
    {
        return await sfrm1100Repo
            .Gubn3SearchAsync();
    }


    [HttpPost("insert")]
    public async Task<int> InsertAsync(
        [FromBody] SFrm1100Dto.ReqDto reqDto)
    {
        return await sfrm1100Repo
            .InsertAsync(
                reqDto);
    }


    [HttpPut("update")]
    public async Task<int> UpdateAsync(
        [FromBody] SFrm1100Dto.ReqDto reqDto)
    {
        return await sfrm1100Repo
            .UpdateAsync(
                reqDto);
    }


    [HttpDelete("delete")]
    public async Task<int> DeleteAsync(
        [FromBody] SFrm1100Dto.DeleteReqDto reqDto)
    {
        return await sfrm1100Repo
            .DeleteAsync(
                reqDto);
    }
}