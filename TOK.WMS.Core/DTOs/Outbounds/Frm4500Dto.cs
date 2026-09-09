namespace TOK.WMS.Core.DTOs.Outbounds;

public partial class Frm4500Dto
{
    // =========================================================
    // 품목별 조회 조건
    // =========================================================

    public class ReqDto
    {
        public string? FromDate { get; set; }

        public string? ToDate { get; set; }

        public string? ItemCode { get; set; }

        public string? ItemName { get; set; }
    }


    // =========================================================
    // LOT별 조회 조건
    // =========================================================

    public class LotReqDto
    {
        public string? FromDate { get; set; }

        public string? ToDate { get; set; }

        public string? ItemCode { get; set; }
    }


    // =========================================================
    // 상단 Grid
    // 품목별 출고 실적
    // =========================================================

    public class ItemSummaryDto
    {
        public string? StkCode { get; set; }

        public string? MastName { get; set; }

        public decimal StkTqty { get; set; }
    }


    // =========================================================
    // 하단 Grid
    // LOT별 출고 실적
    // =========================================================

    public class LotSummaryDto
    {
        public string? StkCode { get; set; }

        public string? MastName { get; set; }

        public string? StkLotno { get; set; }

        public decimal StkTqty { get; set; }
    }
}