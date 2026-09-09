namespace TOK.WMS.Core.DTOs.Standards;

public partial class MastDispDto
{
    // =========================================================
    // 조회
    // =========================================================

    public class ReqDto
    {
        public string? SearchText { get; set; }
    }


    // =========================================================
    // 조회 결과
    // =========================================================

    public class ResDto
    {
        public string? MastCode { get; set; }

        public string? MastName { get; set; }

        public string? MastUnit { get; set; }

        public decimal MastWeight { get; set; }

        public string? Gubn1Name { get; set; }

        public string? Gubn2Name { get; set; }

        public string? Gubn3Name { get; set; }
    }
}