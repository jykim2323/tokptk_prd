using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.UI.Services.Api.Outbounds;

public interface IFrm4103Api
{
    Task<IEnumerable<Frm4103Dto.ChasuDto>?> SearchChasuAsync(
        string outDate);

    Task<IEnumerable<Frm4103Dto.SummaryDto>?> SearchSummaryAsync(
        Frm4103Dto.ReqDto reqDto);

    Task<IEnumerable<Frm4103Dto.ScheduleDto>?> SearchSchedulesAsync();

    Task<int> DeleteAsync(
        Frm4103Dto.DeleteReqDto reqDto);

    Task<Frm4103Dto.ConfirmResultDto?> ConfirmAsync(
        Frm4103Dto.ConfirmReqDto reqDto);
}


public class Frm4103ApiClient(
    HttpClient http)
    : IFrm4103Api
{
    // =========================================================
    // 차수 조회
    // =========================================================

    public Task<IEnumerable<Frm4103Dto.ChasuDto>?> SearchChasuAsync(
        string outDate)
    {
        var query =
            new Dictionary<string, string>();


        if (!string.IsNullOrWhiteSpace(outDate))
        {
            query["outDate"] =
                outDate;
        }


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4103/chasu",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4103Dto.ChasuDto>>(
            url);
    }


    // =========================================================
    // 상단 피킹리스트 현황
    //
    // Chasu == null 이면 QueryString에서 제외
    // =========================================================

    public Task<IEnumerable<Frm4103Dto.SummaryDto>?> SearchSummaryAsync(
        Frm4103Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string>();


        if (!string.IsNullOrWhiteSpace(
            reqDto.OutDate))
        {
            query["OutDate"] =
                reqDto.OutDate;
        }


        if (!string.IsNullOrWhiteSpace(
            reqDto.Chasu))
        {
            query["Chasu"] =
                reqDto.Chasu;
        }


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4103/summary",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4103Dto.SummaryDto>>(
            url);
    }


    // =========================================================
    // 출고 대기 현황
    // =========================================================

    public Task<IEnumerable<Frm4103Dto.ScheduleDto>?> SearchSchedulesAsync()
    {
        return http.GetFromJsonAsync<
            IEnumerable<Frm4103Dto.ScheduleDto>>(
            "api/outbounds/frm4103/schedules");
    }


    // =========================================================
    // 선택 출고지시 삭제
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm4103Dto.DeleteReqDto reqDto)
    {
        using var request =
            new HttpRequestMessage(
                HttpMethod.Delete,
                "api/outbounds/frm4103/delete")
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


    // =========================================================
    // 출고지시 확정
    // =========================================================

    public async Task<Frm4103Dto.ConfirmResultDto?> ConfirmAsync(
        Frm4103Dto.ConfirmReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/outbounds/frm4103/confirm",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<
                Frm4103Dto.ConfirmResultDto>();
    }
}