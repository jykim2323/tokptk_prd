using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.UI.Services.Api.Standards;

public interface ISFrm1100Api
{
    Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn1SearchAsync();

    Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn2SearchAsync();

    Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn3SearchAsync();


    Task<int> InsertAsync(
        SFrm1100Dto.ReqDto reqDto);


    Task<int> UpdateAsync(
        SFrm1100Dto.ReqDto reqDto);


    Task<int> DeleteAsync(
        SFrm1100Dto.DeleteReqDto reqDto);
}


public class SFrm1100ApiClient(
    HttpClient http)
    : ISFrm1100Api
{
    public Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn1SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<SFrm1100Dto.GubnDto>>(
            "api/standards/sfrm1100/gubn1");
    }


    public Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn2SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<SFrm1100Dto.GubnDto>>(
            "api/standards/sfrm1100/gubn2");
    }


    public Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn3SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<SFrm1100Dto.GubnDto>>(
            "api/standards/sfrm1100/gubn3");
    }


    public async Task<int> InsertAsync(
        SFrm1100Dto.ReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/standards/sfrm1100/insert",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    public async Task<int> UpdateAsync(
        SFrm1100Dto.ReqDto reqDto)
    {
        var response =
            await http.PutAsJsonAsync(
                "api/standards/sfrm1100/update",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    public async Task<int> DeleteAsync(
        SFrm1100Dto.DeleteReqDto reqDto)
    {
        using var request =
            new HttpRequestMessage(
                HttpMethod.Delete,
                "api/standards/sfrm1100/delete")
            {
                Content =
                    JsonContent.Create(
                        reqDto)
            };


        var response =
            await http.SendAsync(
                request);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }
}