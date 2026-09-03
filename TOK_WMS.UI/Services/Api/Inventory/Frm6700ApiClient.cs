using Microsoft.AspNetCore.WebUtilities;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface IFrm6700Api
{
    Task<IEnumerable<Frm6700Dto.ResDto>?> SearchAsync(Frm6700Dto.ReqDto searchDto);
}

public class Frm6700ApiClient(HttpClient http) : IFrm6700Api
{
    public Task<IEnumerable<Frm6700Dto.ResDto>?> SearchAsync(Frm6700Dto.ReqDto searchDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["JegoDate"] = searchDto.JegoDate,
            ["JegoCode"] = searchDto.JegoCode,
            ["MastName"] = searchDto.MastName,
            ["DangerousType"] = searchDto.DangerousType,
            ["PetroleumType"] = searchDto.PetroleumType,
            ["SolubilityType"] = searchDto.SolubilityType,
            ["StokWhM"] = searchDto.StokWhM.ToString(),
            ["StokWhS"] = searchDto.StokWhS.ToString(),
            ["StokWhW"] = searchDto.StokWhW.ToString(),
        };

        var url = QueryHelpers.AddQueryString(
            "api/inventory/frm6700/search",
            query);

        return http.GetFromJsonAsync<IEnumerable<Frm6700Dto.ResDto>?>(url);
    }

}

