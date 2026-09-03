using DocumentFormat.OpenXml.EMMA;
using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.UI.Services.Api.Inbounds;
using static TOK.WMS.Core.DTOs.Inventory.Frm6100Dto;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface IFrm6900Api
{
    Task<IEnumerable<Frm6900Dto.ResDto>?> SearchAsync(Frm6900Dto.ReqDto reqDto);
    Task<IEnumerable<Frm6900Dto.SubkDto>?> SubkSearchAsync(string lstkLoca);
    Task<bool> TrackingAsync(string sPltNo);
    Task<bool> LstkCheckAsync(string sPltno);
    Task<bool> SubkLocaCheckAsync(string sPltno);
}
public class Frm6900ApiClient(HttpClient http) : IFrm6900Api
{
    public Task<IEnumerable<Frm6900Dto.ResDto>?> SearchAsync(Frm6900Dto.ReqDto reqDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["SubkPltno"] = reqDto.SubkPltno,
            ["SubkLoca"] = reqDto.SubkLoca,
        };

        var url = QueryHelpers.AddQueryString(
            "api/inventory/frm6900/search",
            query);

        return http.GetFromJsonAsync<IEnumerable<Frm6900Dto.ResDto>?>(url);
    }
    public Task<IEnumerable<Frm6900Dto.SubkDto>?> SubkSearchAsync(string lstkLoca)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(lstkLoca ?? "")}";

        return http.GetFromJsonAsync<IEnumerable<Frm6900Dto.SubkDto>?>($"api/inventory/frm6900/subksearch?{qs}");
    }
    public async Task<bool> TrackingAsync(string sPltNo)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inventory/frm6900/track?sPltNo={Uri.EscapeDataString(sPltNo)}");

        if (!response)
        {
            return false;
        }

        return true;
    }

    public async Task<bool> LstkCheckAsync(string sPltno)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inventory/frm6900/lstkcheck?sPltno={Uri.EscapeDataString(sPltno ?? "")}");

        if (!response)
        {
            return false;
        }

        return true;
    }
    public async Task<bool> SubkLocaCheckAsync(string sPltno)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inventory/frm6900/subklocacheck?sPltno={Uri.EscapeDataString(sPltno ?? "")}");

        if (!response)
        {
            return false;
        }

        return true;
    }
}
