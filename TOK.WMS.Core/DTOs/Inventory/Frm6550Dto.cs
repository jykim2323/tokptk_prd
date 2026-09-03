using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public class Frm6550Dto
{
    public class ReqDto
    {
        public string? StokItem { get; set; }
        public string? MastName { get; set; }
        public bool StokWhM { get; set; } = false;
        public bool StokWhS { get; set; } = false;
        public bool StokWhW { get; set; } = false;
        public string? DangerousType { get; set; } = string.Empty;
        public string? PetroleumType { get; set; } = string.Empty;
        public string? SolubilityType { get; set; } = string.Empty;

        public string CloseDate { get; set; } = string.Empty;
        public bool HistYN { get; set; } = false;
    }
    public class ResDto
    {
        public string? StokItem { get; set; }
        public string? MastName { get; set; }
        //public string? StokSqty { get; set; }
        //public string? StokWqty { get; set; }
        //public string? StokMqty { get; set; }
        //public string? StokTqty { get; set; }
        public string? StokLoca { get; set; }
        public string? StokQty { get; set; }
        public string? StokBoxno { get; set; }
        public string? StokRemark { get; set; }
        public string? StokIndate { get; set; }
        public string? StokIntime { get; set; }
        public string? StokFlag { get; set; }
        public string? Gubn1Name { get; set; }
        public string? Gubn2Name { get; set; }
        public string? Gubn3Name { get; set; }
        //public string? StokAqty { get; set; }
        //public string? StokBqty { get; set; }
        //public string? StokCqty { get; set; }
        //public string? StokDqty { get; set; }
        //public string? StokEqty { get; set; }

        public decimal StokSqty { get; set; }
        public decimal StokWqty { get; set; }
        public decimal StokFqty { get; set; }
        public decimal StokTqty { get; set; }

        public decimal StokAqty { get; set; }
        public decimal StokBqty { get; set; }
        public decimal StokCqty { get; set; }
        public decimal StokDqty { get; set; }
        public decimal StokEqty { get; set; }
    }
}