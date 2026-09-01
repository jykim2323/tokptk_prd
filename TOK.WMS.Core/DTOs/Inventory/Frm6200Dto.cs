using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public class Frm6200Dto
{
    public class ReqDto
    {
        public int RecNo { get; set; }
        public string? SubkFlag { get; set; }
        public string? SubkLoca { get; set; }
        public string? SubkPltno { get; set; }
        public string? SubkCode { get; set; }
        public string? MastName { get; set; }
        public string? SubkLotno { get; set; }
        public string? SubkWgt { get; set; }
        public string? SubkRwgt { get; set; }
        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }
        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }
        public string? Gubn1Name { get; set; }
        public string? Gubn2Name { get; set; }
        public string? Gubn3Name { get; set; }
    }
    public class ResDto
    {
        public int RecNo { get; set; }
        public string? SubkFlag { get; set; }
        public string? SubkLoca { get; set; }
        public string? SubkPltno { get; set; }
        public string? SubkCode { get; set; }
        public string? MastName { get; set; }
        public string? SubkLotno { get; set; }
        public string? SubkWgt { get; set; }
        public string? SubkRwgt { get; set; }
        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }
        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }
        public string? Gubn1Name { get; set; }
        public string? Gubn2Name { get; set; }
        public string? Gubn3Name { get; set; }
    }

    public class SearchReqDto
    {
        public string? FromDate { get; set; } = string.Empty;
        public string? ToDate { get; set; } = string.Empty;
        public string? SearchType { get; set; } = string.Empty;
        public string? SearchText { get; set; } = string.Empty;
        public string? DangerousType { get; set; } = string.Empty;
        public string? PetroleumType { get; set; } = string.Empty;
        public string? SolubilityType { get; set; } = string.Empty;
    }

    public class ProhibitionReqDto
    {
        public string BanType { get; set; } = string.Empty;
        public string SubkLoca { get; set; } = string.Empty;
    }
}