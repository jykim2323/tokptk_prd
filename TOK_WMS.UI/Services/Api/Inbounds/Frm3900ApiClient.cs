using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Inbounds;

namespace TOK.WMS.UI.Services.Api.Inbounds;

public interface IFrm3900Api
{
    Task<IEnumerable<Frm3900Dto.ResDto>?> SearchAsync(
        Frm3900Dto.ReqDto reqDto);

    Task<IEnumerable<Frm3900Dto.WorkDto>?> FloorStockSearchAsync(
        string pltNo);

    Task<Frm3900Dto.ItemDto?> ItemCheckAsync(
        string itemCode);

    Task<Frm3900Dto.PltCheckDto?> PltCheckAsync(
        string pltNo);

    Task<int> SaveAsync(
        Frm3900Dto.SaveReqDto reqDto);
}

public class Frm3900ApiClient(HttpClient http) : IFrm3900Api
{
    public Task<IEnumerable<Frm3900Dto.ResDto>?> SearchAsync(
        Frm3900Dto.ReqDto reqDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["FromDate"] = reqDto.FromDate,
            ["ToDate"] = reqDto.ToDate,
            ["SearchType"] = reqDto.SearchType,
            ["SearchText"] = reqDto.SearchText,
            ["Hogi"] = reqDto.Hogi
        };

        var url = QueryHelpers.AddQueryString(
            "api/inbounds/frm3900/search",
            query);

        return http.GetFromJsonAsync<
            IEnumerable<Frm3900Dto.ResDto>?>(url);
    }


    public Task<IEnumerable<Frm3900Dto.WorkDto>?> FloorStockSearchAsync(
        string pltNo)
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm3900Dto.WorkDto>?>(
            $"api/inbounds/frm3900/floorstock?pltNo={Uri.EscapeDataString(pltNo ?? "")}");
    }


    public Task<Frm3900Dto.ItemDto?> ItemCheckAsync(
        string itemCode)
    {
        return http.GetFromJsonAsync<
            Frm3900Dto.ItemDto?>(
            $"api/inbounds/frm3900/itemcheck?itemCode={Uri.EscapeDataString(itemCode ?? "")}");
    }


    public Task<Frm3900Dto.PltCheckDto?> PltCheckAsync(
        string pltNo)
    {
        return http.GetFromJsonAsync<
            Frm3900Dto.PltCheckDto?>(
            $"api/inbounds/frm3900/pltcheck?pltNo={Uri.EscapeDataString(pltNo ?? "")}");
    }


    public async Task<int> SaveAsync(
        Frm3900Dto.SaveReqDto reqDto)
    {
        var response = await http.PostAsJsonAsync(
            "api/inbounds/frm3900/save",
            reqDto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<int>();
    }
}