namespace TOK.WMS.Core.DTOs.Inbounds;

public partial class Frm3130Dto
{
    public class ReqDto
    {
        public string? SubkPltno { get; set; }
    }

    public class ResDto
    {
        public string? SubkLoca { get; set; }
        public string? SubkPltno { get; set; }

        public string? SubkCode { get; set; }
        public string? MastName { get; set; }
        public string? MastUnit { get; set; }

        public string? SubkLotno { get; set; }

        public string? SubkFlag { get; set; }
        public string? SubkGubun { get; set; }

        public decimal? SubkWgt { get; set; }
        public decimal? SubkRwgt { get; set; }

        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }

        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }
    }

    public class PltCheckDto
    {
        public int TrackingCount { get; set; }
        public int LstkCount { get; set; }
        public int LocatedSubkCount { get; set; }

        public string? BlockFlag { get; set; }
        public string? SubkLoca { get; set; }
    }

    public class InsertReqDto
    {
        public string? SubkPltno { get; set; }

        public string? SubkCode { get; set; }
        public string? SubkLotno { get; set; }

        public decimal SubkWgt { get; set; }

        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }

        public string? UserId { get; set; }
    }

    public class InsertResultDto
    {
        public bool Success { get; set; }
        public string? Message { get; set; }
    }

    public class EmptyResultDto
    {
        public bool Success { get; set; }

        public string? MastName { get; set; }

        public decimal Qty { get; set; }

        public string? Message { get; set; }
    }

    public class DeleteReqDto
    {
        public string? SubkPltno { get; set; }
        public string? SubkCode { get; set; }
        public string? SubkLotno { get; set; }
    }
}