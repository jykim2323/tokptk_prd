using Microsoft.AspNetCore.Http;


namespace TOK.WMS.Core.ETC;

public class WarehouseRequestContext : IWarehouseRequestContext
{
    private readonly IHttpContextAccessor _http;

    public WarehouseRequestContext(IHttpContextAccessor http)
    {
        _http = http;
    }

    public WarehouseType SelectedWarehouse
    {
        get
        {
            var value = _http.HttpContext?
                .Request
                .Headers["X-Warehouse-Type"]
                .FirstOrDefault();

            return value switch
            {
                "Raw" => WarehouseType.Raw,
                "Product" => WarehouseType.Product,
                _ => WarehouseType.Raw
            };
        }
    }
}
