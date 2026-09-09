using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.DTOs.Outbounds;

public partial class Frm4300Dto
{
    // =========================================================
    // 조회
    // =========================================================

    public class ReqDto
    {
        public string? SearchType { get; set; }
        public string? SearchText { get; set; }
    }


    // =========================================================
    // 검색 종류
    // =========================================================

    public class SearchTypeDto
    {
        public string? Name { get; set; }
        public string? Value { get; set; }
    }


    // =========================================================
    // 조회 결과
    // =========================================================

    public partial class ResDto : ObservableObject
    {
        public string? OuptDate { get; set; }

        public string? OuptIndex { get; set; }

        public string? OuptCode { get; set; }

        public string? MastName { get; set; }

        public string? OuptLotno { get; set; }

        public int? OuptSeqno { get; set; }

        public string? OuptGubun { get; set; }

        public decimal OuptWgt { get; set; }

        public decimal OuptOutWgt { get; set; }

        public string? OuptLoca { get; set; }

        public string? OuptBoxno1 { get; set; }

        public string? OuptRemark1 { get; set; }

        public string? OuptTime { get; set; }

        public string? OuptJobFlag { get; set; }

        public string? OuptRemark { get; set; }

        public string? OuptId { get; set; }

        public string? OuptBoxno { get; set; }

        public string? OuptChasu { get; set; }

        public string? OuptCust { get; set; }

        public string? OuptPltno { get; set; }


        // =====================================================
        // 화면용 날짜
        // =====================================================

        public string DisplayDate
        {
            get
            {
                if (string.IsNullOrWhiteSpace(OuptDate) ||
                    OuptDate.Length != 8)
                {
                    return OuptDate ?? string.Empty;
                }

                return
                    $"{OuptDate[..4]}-" +
                    $"{OuptDate.Substring(4, 2)}-" +
                    $"{OuptDate.Substring(6, 2)}";
            }
        }


        // =====================================================
        // 화면용 시간
        // =====================================================

        public string DisplayTime
        {
            get
            {
                if (string.IsNullOrWhiteSpace(OuptTime) ||
                    OuptTime.Length != 6)
                {
                    return OuptTime ?? string.Empty;
                }

                return
                    $"{OuptTime[..2]}:" +
                    $"{OuptTime.Substring(2, 2)}:" +
                    $"{OuptTime.Substring(4, 2)}";
            }
        }
    }


    // =========================================================
    // 삭제
    // =========================================================

    public class DeleteReqDto
    {
        public List<DeleteItemDto> Items { get; set; } = [];
    }


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
    // 수동출고 완료
    // =========================================================

    public class CompleteReqDto
    {
        public string? OuptIndex { get; set; }

        public string? OuptPltno { get; set; }

        public string? OuptLoca { get; set; }

        public string? UserId { get; set; }
    }


    public class CompleteResultDto
    {
        public bool Success { get; set; }

        public int CompleteCount { get; set; }

        public string? Message { get; set; }
    }
}