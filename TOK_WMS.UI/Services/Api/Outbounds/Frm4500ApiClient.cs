using Microsoft.AspNetCore.WebUtilities;
using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.UI.Services.Api.Outbounds;

public interface IFrm4500Api
{
    Task<IEnumerable<Frm4500Dto.ItemSummaryDto>?> SearchAsync(
        Frm4500Dto.ReqDto reqDto);


    Task<IEnumerable<Frm4500Dto.LotSummaryDto>?> LotSearchAsync(
        Frm4500Dto.LotReqDto reqDto);
}


public class Frm4500ApiClient(
    HttpClient http)
    : IFrm4500Api
{
    // =========================================================
    // 품목별
    // =========================================================

    public Task<IEnumerable<Frm4500Dto.ItemSummaryDto>?> SearchAsync(
        Frm4500Dto.ReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["FromDate"] =
                    reqDto.FromDate,

                ["ToDate"] =
                    reqDto.ToDate
            };


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


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4500/search",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4500Dto.ItemSummaryDto>>(
            url);
    }


    // =========================================================
    // LOT별
    // =========================================================

    public Task<IEnumerable<Frm4500Dto.LotSummaryDto>?> LotSearchAsync(
        Frm4500Dto.LotReqDto reqDto)
    {
        var query =
            new Dictionary<string, string?>
            {
                ["FromDate"] =
                    reqDto.FromDate,

                ["ToDate"] =
                    reqDto.ToDate,

                ["ItemCode"] =
                    reqDto.ItemCode
            };


        var url =
            QueryHelpers.AddQueryString(
                "api/outbounds/frm4500/lotsearch",
                query);


        return http.GetFromJsonAsync<
            IEnumerable<Frm4500Dto.LotSummaryDto>>(
            url);
    }
}