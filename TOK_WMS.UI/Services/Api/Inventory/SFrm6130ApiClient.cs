using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using static TOK.WMS.Core.DTOs.Inventory.SFrm6110Dto;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface ISFrm6130Api
{
    Task<bool> ConfirmedAsync(SFrm6130Dto.ReqDto reqdto);
    Task<bool> SubkCheckAsync(SFrm6130Dto.ReqDto reqdto);
    Task<int> SubkInsertAsync(SFrm6130Dto.ReqDto reqdto);
    Task<bool> SubkUpdateAsync(SFrm6130Dto.ReqDto reqdto);
}

public class SFrm6130ApiClient(HttpClient http) : ISFrm6130Api
{
    public async Task<bool> ConfirmedAsync(SFrm6130Dto.ReqDto reqdto)
    {
        var response = await http.PutAsJsonAsync(
        "api/inventory/sfrm6130/confirmed",
        reqdto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }

    public async Task<bool> SubkCheckAsync(SFrm6130Dto.ReqDto reqdto)
    {
        var query = new Dictionary<string, string?>
        {
            ["SubkPltno"] = reqdto.SubkPltno,
            ["SubkCode"] = reqdto.SubkCode,
            ["SubkLotno"] = reqdto.SubkLotno ?? string.Empty,
        };

        var url = QueryHelpers.AddQueryString(
            "api/inventory/sfrm6130/subkcheck",
            query);

        return await http.GetFromJsonAsync<bool>(url);
    }

    public async Task<int> SubkInsertAsync(SFrm6130Dto.ReqDto reqdto)
    {
        var response = await http.PostAsJsonAsync(
        "api/inventory/sfrm6130/subkinsert",
        reqdto);

        return await response.Content.ReadFromJsonAsync<int>();
    }
    public async Task<bool> SubkUpdateAsync(SFrm6130Dto.ReqDto reqdto)
    {
        var response = await http.PutAsJsonAsync(
        "api/inventory/sfrm6130/subkupdate",
        reqdto);
        return await response.Content.ReadFromJsonAsync<bool>();
    }
}
