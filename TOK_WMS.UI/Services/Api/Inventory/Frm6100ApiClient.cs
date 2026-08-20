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

}
public class Frm6100ApiClient(HttpClient http) : IFrm6100Api
{
    public Task<IEnumerable<Frm6100Dto.ResDto>?> SearchAsync(Frm6100Dto reqDto)
    {
        string qs =
            $"LstkLoca={Uri.EscapeDataString(reqDto.LstkLoca ?? "")}";

        return http.GetFromJsonAsync<IEnumerable<Frm6100Dto.ResDto>?>($"api/inventory/frm6100/search?{qs}");
    }
}
