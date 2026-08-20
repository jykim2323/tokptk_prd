using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public class Frm6100Dto
{
   
    public string? ItemCode { get; set; }
    public string? PalletNo { get; set; }


    public class ResDto
    {
        public string? ItemCode { get; set; }
        public string? ItemName { get; set; }
        public decimal Weight { get; set; }
    }

}
