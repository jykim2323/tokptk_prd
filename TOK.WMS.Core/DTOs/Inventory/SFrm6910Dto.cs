public partial class SFrm6910Dto
{
    public class ResDto
    {
        public string SubkPltno { get; set; } = string.Empty;

        // 처음 조회했을 당시 PLT
        public string OriginalPltNo { get; set; } = string.Empty;

        public string SubkCode { get; set; } = string.Empty;
        public string MastName { get; set; } = string.Empty;
        public string SubkLotno { get; set; } = string.Empty;

        public decimal SubkWgt { get; set; }

        public string SubkBoxno { get; set; } = string.Empty;
        public string SubkRemark { get; set; } = string.Empty;
    }

    public class SaveReqDto
    {
        public string LeftPltNo { get; set; } = string.Empty;
        public string RightPltNo { get; set; } = string.Empty;

        public List<MoveDto> Items { get; set; } = [];
    }

    public class MoveDto
    {
        public string OriginalPltNo { get; set; } = string.Empty;
        public string TargetPltNo { get; set; } = string.Empty;

        public string SubkCode { get; set; } = string.Empty;
        public string SubkLotno { get; set; } = string.Empty;
    }
}