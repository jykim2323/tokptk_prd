using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.DTOs.Inbounds;

public partial class Frm3900Dto
{
    public class ReqDto
    {
        public string? FromDate { get; set; }
        public string? ToDate { get; set; }
        public string? SearchType { get; set; }
        public string? SearchText { get; set; }
        public string? Hogi { get; set; }
    }

    public class SearchTypeDto
    {
        public string? Name { get; set; }
        public string? Value { get; set; }
    }

    public class HogiDto
    {
        public string? Name { get; set; }
        public string? Value { get; set; }
    }

    public class ResDto
    {
        public string? OuptDate { get; set; }
        public string? OuptIndex { get; set; }
        public int? OuptSeqno { get; set; }

        public string? OuptPltno { get; set; }
        public string? OuptCode { get; set; }
        public string? MastName { get; set; }
        public string? OuptLotno { get; set; }

        public decimal? OuptWgt { get; set; }
        public decimal? OuptOutWgt { get; set; }

        public string? OuptBoxno { get; set; }
        public string? OuptRemark { get; set; }

        public string? OuptLoca { get; set; }
        public string? OuptRloca { get; set; }

        public string? OuptTime { get; set; }
        public string? OuptRflag { get; set; }
        public string? OuptJobFlag { get; set; }

        public string? OuptIndate { get; set; }
        public string? OuptIntime { get; set; }

        public string? StatusCode { get; set; }
        public decimal? CurrWgt { get; set; }

        public decimal RemainWgt =>
            (OuptWgt ?? 0) - (OuptOutWgt ?? 0);
    }

    public partial class WorkDto : ObservableObject
    {
        [ObservableProperty] private bool _isClicked;

        public string? SubkPltno { get; set; }
        public string? SubkCode { get; set; }
        public string? MastName { get; set; }
        public string? SubkLotno { get; set; }

        public decimal? SubkWgt { get; set; }

        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }

        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }

        public string? OuptIndex { get; set; }

        // 0 = 신규
        // 1 = 기존 바닥재고
        public string? Status { get; set; }
    }

    public class DeleteDto
    {
        public string? SubkPltno { get; set; }
        public string? SubkCode { get; set; }
        public string? SubkLotno { get; set; }
    }

    public class ItemDto
    {
        public string? MastCode { get; set; }
        public string? MastName { get; set; }
        public decimal? MastWeight { get; set; }
    }

    public class PltCheckDto
    {
        public int Count { get; set; }
        public string? SubkLoca { get; set; }
    }

    public class SaveReqDto
    {
        public string? UserId { get; set; }

        public List<WorkDto> Items { get; set; } = [];
        public List<DeleteDto> DeleteItems { get; set; } = [];
    }
}