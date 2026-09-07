using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;

namespace TOK.WMS.UI.Services.Api.Inbounds;

public interface IFrm3300Api
{
    Task<IEnumerable<Frm3300Dto.ResDto>?> SearchAsync();

    Task<bool> DeleteAsync(Frm3300Dto.DeleteReqDto reqDto);

}

public class Frm3300ApiClient(HttpClient http) : IFrm3300Api
{
    public Task<IEnumerable<Frm3300Dto.ResDto>?> SearchAsync()
    {
        return http.GetFromJsonAsync<IEnumerable<Frm3300Dto.ResDto>?>(
           "api/inbounds/frm3300/search");
    }
    public async Task<bool> DeleteAsync(Frm3300Dto.DeleteReqDto reqDto)
    {
        using var request = new HttpRequestMessage(
            HttpMethod.Delete,
            "api/inbounds/frm3300/delete")
        {
            Content = JsonContent.Create(reqDto)
        };

        var response = await http.SendAsync(request);

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<bool>();
    }
}



