using Microsoft.AspNetCore.WebUtilities;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface IFrm6550Api
{
    Task<IEnumerable<Frm6550Dto.ResDto>?> SearchAsync(Frm6550Dto.ReqDto searchDto);
}

public class Frm6550ApiClient(HttpClient http) : IFrm6550Api
{
    public Task<IEnumerable<Frm6550Dto.ResDto>?> SearchAsync(Frm6550Dto.ReqDto searchDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["Closedate"] = searchDto.CloseDate,
            ["StokItem"] = searchDto.StokItem,
            ["MastName"] = searchDto.MastName,
            ["DangerousType"] = searchDto.DangerousType,
            ["PetroleumType"] = searchDto.PetroleumType,
            ["SolubilityType"] = searchDto.SolubilityType,
            ["StokWhM"] = searchDto.StokWhM.ToString(),
            ["StokWhS"] = searchDto.StokWhS.ToString(),
            ["StokWhW"] = searchDto.StokWhW.ToString(),
        };

        var url = QueryHelpers.AddQueryString(
            "api/inventory/frm6550/search",
            query);

        return http.GetFromJsonAsync<IEnumerable<Frm6550Dto.ResDto>?>(url);
    }

}

