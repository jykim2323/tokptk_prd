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
    Task<IEnumerable<Frm6900Dto.SubkDto>?> SubkSearchAsync(Frm6900Dto.ReqDto reqDtoa);
    Task<bool> TrackingAsync(string sPltNo);
    Task<bool> LstkCheckAsync(string sPltno);
    Task<bool> SubkLocaCheckAsync(string sPltno);
    Task<bool> SubkCheckAsync(string subkLoca);
    Task<int> DeleteAsync(string subkLoca);
    Task<int> LstkClearAsync(string lstkLoca);
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
    public Task<IEnumerable<Frm6900Dto.SubkDto>?> SubkSearchAsync(Frm6900Dto.ReqDto reqDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["SubkPltno"] = reqDto.SubkPltno,
            ["SubkLoca"] = reqDto.SubkLoca,
        };

        var url = QueryHelpers.AddQueryString(
            "api/inventory/frm6900/subksearch",
            query);

        return http.GetFromJsonAsync<IEnumerable<Frm6900Dto.SubkDto>?>(url);
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
    public async Task<bool> SubkCheckAsync(string subkLoca)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inventory/frm6900/subkcheck?subkLoca={Uri.EscapeDataString(subkLoca ?? "")}");

        if (!response)
        {
            return false;
        }

        return true;
    }
    public Task<int> DeleteAsync(string subkLoca)
    {
        string qs =
            $"SubkLoca={Uri.EscapeDataString(subkLoca ?? "")}";

        return http.GetFromJsonAsync<int>($"api/inventory/frm6900/delete?{qs}");
    }
    public Task<int> LstkClearAsync(string lstkLoca)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(lstkLoca ?? "")}";

        return http.GetFromJsonAsync<int>($"api/inventory/frm6900/lstkclear?{qs}");
    }
}
