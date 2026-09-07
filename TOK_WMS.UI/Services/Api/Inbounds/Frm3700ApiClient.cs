using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;

namespace TOK.WMS.UI.Services.Api.Inbounds;

public interface IFrm3700Api
{
    Task<IEnumerable<Frm3700Dto.ResDto>?> SearchAsync(
        Frm3700Dto.ReqDto reqDto);

    Task<IEnumerable<Frm3700Dto.LotResDto>?> LotSearchAsync(
        Frm3700Dto.LotReqDto reqDto);
}

public class Frm3700ApiClient(HttpClient http) : IFrm3700Api
{
    public async Task<IEnumerable<Frm3700Dto.ResDto>?> SearchAsync(
        Frm3700Dto.ReqDto reqDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["FromDate"] = reqDto.FromDate,
            ["ToDate"] = reqDto.ToDate,
            ["ItemCode"] = reqDto.ItemCode,
            ["ItemName"] = reqDto.ItemName
        };


        var url = QueryHelpers.AddQueryString(
            "api/inbounds/frm3700/search",
            query);


        return await http.GetFromJsonAsync<
            IEnumerable<Frm3700Dto.ResDto>>(url);
    }


    public async Task<IEnumerable<Frm3700Dto.LotResDto>?> LotSearchAsync(
        Frm3700Dto.LotReqDto reqDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["FromDate"] = reqDto.FromDate,
            ["ToDate"] = reqDto.ToDate,
            ["StkCode"] = reqDto.StkCode
        };


        var url = QueryHelpers.AddQueryString(
            "api/inbounds/frm3700/lot-search",
            query);


        return await http.GetFromJsonAsync<
            IEnumerable<Frm3700Dto.LotResDto>>(url);
    }
}



