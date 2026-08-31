using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public class LocaAddDto
{
    public class ReqDto
    {
        public string? SubkLoca { get; set; }
        public string? SubkFlag { get; set; }
        public string? SubkCode { get; set; }
        public string? SubkGubun { get; set; }
        public string? SubkWgt { get; set; }
        public string? SubkRwgt { get; set; }
        public string? SubkLotno { get; set; }
        public string? SubkRemark { get; set; }
        public string? SubkBoxno { get; set; }
        public string? SubkPltno { get; set; }
        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }
        public string? MastName { get; set; }
        public string? Gubn1Name { get; set; }
        public string? Gubn2Name { get; set; }
        public string? Gubn3Name { get; set; }

        public string? UserId { get; set; } = string.Empty;

        public string? UserName { get; set; } = string.Empty;

        public string? UserJobNumber { get; set; } = string.Empty;

        public int UserKind { get; set; } = 0;

        public string? UserUses { get; set; } = string.Empty;
    }


}
