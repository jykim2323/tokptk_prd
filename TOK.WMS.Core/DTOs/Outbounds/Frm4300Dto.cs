namespace TOK.WMS.Core.DTOs.Outbounds;

public partial class Frm4300Dto
{
    // =========================================================
    // 조회 조건
    // =========================================================

    public class ReqDto
    {
        public string? SearchType { get; set; }

        public string? SearchText { get; set; }
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
    // 미출고 현황 조회 결과
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
    // 삭제 요청
    // =========================================================

    public class DeleteReqDto
    {
        public List<DeleteItemDto> Items { get; set; } = [];
    }


    // =========================================================
    // 삭제 대상
    // =========================================================

    public class DeleteItemDto
    {
        public string? OuptIndex { get; set; }

        public string? OuptCode { get; set; }

        public string? OuptLotno { get; set; }

        public string? OuptCust { get; set; }

        public string? OuptLoca { get; set; }
    }


    // =========================================================
    // 해당 PLT 미출고 건수
    // =========================================================

    public class PendingCountDto
    {
        public int Count { get; set; }
    }


    // =========================================================
    // 수동출고 완료 요청
    // =========================================================

    public class CompleteReqDto
    {
        public string? OuptIndex { get; set; }

        public string? OuptPltno { get; set; }

        public string? OuptLoca { get; set; }

        public string? UserId { get; set; }
    }


    // =========================================================
    // 수동출고 완료 결과
    // =========================================================

    public class CompleteResultDto
    {
        public bool Success { get; set; }

        public int CompleteCount { get; set; }

        public string? Message { get; set; }
    }
}