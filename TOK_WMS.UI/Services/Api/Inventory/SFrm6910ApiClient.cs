using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Inventory;
using static TOK.WMS.Core.DTOs.Inventory.SFrm6110Dto;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface ISFrm6910Api
{
    Task<IEnumerable<SFrm6910Dto.ResDto>?> SearchAsync(string pltNo);

    Task<bool> SaveAsync(SFrm6910Dto.SaveReqDto reqDto);
}

public class SFrm6910ApiClient(HttpClient http) : ISFrm6910Api
{

    public Task<IEnumerable<SFrm6910Dto.ResDto>?> SearchAsync(
        string pltNo)
    {
        var url =
            $"api/inventory/sfrm6910/search" +
            $"?pltNo={Uri.EscapeDataString(pltNo)}";

        return http.GetFromJsonAsync<IEnumerable<SFrm6910Dto.ResDto>>(url);
    }

    public async Task<bool> SaveAsync(
        SFrm6910Dto.SaveReqDto reqDto)
    {
        var response = await http.PutAsJsonAsync(
            "api/inventory/sfrm6910/save",
            reqDto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
}
