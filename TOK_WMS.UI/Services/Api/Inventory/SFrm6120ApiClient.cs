using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface ISFrm6120Api
{
    Task<IEnumerable<Frm6100Dto.SubkDto>?> LstkpltnocheckAsync(SFrm6120Dto.ReqDto reqdto);
    Task<string?> SubklocacheckAsync(string subkpltno);
    Task<bool> LstkcheckAsync(string subkpltno);
    Task<bool> ConfirmedAsync(SFrm6120Dto.ReqDto reqdto);
    Task<IEnumerable<SFrm6120Dto.ReqDto>?> SubkSearchAsync(string lstkLoca);
    Task<bool> MilstkUpdateAsync(SFrm6120Dto.ReqDto reqdto);
    Task<bool> MisubkUpdateAsync(SFrm6120Dto.ReqDto reqdto);

}

public class SFrm6120ApiClient(HttpClient http) : ISFrm6120Api
{
    public async Task<IEnumerable<Frm6100Dto.SubkDto>?> LstkpltnocheckAsync(SFrm6120Dto.ReqDto reqdto)
    {
        var response = await http.GetFromJsonAsync<IEnumerable<Frm6100Dto.SubkDto>?>($"api/inventory/sfrm6120/lstkpltnocheck?SubkPltno={Uri.EscapeDataString(reqdto.SubkPltno ?? string.Empty)}");

        if (response == null)
        {
            return null;
        }

        return response;
    }

    public async Task<string?> SubklocacheckAsync(string subkpltno)
    {
        var response = await http.GetFromJsonAsync<string?>($"api/inventory/sfrm6120/subklocacheck?SubkPltno={Uri.EscapeDataString(subkpltno)}");

        
        return response;
    }
    public async Task<bool> LstkcheckAsync(string subkpltno)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inventory/sfrm6120/lstkcheck?SubkPltno={Uri.EscapeDataString(subkpltno)}");

        return response;
    }

    public async Task<bool> ConfirmedAsync(SFrm6120Dto.ReqDto reqdto)
    {
        var response = await http.PutAsJsonAsync(
        "api/inventory/sfrm6120/confirmed",
        reqdto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
    public Task<IEnumerable<SFrm6120Dto.ReqDto>?> SubkSearchAsync(string subkpltno)
    {
        string qs =
            $"SubkPltno={Uri.EscapeDataString(subkpltno ?? "")}";

        return http.GetFromJsonAsync<IEnumerable<SFrm6120Dto.ReqDto>?>($"api/inventory/sfrm6120/subksearch?{qs}");
    }

    public async Task<bool> MilstkUpdateAsync(SFrm6120Dto.ReqDto reqdto)
    {
        var response = await http.PutAsJsonAsync(
        "api/inventory/sfrm6120/milstkupdate",
        reqdto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }

    public async Task<bool> MisubkUpdateAsync(SFrm6120Dto.ReqDto reqdto)
    {
        var response = await http.PutAsJsonAsync(
        "api/inventory/sfrm6120/misubkupdate",
        reqdto);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
}
