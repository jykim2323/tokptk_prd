using TOK.WMS.UI.Services.Interfaces;

namespace TOK.WMS.UI.Services.ETC;

public enum WarehouseType
{
    Raw,
    Product
}

public class WarehouseContext : IWarehouseContext
{
    public WarehouseType SelectedWarehouse { get; set; }
        = WarehouseType.Raw;
}
