using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;

namespace TOK.WMS.UI.Services.Api.Inbounds;

public interface IFrm3100Api
{
    Task<IEnumerable<Frm3100Dto>?> SearchAsync(Frm3100Dto model);
    Task AddAsync(Frm3100Dto model, IReadOnlyCollection<Frm3100Dto.resDto> items);
    Task<bool> TrackingAsync(string sPltNo);
    Task<bool> TrakAsync(string sPltNo);
    Task<bool> LstkAsync(string sPltNo);
    Task<bool> SubkAsync(string sPltNo);
    Task<bool> Subk_delAsync(string sPltNo, string? sSubkcode = null, string? sSubklotno = null);
    Task<int> Subk_InsertAsync(Frm3100Dto.resDto resDto);
    Task<IEnumerable<Frm3100Dto.resDto>?> SpeedAsync(string sPltNo);

}

public class Frm3100ApiClient(HttpClient http) : IFrm3100Api
{
    public async Task AddAsync(Frm3100Dto model, IReadOnlyCollection<Frm3100Dto.resDto> items)
    {
        var request = new
        {
            Model = model,
            Items= items
        };

        using var response = await http.PostAsJsonAsync(
            "api/inbounds/frm3100/add",
             request);

        if (!response.IsSuccessStatusCode)
        {
            string message =
            await response.Content.ReadAsStringAsync();

            throw new InvalidOperationException(message);
        }
    }

    public Task<IEnumerable<Frm3100Dto>?> SearchAsync(Frm3100Dto model)
    {
        string qs =
            $"MastCode={Uri.EscapeDataString(model.MastCode?.ToString() ?? "")}" +
            $"&MastName={Uri.EscapeDataString(model.MastName?.ToString() ?? "")}";

        return http.GetFromJsonAsync<IEnumerable<Frm3100Dto>?>($"api/inbounds/frm3100/search?{qs}");
    }

    public async Task<bool> TrackingAsync(string sPltNo)
    {
         var response = await http.GetFromJsonAsync<bool>($"api/inbounds/frm3100/track?sPltNo={Uri.EscapeDataString(sPltNo)}");

        if (!response)
        {
            return false;
        }

        return true;
    }
    public async Task<IEnumerable<Frm3100Dto.resDto>?> SpeedAsync(string sPltNo)
    {
        return await http.GetFromJsonAsync<IEnumerable<Frm3100Dto.resDto>?>($"api/inbounds/frm3100/speed?sPltNo={Uri.EscapeDataString(sPltNo)}");
    }

    public async Task<bool> TrakAsync(string sPltNo)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inbounds/frm3100/save/trak?sPltNo={Uri.EscapeDataString(sPltNo)}");

        if (!response)
        {
            return false;
        }

        return true;
    }

    public  async Task<bool> LstkAsync(string sPltNo)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inbounds/frm3100/save/lstk?sPltNo={Uri.EscapeDataString(sPltNo)}");

        if (!response)
        {
            return false;
        }

        return true;
    }

    public async Task<bool> SubkAsync(string sPltNo)
    {
        var response = await http.GetFromJsonAsync<bool>($"api/inbounds/frm3100/save/subk?sPltNo={Uri.EscapeDataString(sPltNo)}");

        if (!response)
        {
            return false;
        }

        return true;
    }
    public async Task<bool> Subk_delAsync(string sPltNo, string? sSubkcode = null, string? sSubklotno = null)
    {
        if(string.IsNullOrEmpty(sSubkcode) && string.IsNullOrEmpty(sSubklotno))
        {
            var cnt = await http.GetFromJsonAsync<int>($"api/inbounds/frm3100/save/subk/del?sPltNo={Uri.EscapeDataString(sPltNo)}");

            if (cnt == 0)
            {
                return false;
            }
        }
        else
        {
            var cnt = await http.GetFromJsonAsync<int>($"api/inbounds/frm3100/save/subk/del?sPltNo={Uri.EscapeDataString(sPltNo)}&sSubkcode={Uri.EscapeDataString(sSubkcode ?? "")}&sSubklotno={Uri.EscapeDataString(sSubklotno ?? "")}");

            if (cnt == 0)
            {
                return false;
            }
        }
        return true;
    }

    public async Task<int> Subk_InsertAsync(Frm3100Dto.resDto resDto)
    {
        var response = await http.PostAsJsonAsync(
        "api/inbounds/frm3100/save/subk/insert",
        resDto);

        return await response.Content.ReadFromJsonAsync<int>();
    }
}
