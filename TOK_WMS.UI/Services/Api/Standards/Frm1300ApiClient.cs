using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.UI.Services.Api.Standards;

public interface IFrm1300Api
{
    Task<IEnumerable<Frm1300Dto.ResDto>?> SearchAsync(
        Frm1300Dto.ReqDto reqDto);


    Task<IEnumerable<Frm1300Dto.ResDto>?> AllSearchAsync();


    Task<bool> DuplicateCheckAsync(
        Frm1300Dto.DuplicateReqDto reqDto);


    Task<int> InsertAsync(
        Frm1300Dto.SaveReqDto reqDto);


    Task<int> UpdateAsync(
        Frm1300Dto.SaveReqDto reqDto);


    Task<int> DeleteAsync(
        Frm1300Dto.DeleteReqDto reqDto);
}


public class Frm1300ApiClient(
    HttpClient http)
    : IFrm1300Api
{
    // =========================================================
    // 검색
    // =========================================================

    public Task<IEnumerable<Frm1300Dto.ResDto>?> SearchAsync(
        Frm1300Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["SearchText"] =
                    reqDto.SearchText
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/standards/frm1300/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm1300Dto.ResDto>>(
            url);
    }


    // =========================================================
    // 전체 조회
    // =========================================================

    public Task<IEnumerable<Frm1300Dto.ResDto>?> AllSearchAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm1300Dto.ResDto>>(
            "api/standards/frm1300/all");
    }


    // =========================================================
    // 중복 체크
    // =========================================================

    public async Task<bool> DuplicateCheckAsync(
        Frm1300Dto.DuplicateReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["UserId"] =
                    reqDto.UserId
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/standards/frm1300/duplicate",
                query);


        return await http.GetFromJsonAsync<bool>(
            url);
    }


    // =========================================================
    // 등록
    // =========================================================

    public async Task<int> InsertAsync(
        Frm1300Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/standards/frm1300/insert",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // 수정
    // =========================================================

    public async Task<int> UpdateAsync(
        Frm1300Dto.SaveReqDto reqDto)
    {
        var response =
            await http.PutAsJsonAsync(
                "api/standards/frm1300/update",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<int>();
    }


    // =========================================================
    // 삭제
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm1300Dto.DeleteReqDto reqDto)
    {
        using var request =
            new HttpRequestMessage(
                HttpMethod.Delete,
                "api/standards/frm1300/delete")
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