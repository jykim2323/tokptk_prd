using DocumentFormat.OpenXml.EMMA;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.UI.Services.Api.Inbounds;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface IFrm6100Api
{
    Task<IEnumerable<Frm6100Dto.ResDto>?> SearchAsync(Frm6100Dto reqDto);
    Task<IEnumerable<Frm6100Dto.SubkDto>?> SubkSearchAsync(string lstkLoca);
    Task<bool> SubkCheckAsync(string lstkLoca);
    Task<int> DeleteAsync(string subkLoca);
    Task<int> LstkClearAsync(string lstkLoca);
    Task<string?> LstkpltnocheckAsync(string lstkLoca);
    Task<bool> SubklocacheckAsync(string lstkPltno);
    Task<bool> CancelSubkAsync(string lstkPltno);
    Task<bool> CancelLstkAsync(string lstkPltno);
}
public class Frm6100ApiClient(HttpClient http) : IFrm6100Api
{
    public Task<IEnumerable<Frm6100Dto.ResDto>?> SearchAsync(Frm6100Dto reqDto)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(reqDto.LstkLoca ?? "")}";

        return http.GetFromJsonAsync<IEnumerable<Frm6100Dto.ResDto>?>($"api/inventory/frm6100/search?{qs}");
    }
    public Task<IEnumerable<Frm6100Dto.SubkDto>?> SubkSearchAsync(string lstkLoca)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(lstkLoca ?? "")}";

        return http.GetFromJsonAsync<IEnumerable<Frm6100Dto.SubkDto>?>($"api/inventory/frm6100/subksearch?{qs}");
    }
    public Task<bool> SubkCheckAsync(string lstkLoca)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(lstkLoca ?? "")}";

        return http.GetFromJsonAsync<bool>($"api/inventory/frm6100/subkcheck?{qs}");
    }

    public Task<int> DeleteAsync(string subkLoca)
    {
        string qs =
            $"SubkLoca={Uri.EscapeDataString(subkLoca ?? "")}";

        return http.GetFromJsonAsync<int>($"api/inventory/frm6100/delete?{qs}");
    }
    public Task<int> LstkClearAsync(string lstkLoca)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(lstkLoca ?? "")}";

        return http.GetFromJsonAsync<int>($"api/inventory/frm6100/lstkclear?{qs}");
    }

    public Task<bool> LstkCheckAsync(string lstkLoca)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(lstkLoca ?? "")}";

        return http.GetFromJsonAsync<bool>($"api/inventory/frm6100/lstkcheck?{qs}");
    }
    public async Task<string?> LstkpltnocheckAsync(string lstkLoca)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(lstkLoca ?? "")}";

        var response = await http.GetAsync(
            $"api/inventory/frm6100/lstkpltnocheck?{qs}");

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadAsStringAsync();
    }

    public Task<bool> SubklocacheckAsync(string lstkPltno)
    {
        string qs =
            $"LstkPltno={Uri.EscapeDataString(lstkPltno ?? "")}";

        return http.GetFromJsonAsync<bool>($"api/inventory/frm6100/subklocacheck?{qs}");
    }

    public async Task<bool> CancelSubkAsync(string subkPltno)
    {
        var response = await http.PutAsJsonAsync("api/inventory/frm6100/cancelsubk",subkPltno);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
    public async Task<bool> CancelLstkAsync(string subkPltno)
    {
        var response = await http.PutAsJsonAsync("api/inventory/frm6100/cancellstk", subkPltno);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
}
