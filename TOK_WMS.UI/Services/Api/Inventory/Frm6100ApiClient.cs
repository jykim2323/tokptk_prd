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
}
