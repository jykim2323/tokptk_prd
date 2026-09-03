using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public class Frm6700Dto
{
    public class ReqDto
    {
        public string? JegoDate { get; set; }
        public string? JegoCode { get; set; }
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
        public string? JegoCode { get; set; }
        public string? MastName { get; set; }
        public string? StokQty { get; set; }
        public string? StokIndate { get; set; }
        public string? StokIntime { get; set; }
        public string? StokFlag { get; set; }
        public string? Gubn1Name { get; set; }
        public string? Gubn2Name { get; set; }
        public string? Gubn3Name { get; set; }

        public decimal JegoSqty { get; set; }
        public decimal JegoWqty { get; set; }
        public decimal JegoFqty { get; set; }
        public decimal JegoTqty { get; set; }

        public decimal JegoAqty { get; set; }
        public decimal JegoBqty { get; set; }
        public decimal JegoCqty { get; set; }
        public decimal JegoDqty { get; set; }
        public decimal JegoEqty { get; set; }
    }
}