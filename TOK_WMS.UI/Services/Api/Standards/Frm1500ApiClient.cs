using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.UI.Services.Api.Standards;

public interface IFrm1500Api
{
    Task<IEnumerable<Frm1500Dto.Gubn1Dto>?> Gubn1SearchAsync();

    Task<IEnumerable<Frm1500Dto.Gubn2Dto>?> Gubn2SearchAsync();

    Task<IEnumerable<Frm1500Dto.Gubn3Dto>?> Gubn3SearchAsync();


    Task<int> InsertGubn1Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> UpdateGubn1Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> DeleteGubn1Async(
        Frm1500Dto.DeleteReqDto reqDto);


    Task<int> InsertGubn2Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> UpdateGubn2Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> DeleteGubn2Async(
        Frm1500Dto.DeleteReqDto reqDto);


    Task<int> InsertGubn3Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> UpdateGubn3Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> DeleteGubn3Async(
        Frm1500Dto.DeleteReqDto reqDto);
}


public class Frm1500ApiClient(
    HttpClient http)
    : IFrm1500Api
{
    // =========================================================
    // 조회
    // =========================================================

    public Task<IEnumerable<Frm1500Dto.Gubn1Dto>?> Gubn1SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm1500Dto.Gubn1Dto>>(
            "api/standards/frm1500/gubn1");
    }


    public Task<IEnumerable<Frm1500Dto.Gubn2Dto>?> Gubn2SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm1500Dto.Gubn2Dto>>(
            "api/standards/frm1500/gubn2");
    }


    public Task<IEnumerable<Frm1500Dto.Gubn3Dto>?> Gubn3SearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm1500Dto.Gubn3Dto>>(
            "api/standards/frm1500/gubn3");
    }


    // =========================================================
    // 구분#1 등록
    // =========================================================

    public async Task<int> InsertGubn1Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/standards/frm1500/gubn1",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // 구분#1 수정
    // =========================================================

    public async Task<int> UpdateGubn1Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PutAsJsonAsync(
                "api/standards/frm1500/gubn1",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // 구분#1 삭제
    // =========================================================

    public async Task<int> DeleteGubn1Async(
        Frm1500Dto.DeleteReqDto reqDto)
    {
        return await DeleteAsync(
            "api/standards/frm1500/gubn1",
            reqDto);
    }


    // =========================================================
    // 구분#2 등록
    // =========================================================

    public async Task<int> InsertGubn2Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/standards/frm1500/gubn2",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // 구분#2 수정
    // =========================================================

    public async Task<int> UpdateGubn2Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PutAsJsonAsync(
                "api/standards/frm1500/gubn2",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // 구분#2 삭제
    // =========================================================

    public async Task<int> DeleteGubn2Async(
        Frm1500Dto.DeleteReqDto reqDto)
    {
        return await DeleteAsync(
            "api/standards/frm1500/gubn2",
            reqDto);
    }


    // =========================================================
    // 구분#3 등록
    // =========================================================

    public async Task<int> InsertGubn3Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/standards/frm1500/gubn3",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // 구분#3 수정
    // =========================================================

    public async Task<int> UpdateGubn3Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PutAsJsonAsync(
                "api/standards/frm1500/gubn3",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // 구분#3 삭제
    // =========================================================

    public async Task<int> DeleteGubn3Async(
        Frm1500Dto.DeleteReqDto reqDto)
    {
        return await DeleteAsync(
            "api/standards/frm1500/gubn3",
            reqDto);
    }


    // =========================================================
    // DELETE 공통
    // =========================================================

    private async Task<int> DeleteAsync(
        string url,
        Frm1500Dto.DeleteReqDto reqDto)
    {
        using var request =
            new HttpRequestMessage(
                HttpMethod.Delete,
                url)
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