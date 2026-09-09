using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.UI.Services.Api.Outbounds;

public interface IFrm4400Api
{
    Task<IEnumerable<Frm4400Dto.ResDto>?> SearchAsync(
        Frm4400Dto.ReqDto reqDto);


    Task<IEnumerable<Frm4400Dto.CustomerDto>?> CustomerSearchAsync();


    Task<int> DeleteAsync(
        Frm4400Dto.DeleteReqDto reqDto);
}


public class Frm4400ApiClient(
    HttpClient http)
    : IFrm4400Api
{
    // =========================================================
    // 조회
    // =========================================================

    public Task<IEnumerable<Frm4400Dto.ResDto>?> SearchAsync(
        Frm4400Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["FromDate"] =
                    reqDto.FromDate,

                ["ToDate"] =
                    reqDto.ToDate,

                ["SearchType"] =
                    reqDto.SearchType
            };


        if (!string.IsNullOrWhiteSpace(
            reqDto.SearchText))
        {
            query["SearchText"] =
                reqDto.SearchText;
        }


        if (!string.IsNullOrWhiteSpace(
            reqDto.Customer))
        {
            query["Customer"] =
                reqDto.Customer;
        }


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4400/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4400Dto.ResDto>>(
            url);
    }


    // =========================================================
    // 납품처
    // =========================================================

    public Task<IEnumerable<Frm4400Dto.CustomerDto>?> CustomerSearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm4400Dto.CustomerDto>>(
            "api/outbounds/frm4400/customers");
    }


    // =========================================================
    // 삭제
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm4400Dto.DeleteReqDto reqDto)
    {
        using var request =
            new HttpRequestMessage(
                HttpMethod.Delete,
                "api/outbounds/frm4400/delete")
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
}