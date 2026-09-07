namespace TOK.WMS.Core.DTOs.Inbounds;

public partial class Frm3700Dto
{
    public class ReqDto
    {
        public string? FromDate { get; set; }
        public string? ToDate { get; set; }

        public string? ItemCode { get; set; }
        public string? ItemName { get; set; }
    }

    public class LotReqDto
    {
        public string? FromDate { get; set; }
        public string? ToDate { get; set; }

        public string? StkCode { get; set; }
    }

    public class ResDto
    {
        public string? StkCode { get; set; }
        public string? MastName { get; set; }

        public decimal StkTqty { get; set; }
    }

    public class LotResDto
    {
        public string? StkCode { get; set; }
        public string? MastName { get; set; }

        public string? StkLotno { get; set; }

        public decimal StkTqty { get; set; }
    }
}