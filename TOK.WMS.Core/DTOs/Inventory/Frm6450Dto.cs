using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public class Frm6450Dto
{
    public class ReqDto
    {
        public string? StokItem { get; set; }
        public string? MastName { get; set; }
        public bool Stok1Wh { get; set; } = false;
        public bool Stok2Wh { get; set; } = false;
        public bool Stok3Wh { get; set; } = false;
        public string? DangerousType { get; set; } = string.Empty;
        public string? PetroleumType { get; set; } = string.Empty;
        public string? SolubilityType { get; set; } = string.Empty;

        public string CloseDate { get; set; } = string.Empty;

        public bool HistYN { get; set; } = false;
    }
    public class ResDto
    {
        public string? StokWh { get; set; }
        public string? StokItem { get; set; }
        public string? MastName { get; set; }
        public string? StokLotno { get; set; }
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
    }
}