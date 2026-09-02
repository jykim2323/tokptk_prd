using Microsoft.AspNetCore.WebUtilities;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface IFrm6450Api
{
    Task<IEnumerable<Frm6450Dto.ResDto>?> SearchAsync(Frm6450Dto.ReqDto searchDto);

    Task<IEnumerable<Frm6450Dto.ResDto>?> PltnoCntAsync(Frm6450Dto.ReqDto searchDto);
}

public class Frm6450ApiClient(HttpClient http) : IFrm6450Api
{
    public Task<IEnumerable<Frm6450Dto.ResDto>?> SearchAsync(Frm6450Dto.ReqDto searchDto)
    {
        var query = new Dictionary<string, string?>
        {
            ["Closedate"] = searchDto.CloseDate,
            ["StokItem"] = searchDto.StokItem,
            ["MastName"] = searchDto.MastName,
            ["DangerousType"] = searchDto.DangerousType,
            ["PetroleumType"] = searchDto.PetroleumType,
            ["SolubilityType"] = searchDto.SolubilityType,
            ["HistYN"] = searchDto.HistYN.ToString(),
            ["Stok1Wh"] = searchDto.Stok1Wh.ToString(),
            ["Stok2Wh"] = searchDto.Stok2Wh.ToString(),
            ["Stok3Wh"] = searchDto.Stok3Wh.ToString(),
        };

        var url = QueryHelpers.AddQueryString(
            "api/inventory/frm6450/search",
            query);

        return http.GetFromJsonAsync<IEnumerable<Frm6450Dto.ResDto>?>(url);
    }

    public Task<IEnumerable<Frm6450Dto.ResDto>?> PltnoCntAsync(Frm6450Dto.ReqDto searchDto)
    {
        string qs =
            $"CloseDate={Uri.EscapeDataString(searchDto.CloseDate ?? "")}";

        return http.GetFromJsonAsync<IEnumerable<Frm6450Dto.ResDto>?>($"api/inventory/frm6450/pltnocnt?{qs}");
    }
}

