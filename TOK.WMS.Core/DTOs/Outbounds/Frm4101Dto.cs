namespace TOK.WMS.Core.DTOs.Outbounds;

public partial class Frm4101Dto
{
    public class ExcelRowDto
    {
        public int No { get; set; }

        public string? ItemCode { get; set; }
        public string? ItemName { get; set; }

        public string? LotNo { get; set; }

        public decimal Qty { get; set; }

        public string? Customer { get; set; }

        public string? BoxNo { get; set; }

        public string? Remark { get; set; }
    }


    public class SaveReqDto
    {
        public List<ExcelRowDto> Items { get; set; } = [];
    }


    public class SaveResultDto
    {
        public string? Chasu { get; set; }

        public int Count { get; set; }
    }
}