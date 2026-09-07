using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;

namespace TOK.WMS.UI.Services.Api.Inbounds;

public interface IFrm3400Api
{
    Task<IEnumerable<Frm3400Dto.ResDto>?> SearchAsync(Frm3400Dto.ReqDto reqDto);

    Task<bool> DeleteAsync(Frm3400Dto.DeleteReqDto reqDto);

}

public class Frm3400ApiClient(HttpClient http) : IFrm3400Api
{
    public async Task<IEnumerable<Frm3400Dto.ResDto>?> SearchAsync(
         Frm3400Dto.ReqDto reqDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["FromDate"] = reqDto.FromDate,
            ["ToDate"] = reqDto.ToDate,
            ["RFlag"] = reqDto.RFlag,
            ["SearchType"] = reqDto.SearchType,
            ["SearchText"] = reqDto.SearchText
        };

        var url = QueryHelpers.AddQueryString(
            "api/inbounds/frm3400/search",
            query);

        var response = await http.GetAsync(url);

        response.EnsureSuccessStatusCode();

        return await response.Content
            .ReadFromJsonAsync<IEnumerable<Frm3400Dto.ResDto>>();
    }
    public async Task<bool> DeleteAsync(
         Frm3400Dto.DeleteReqDto reqDto)
    {
        using var request = new HttpRequestMessage(
            HttpMethod.Delete,
            "api/inbounds/frm3400/delete")
        {
            Content = JsonContent.Create(reqDto)
        };

        var response = await http.SendAsync(request);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
}



