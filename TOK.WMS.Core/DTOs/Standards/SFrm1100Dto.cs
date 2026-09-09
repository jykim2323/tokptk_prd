namespace TOK.WMS.Core.DTOs.Standards;

public partial class SFrm1100Dto
{
    // =========================================================
    // Window 초기화용
    // =========================================================

    public class InitDto
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


    // =========================================================
    // 등록 / 수정 요청
    // =========================================================

    public class ReqDto
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


    // =========================================================
    // 삭제 요청
    // =========================================================

    public class DeleteReqDto
    {
        public string? MastCode { get; set; }
    }


    // =========================================================
    // 구분 ComboBox
    // =========================================================

    public class GubnDto
    {
        public string? Code { get; set; }

        public string? Name { get; set; }

        public string DisplayName =>
            string.IsNullOrWhiteSpace(Code)
                ? string.Empty
                : $"{Code} - {Name}";
    }
}