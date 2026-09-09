using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.UI.Services.Api.Outbounds;

public interface IFrm4101Api
{
    Task<Frm4101Dto.SaveResultDto?> SaveAsync(
        Frm4101Dto.SaveReqDto reqDto);
}

public class Frm4101ApiClient(
    HttpClient http) : IFrm4101Api
{
    public async Task<Frm4101Dto.SaveResultDto?> SaveAsync(
        Frm4101Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/outbounds/frm4101/save",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<
                Frm4101Dto.SaveResultDto>();
    }
}