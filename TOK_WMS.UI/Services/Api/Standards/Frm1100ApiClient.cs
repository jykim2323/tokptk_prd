using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.UI.Services.Api.Standards;

public interface IFrm1100Api
{
    Task<IEnumerable<Frm1100Dto.ResDto>?> SearchAsync(
        Frm1100Dto.ReqDto reqDto);


    Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn1SearchAsync();

    Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn2SearchAsync();

    Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn3SearchAsync();
}


public class Frm1100ApiClient(
    HttpClient http)
    : IFrm1100Api
{
    // =========================================================
    // 조회
    // =========================================================

    public Task<IEnumerable<Frm1100Dto.ResDto>?> SearchAsync(
        Frm1100Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["ItemCode"] =
                    reqDto.ItemCode
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/standards/frm1100/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm1100Dto.ResDto>>(
            url);
    }


    public Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn1SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm1100Dto.GubnDto>>(
            "api/standards/frm1100/gubn1");
    }


    public Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn2SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm1100Dto.GubnDto>>(
            "api/standards/frm1100/gubn2");
    }


    public Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn3SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm1100Dto.GubnDto>>(
            "api/standards/frm1100/gubn3");
    }
}