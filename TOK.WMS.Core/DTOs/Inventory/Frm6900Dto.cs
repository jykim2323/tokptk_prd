using CommunityToolkit.Mvvm.ComponentModel;
using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Inventory;

public partial class Frm6900Dto 
{
    public class ReqDto
    {

        public string? SubkPltno { get; set; }
        public string? SubkLoca { get; set; }
        private bool IsSelected { get; set; } = false;
        public string? LstkBy { get; set; }
        public string? LstkLv { get; set; }
        public string? LstkFlag { get; set; }
        public string? LstkIndate { get; set; }
        public string? LstkIntime { get; set; }
        public string? LstkPltno { get; set; }

    }

    public  partial  class ResDto : ObservableObject
    {
        [ObservableProperty]  private bool isClicked;

        public string? SubkPltno { get; set; }
        public string? SubkFlag { get; set; }
        public string? SubkLoca { get; set; }
        public string? CodeCnt { get; set; }
        public string? InDateTime { get; set; }
    }

    public class SubkDto
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
    }

}
