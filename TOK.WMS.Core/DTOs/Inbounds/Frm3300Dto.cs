namespace TOK.WMS.Core.DTOs.Inbounds;

public partial class Frm3300Dto
{
    public class ReqDto
    {
        public string? InptIndate { get; set; }
        public string? InptIndex { get; set; }
        public string? InptCode { get; set; }
        public string? InptLotno { get; set; }
        public string? InptLoca { get; set; }
        public string? InptJobFlag { get; set; }
        public string? InptLabel { get; set; }
        public string? InptPltno { get; set; }
    }

    public class ResDto
    {
        public string? InptIndate { get; set; }
        public string? InptIndex { get; set; }
        public string? InptCode { get; set; }
        public string? MastName { get; set; }
        public string? InptLotno { get; set; }
        public decimal? InptWeight { get; set; }
        public string? InptRemark { get; set; }
        public string? InptHogi { get; set; }
        public string? InptLoca { get; set; }
        public string? InptBoxno { get; set; }
        public string? InptStime { get; set; }
        public string? InptEtime { get; set; }
        public string? InptJobFlag { get; set; }
        public string? InptId { get; set; }
        public string? InptLabel { get; set; }
        public string? InptPltno { get; set; }
    }

    public class DeleteReqDto
    {
        public string? InptCode { get; set; }
        public string? InptLotno { get; set; }
        public string? InptIndex { get; set; }
        public string? InptLoca { get; set; }
    }
}