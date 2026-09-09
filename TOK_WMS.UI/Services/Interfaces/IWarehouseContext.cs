using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.UI.Services.ETC;
using static TOK.WMS.UI.ViewModels.MainViewModel;

namespace TOK.WMS.UI.Services.Interfaces;

public interface IWarehouseContext
{
    WarehouseType SelectedWarehouse { get; set; }
}
