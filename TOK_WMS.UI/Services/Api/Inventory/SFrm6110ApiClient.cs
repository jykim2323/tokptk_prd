using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Inventory;
using static TOK.WMS.Core.DTOs.Inventory.SFrm6110Dto;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface ISFrm6110Api
{
    Task<bool> ConfirmedAsync(SFrm6110Dto.ReqDto reqdto);

}

public class SFrm6110ApiClient(HttpClient http) : ISFrm6110Api
{
    public async Task<bool> ConfirmedAsync(SFrm6110Dto.ReqDto reqdto)
    {
        var response = await http.PutAsJsonAsync(
        "api/inventory/sfrm6110/confirmed",
        reqdto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
}
