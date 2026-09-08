using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;

namespace TOK.WMS.UI.Services.Api.Inbounds;

public interface IFrm3130Api
{
    Task<IEnumerable<Frm3130Dto.ResDto>?> SearchAsync(
        Frm3130Dto.ReqDto reqDto);

    Task<Frm3130Dto.PltCheckDto?> PltCheckAsync(
        string pltNo);

    Task<Frm3130Dto.InsertResultDto?> InsertAsync(
        Frm3130Dto.InsertReqDto reqDto);

    Task<Frm3130Dto.EmptyResultDto?> EmptyInsertAsync(
        string pltNo,
        string userId);

    Task<int> DeleteAsync(
        Frm3130Dto.DeleteReqDto reqDto);

    Task<int> DeleteAllAsync(
        string pltNo);
}

public class Frm3130ApiClient(
    HttpClient http) : IFrm3130Api
{
    public Task<IEnumerable<Frm3130Dto.ResDto>?> SearchAsync(
        Frm3130Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["SubkPltno"] =
                    reqDto.SubkPltno
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/inbounds/frm3130/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm3130Dto.ResDto>?>(
            url);
    }


    public Task<Frm3130Dto.PltCheckDto?> PltCheckAsync(
        string pltNo)
    {
        return http.GetFromJsonAsync<
            Frm3130Dto.PltCheckDto?>(
            $"api/inbounds/frm3130/pltcheck" +
            $"?pltNo={Uri.EscapeDataString(pltNo ?? "")}");
    }


    public async Task<Frm3130Dto.InsertResultDto?> InsertAsync(
        Frm3130Dto.InsertReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/inbounds/frm3130/insert",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<
                Frm3130Dto.InsertResultDto>();
    }


    public async Task<Frm3130Dto.EmptyResultDto?> EmptyInsertAsync(
        string pltNo,
        string userId)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["pltNo"] = pltNo,
                ["userId"] = userId
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/inbounds/frm3130/empty",
                query);


        var response =
            await http.PostAsync(
                url,
                null);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<
                Frm3130Dto.EmptyResultDto>();
    }


    public async Task<int> DeleteAsync(
        Frm3130Dto.DeleteReqDto reqDto)
    {
        using var request =
            new HttpRequestMessage(
                HttpMethod.Delete,
                "api/inbounds/frm3130/delete")
            {
                Content =
                    JsonContent.Create(reqDto)
            };


        var response =
            await http.SendAsync(request);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    public Task<int> DeleteAllAsync(
        string pltNo)
    {
        return DeleteAllCoreAsync(pltNo);
    }


    private async Task<int> DeleteAllCoreAsync(
        string pltNo)
    {
        var url =
            $"api/inbounds/frm3130/deleteall" +
            $"?pltNo={Uri.EscapeDataString(pltNo ?? "")}";


        var response =
            await http.DeleteAsync(url);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }
}