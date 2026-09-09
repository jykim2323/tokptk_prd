using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.UI.Services.Api.Outbounds;

public interface IFrm4102Api
{
    Task<IEnumerable<Frm4102Dto.ResDto>?> SearchAsync(
        Frm4102Dto.ReqDto reqDto);

    Task<Frm4102Dto.ReserveResultDto?> ReserveAsync(
        Frm4102Dto.ReserveReqDto reqDto);

    Task<int> DeleteAsync(
        Frm4102Dto.DeleteReqDto reqDto);

    Task<int> DeleteAllAsync();
}

public class Frm4102ApiClient(
    HttpClient http)
    : IFrm4102Api
{
    public Task<IEnumerable<Frm4102Dto.ResDto>?> SearchAsync(
        Frm4102Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["OutDate"] =
                    reqDto.OutDate,

                ["ItemCode"] =
                    reqDto.ItemCode
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4102/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4102Dto.ResDto>>(
            url);
    }


    public async Task<Frm4102Dto.ReserveResultDto?> ReserveAsync(
        Frm4102Dto.ReserveReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/outbounds/frm4102/reserve",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<
                Frm4102Dto.ReserveResultDto>();
    }


    public async Task<int> DeleteAsync(
        Frm4102Dto.DeleteReqDto reqDto)
    {
        using var request =
            new HttpRequestMessage(
                HttpMethod.Delete,
                "api/outbounds/frm4102/delete")
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


    public async Task<int> DeleteAllAsync()
    {
        var response =
            await http.DeleteAsync(
                "api/outbounds/frm4102/deleteall");


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }
}