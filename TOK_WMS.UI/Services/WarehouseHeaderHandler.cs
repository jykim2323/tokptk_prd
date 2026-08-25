using System.Net.Http;
using TOK.WMS.UI.Services.Interfaces;

namespace TOK.WMS.UI.Services;

public class WarehouseHeaderHandler : DelegatingHandler
{
    private readonly IWarehouseContext _warehouseContext;

    public WarehouseHeaderHandler(IWarehouseContext warehouseContext)
    {
        _warehouseContext = warehouseContext;
    }

    protected override Task<HttpResponseMessage> SendAsync(
         HttpRequestMessage request,
         CancellationToken cancellationToken)
    {
        // ★ 여기 브레이크포인트
        var selected = _warehouseContext.SelectedWarehouse;

        request.Headers.Remove("X-Warehouse-Type");

        request.Headers.Add(
            "X-Warehouse-Type",
            selected.ToString());

        return base.SendAsync(request, cancellationToken);
    }
}
