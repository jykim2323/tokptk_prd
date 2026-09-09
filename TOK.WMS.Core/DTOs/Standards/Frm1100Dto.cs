namespace TOK.WMS.Core.DTOs.Standards;

public partial class Frm1100Dto
{
    // =========================================================
    // 조회
    // =========================================================

    public class ReqDto
    {
        public string? ItemCode { get; set; }
    }


    // =========================================================
    // 품목 조회 결과
    // =========================================================

    public class ResDto
    {
        public string? MastCode { get; set; }

        public string? MastBcode { get; set; }

        public string? MastName { get; set; }

        public string? MastUnit { get; set; }

        public decimal MastWeight { get; set; }

        public string? MastGubn1 { get; set; }

        public string? Gubn1Name { get; set; }

        public string? MastGubn2 { get; set; }

        public string? Gubn2Name { get; set; }

        public string? MastGubn3 { get; set; }

        public string? Gubn3Name { get; set; }

        public DateTime? MastDate { get; set; }

        public string? MastRef1 { get; set; }
    }


    // =========================================================
    // 구분 ComboBox
    // SFrm1100에서 사용
    // =========================================================

    public class GubnDto
    {
        public string? Code { get; set; }

        public string? Name { get; set; }

        public string DisplayName =>
            string.IsNullOrWhiteSpace(Code)
                ? string.Empty
                : $"{Code}-{Name}";
    }


    // =========================================================
    // SFrm1100 전달용
    // =========================================================

    public class EditorDto
    {
        public string? MastCode { get; set; }

        public string? MastBcode { get; set; }

        public string? MastName { get; set; }

        public string? MastUnit { get; set; }

        public decimal MastWeight { get; set; }

        public string? MastGubn1 { get; set; }

        public string? MastGubn2 { get; set; }

        public string? MastGubn3 { get; set; }

        public string? MastRef1 { get; set; }
    }
}