namespace TOK.WMS.Core.ETC;

public interface IWarehouseRequestContext
{
    WarehouseType SelectedWarehouse { get; }
}

public enum WarehouseType
{
    Raw,
    Product
}