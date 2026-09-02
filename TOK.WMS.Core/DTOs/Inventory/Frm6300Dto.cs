using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public class Frm6300Dto
{
    public class ReqDto
    {
        public string? SubkCode { get; set; }
        public string? MastName { get; set; }
        public string? SubkLotno { get; set; }
        public string? SubkWgt { get; set; }
        public string? SubkRwgt { get; set; }
        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }
        public string? Gubn1Name { get; set; }
        public string? Gubn2Name { get; set; }
        public string? Gubn3Name { get; set; }
        public string? DangerousType { get; set; } = string.Empty;
        public string? PetroleumType { get; set; } = string.Empty;
        public string? SolubilityType { get; set; } = string.Empty;
    }
    public class ResDto
    {
        public string? SubkCode { get; set; }
        public string? SubkTqty { get; set; }
        public string? MastName { get; set; }
        public string? Gubn1Name { get; set; }
        public string? Gubn2Name { get; set; }
        public string? Gubn3Name { get; set; }
    }
    public class LotnoResDto
    {
        public string? SubkCode { get; set; }
        public string? SubkTqty { get; set; }
        public string? MastName { get; set; }
        public string? SubkLotno { get; set; }
    }
}