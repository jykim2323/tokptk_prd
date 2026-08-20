using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public class Frm6100Dto
{
   
    public string? LstkLoca { get; set; }
    public string? LstkBk { get; set; }
    public string? LstkBy { get; set; }
    public string? LstkLv { get; set; }
    public string? LstkFlag { get; set; }
    public string? LstkIndate { get; set; }
    public string? LstkIntime { get; set; }
    public string? LstkPltno { get; set; }


    public class ResDto
    {
        public string? LstkLoca { get; set; }
        public string? LstkBk { get; set; }
        public string? LstkBy { get; set; }
        public string? LstkLv { get; set; }
        public string? LstkFlag { get; set; }
        public string? LstkIndate { get; set; }
        public string? LstkIntime { get; set; }
        public string? LstkPltno { get; set; }
    }

}
