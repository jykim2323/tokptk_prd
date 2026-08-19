using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.UI.Services.Api.Inbounds;

namespace TOK.WMS.UI.Services.Api.Inventory;

public interface IFrm6100Api
{
    Task<IEnumerable<Frm6100Dto>?> SearchAsync(Frm6100Dto reqDto);

}
public class Frm6100ApiClient(HttpClient http) : IFrm6100Api
{
}
