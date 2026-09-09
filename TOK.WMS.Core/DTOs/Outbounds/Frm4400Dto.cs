namespace TOK.WMS.Core.DTOs.Outbounds;

public partial class Frm4400Dto
{
    // =========================================================
    // 조회 조건
    // =========================================================

    public class ReqDto
    {
        public string? FromDate { get; set; }

        public string? ToDate { get; set; }

        public string? SearchType { get; set; }

        public string? SearchText { get; set; }

        public string? Customer { get; set; }
    }


    // =========================================================
    // 검색 조건 ComboBox
    // =========================================================

    public class SearchTypeDto
    {
        public string? Name { get; set; }

        public string? Value { get; set; }
    }


    // =========================================================
    // 납품처 ComboBox
    // =========================================================

    public class CustomerDto
    {
        public string? Name { get; set; }
    }


    // =========================================================
    // 출고이력 조회 결과
    // =========================================================

    public class ResDto
    {
        public string? OuptDate { get; set; }

        public string? OuptIndex { get; set; }

        public int? OuptSeqno { get; set; }

        public string? OuptPltno { get; set; }

        public string? OuptCode { get; set; }

        public string? MastName { get; set; }

        public string? OuptLotno { get; set; }

        public string? OuptGubun { get; set; }

        public decimal OuptWgt { get; set; }

        public decimal OuptOutWgt { get; set; }

        public string? OuptLoca { get; set; }

        public string? OuptTime { get; set; }

        public string? OuptJobFlag { get; set; }

        public string? OuptRemark { get; set; }

        public string? OuptId { get; set; }

        public string? OuptBoxno { get; set; }

        public string? OuptChasu { get; set; }

        public string? OuptCust { get; set; }

        public string? OuptRemark1 { get; set; }

        public string? OuptBoxno1 { get; set; }
    }


    // =========================================================
    // 삭제
    // =========================================================

    public class DeleteReqDto
    {
        public string? OuptIndex { get; set; }

        public string? OuptCode { get; set; }

        public string? OuptLotno { get; set; }
    }
}