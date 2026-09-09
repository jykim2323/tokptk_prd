using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.UI.Services.Api.Outbounds;

public interface IFrm4300Api
{
    Task<IEnumerable<Frm4300Dto.ResDto>?> SearchAsync(
        Frm4300Dto.ReqDto reqDto);


    Task<int> DeleteAsync(
        Frm4300Dto.DeleteReqDto reqDto);


    Task<int> PendingCountAsync(
        string pltNo);


    Task<Frm4300Dto.CompleteResultDto?> CompleteAsync(
        Frm4300Dto.CompleteReqDto reqDto);
}


public class Frm4300ApiClient(
    HttpClient http)
    : IFrm4300Api
{
    // =========================================================
    // 조회
    // =========================================================

    public Task<IEnumerable<Frm4300Dto.ResDto>?> SearchAsync(
        Frm4300Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>();


        if (!string.IsNullOrWhiteSpace(
            reqDto.SearchType))
        {
            query["SearchType"] =
                reqDto.SearchType;
        }


        if (!string.IsNullOrWhiteSpace(
            reqDto.SearchText))
        {
            query["SearchText"] =
                reqDto.SearchText;
        }


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4300/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4300Dto.ResDto>>(
            url);
    }


    // =========================================================
    // 삭제
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm4300Dto.DeleteReqDto reqDto)
    {
        using var request =
            new HttpRequestMessage(
                HttpMethod.Delete,
                "api/outbounds/frm4300/delete")
            {
                Content =
                    JsonContent.Create(
                        reqDto)
            };


        var response =
            await http.SendAsync(
                request);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // PLT 미출고 건수
    // =========================================================

    public async Task<int> PendingCountAsync(
        string pltNo)
    {
        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4300/pending-count",
                new Dictionary<string, string?>
                {
                    ["pltNo"] =
                        pltNo
                });


        return await http.GetFromJsonAsync<int>(
            url);
    }


    // =========================================================
    // 수동출고 완료
    // =========================================================

    public async Task<Frm4300Dto.CompleteResultDto?> CompleteAsync(
        Frm4300Dto.CompleteReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/outbounds/frm4300/complete",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<
                Frm4300Dto.CompleteResultDto>();
    }
}