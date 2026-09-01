using DocumentFormat.OpenXml.EMMA;
using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface IFrm6200Api
{
    Task<IEnumerable<Frm6200Dto.ResDto>?> SearchAsync(Frm6200Dto.SearchReqDto searchDto);
    Task<bool> ProhibitionAsync(Frm6200Dto.ProhibitionReqDto reqDto);
}

public class Frm6200ApiClient(HttpClient http) : IFrm6200Api
{
   public Task<IEnumerable<Frm6200Dto.ResDto>?> SearchAsync(Frm6200Dto.SearchReqDto searchDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["FromDate"] = searchDto.FromDate,
            ["ToDate"] = searchDto.ToDate,
            ["SearchType"] = searchDto.SearchType,
            ["SearchText"] = searchDto.SearchText,
            ["DangerousType"] = searchDto.DangerousType,
            ["PetroleumType"] = searchDto.PetroleumType,
            ["SolubilityType"] = searchDto.SolubilityType
        };

        var url = QueryHelpers.AddQueryString(
            "api/inventory/frm6200/search",
            query);

        return http.GetFromJsonAsync<IEnumerable<Frm6200Dto.ResDto>?>(url);
    }

    public async Task<bool> ProhibitionAsync(Frm6200Dto.ProhibitionReqDto reqDto)
    {
        var response = await http.PutAsJsonAsync(
       "api/inventory/frm6200/prohibition",
       reqDto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
}
