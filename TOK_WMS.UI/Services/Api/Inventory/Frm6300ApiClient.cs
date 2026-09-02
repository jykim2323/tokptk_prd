using DocumentFormat.OpenXml.EMMA;
using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface IFrm6300Api
{
    Task<IEnumerable<Frm6300Dto.ResDto>?> SearchAsync(Frm6300Dto.ReqDto searchDto);
    Task<IEnumerable<Frm6300Dto.LotnoResDto>?> LotnoSearchAsync(Frm6300Dto.ReqDto searchDto);
}

public class Frm6300ApiClient(HttpClient http) : IFrm6300Api
{
    public Task<IEnumerable<Frm6300Dto.ResDto>?> SearchAsync(Frm6300Dto.ReqDto searchDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["SubkCode"] = searchDto.SubkCode,
            ["DangerousType"] = searchDto.DangerousType,
            ["PetroleumType"] = searchDto.PetroleumType,
            ["SolubilityType"] = searchDto.SolubilityType
        };

        var url = QueryHelpers.AddQueryString(
            "api/inventory/frm6300/search",
            query);

        return http.GetFromJsonAsync<IEnumerable<Frm6300Dto.ResDto>?>(url);
    }
    public Task<IEnumerable<Frm6300Dto.LotnoResDto>?> LotnoSearchAsync(Frm6300Dto.ReqDto searchDto)
    {
        string qs = $"SubkCode={Uri.EscapeDataString(searchDto.SubkCode ?? "")}";

        return http.GetFromJsonAsync<IEnumerable<Frm6300Dto.LotnoResDto>?>($"api/inventory/frm6300/lotnosearch?{qs}");
    }
}
