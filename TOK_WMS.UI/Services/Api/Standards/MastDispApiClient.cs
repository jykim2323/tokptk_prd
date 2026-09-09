using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.UI.Services.Api.Standards;

public interface IMastDispApi
{
    Task<IEnumerable<MastDispDto.ResDto>?> SearchAsync(
        MastDispDto.ReqDto reqDto);


    Task<IEnumerable<MastDispDto.ResDto>?> AllSearchAsync();
}


public class MastDispApiClient(
    HttpClient http)
    : IMastDispApi
{
    // =========================================================
    // 검색
    // =========================================================

    public Task<IEnumerable<MastDispDto.ResDto>?> SearchAsync(
        MastDispDto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["SearchText"] =
                    reqDto.SearchText
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/standards/mastdisp/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<MastDispDto.ResDto>>(
            url);
    }


    // =========================================================
    // 전체보기
    // =========================================================

    public Task<IEnumerable<MastDispDto.ResDto>?> AllSearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<MastDispDto.ResDto>>(
            "api/standards/mastdisp/all");
    }
}