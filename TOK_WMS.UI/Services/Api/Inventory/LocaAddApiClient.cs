using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Inventory;
using static TOK.WMS.Core.DTOs.Inventory.SFrm6110Dto;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface ILocaAddApi
{
    Task<bool> ConfirmedAsync(LocaAddDto.ReqDto reqdto);
    Task<bool> SubkCheckAsync(LocaAddDto.ReqDto reqdto);

}

public class LocaAddApiClient(HttpClient http) : ILocaAddApi
{
    public async Task<bool> ConfirmedAsync(LocaAddDto.ReqDto reqdto)
    {
        var response = await http.PutAsJsonAsync(
        "api/inventory/locaadd/confirmed",
        reqdto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }

    public async Task<bool> SubkCheckAsync(LocaAddDto.ReqDto reqdto)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inventory/locaadd/subkcheck?{reqdto}");

        return response;

    }
}
