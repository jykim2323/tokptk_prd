namespace TOK.WMS.Core.DTOs.Inbounds;

public partial class Frm3400Dto
{
    public class SearchTypeDto
    {
        public string Name { get; set; } = string.Empty;
        public string Value { get; set; } = string.Empty;
    }

    public class RFlagTypeDto
    {
        public string Name { get; set; } = string.Empty;
        public string Value { get; set; } = string.Empty;
    }

    public class ReqDto
    {
        public string? FromDate { get; set; }
        public string? ToDate { get; set; }

        public string? RFlag { get; set; }

        public string? SearchType { get; set; }

        public string? SearchText { get; set; }
    }

    public partial class ResDto
    {
        public string? InptIndate { get; set; }
        public string? InptIndex { get; set; }
        public string? InptCode { get; set; }
        public string? MastName { get; set; }
        public string? InptLotno { get; set; }
        public decimal? InptWeight { get; set; }
        public string? InptLoca { get; set; }
        public string? InptStation { get; set; }
        public string? InptRemark { get; set; }
        public string? InptBoxno { get; set; }
        public string? InptStime { get; set; }
        public string? InptEtime { get; set; }
        public string? InptHogi { get; set; }
        public string? InptJobFlag { get; set; }
        public string? InptRflag { get; set; }
        public string? InptRdate { get; set; }
        public string? InptRtime { get; set; }
        public string? InptOindex { get; set; }
        public string? InptId { get; set; }
        public string? InptPltno { get; set; }

        public string RFlagName =>
            InptRflag switch
            {
                "N" => "신규입고",
                "R" => "재입고",
                _ => ""
            };
    }

    public class DeleteReqDto
    {
        public string? InptCode { get; set; }
        public string? InptIndex { get; set; }
    }
}