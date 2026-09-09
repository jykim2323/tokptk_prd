using Microsoft.AspNetCore.WebUtilities;
using System.Net;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.UI.Services.Api.Outbounds;

public interface IFrm4100Api
{
    Task<IEnumerable<Frm4100Dto.StockDto>?> SearchAsync(
        Frm4100Dto.ReqDto reqDto);


    Task<IEnumerable<Frm4100Dto.PalletItemDto>?> PalletSearchAsync(
        string loca);


    Task<Frm4100Dto.StationStatusDto?> StationStatusAsync(
        string loca);


    Task<Frm4100Dto.ReserveResultDto?> ReserveAsync(
        Frm4100Dto.ReserveReqDto reqDto);


    Task<Frm4100Dto.DirectOutputResultDto?> DirectOutputAsync(
        Frm4100Dto.DirectOutputReqDto reqDto);
}


public class Frm4100ApiClient(
    HttpClient http)
    : IFrm4100Api
{
    // =========================================================
    // 재고 조회
    // =========================================================

    public Task<IEnumerable<Frm4100Dto.StockDto>?> SearchAsync(
        Frm4100Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>();


        if (!string.IsNullOrWhiteSpace(
            reqDto.ItemCode))
        {
            query["ItemCode"] =
                reqDto.ItemCode;
        }


        if (!string.IsNullOrWhiteSpace(
            reqDto.ItemName))
        {
            query["ItemName"] =
                reqDto.ItemName;
        }


        if (!string.IsNullOrWhiteSpace(
            reqDto.LotNo))
        {
            query["LotNo"] =
                reqDto.LotNo;
        }


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4100/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4100Dto.StockDto>>(
            url);
    }


    // =========================================================
    // 팔레트 자료 조회
    // =========================================================

    public Task<IEnumerable<Frm4100Dto.PalletItemDto>?> PalletSearchAsync(
        string loca)
    {
        var query =
            new Dictionary<string, string>();


        if (!string.IsNullOrWhiteSpace(
            loca))
        {
            query["loca"] =
                loca;
        }


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4100/pallet",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4100Dto.PalletItemDto>>(
            url);
    }


    // =========================================================
    // 출고대 상태 조회
    //
    // 중요:
    // 서버가 null 반환하여 204 NoContent가 되어도
    // GetFromJsonAsync()로 바로 파싱하지 않음.
    //
    // 빈 Body JSON 파싱 오류 방지
    // =========================================================

    public async Task<Frm4100Dto.StationStatusDto?> StationStatusAsync(
        string loca)
    {
        if (string.IsNullOrWhiteSpace(
            loca))
        {
            return null;
        }


        var query =
            new Dictionary<string, string>
            {
                ["loca"] =
                    loca
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4100/station",
                query);


        var response =
            await http.GetAsync(
                url);


        // -----------------------------------------------------
        // Repository에서 null 반환
        // Controller에서 204 NoContent가 되는 경우
        // -----------------------------------------------------

        if (response.StatusCode ==
            HttpStatusCode.NoContent)
        {
            return null;
        }


        response.EnsureSuccessStatusCode();


        var content =
            await response.Content
                .ReadAsStringAsync();


        // -----------------------------------------------------
        // HTTP 200인데 Body가 빈 경우도 방어
        // -----------------------------------------------------

        if (string.IsNullOrWhiteSpace(
            content))
        {
            return null;
        }


        // -----------------------------------------------------
        // 혹시 JSON null 자체가 내려오는 경우
        // -----------------------------------------------------

        if (content.Trim().Equals(
            "null",
            StringComparison.OrdinalIgnoreCase))
        {
            return null;
        }


        return JsonSerializer.Deserialize<
            Frm4100Dto.StationStatusDto>(
            content,
            new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive =
                    true
            });
    }


    // =========================================================
    // 출고예약
    // =========================================================

    public async Task<Frm4100Dto.ReserveResultDto?> ReserveAsync(
        Frm4100Dto.ReserveReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/outbounds/frm4100/reserve",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<
                Frm4100Dto.ReserveResultDto>();
    }


    // =========================================================
    // 바로출고
    // =========================================================

    public async Task<Frm4100Dto.DirectOutputResultDto?> DirectOutputAsync(
        Frm4100Dto.DirectOutputReqDto reqDto)
    {
        var response =
            await http.PostAsJsonAsync(
                "api/outbounds/frm4100/direct",
                reqDto);


        response.EnsureSuccessStatusCode();


        return await response.Content
            .ReadFromJsonAsync<
                Frm4100Dto.DirectOutputResultDto>();
    }
}