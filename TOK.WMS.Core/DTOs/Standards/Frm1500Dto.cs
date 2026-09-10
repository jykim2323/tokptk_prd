namespace TOK.WMS.Core.DTOs.Standards;

public partial class Frm1500Dto
{
    // =========================================================
    // 구분#1 - 위험물
    // =========================================================

    public class Gubn1Dto
    {
        public string? Gubn1Code { get; set; }

        public string? Gubn1Name { get; set; }
    }


    // =========================================================
    // 구분#2 - 석유류
    // =========================================================

    public class Gubn2Dto
    {
        public string? Gubn2Code { get; set; }

        public string? Gubn2Name { get; set; }
    }


    // =========================================================
    // 구분#3 - 수용성
    // =========================================================

    public class Gubn3Dto
    {
        public string? Gubn3Code { get; set; }

        public string? Gubn3Name { get; set; }
    }


    // =========================================================
    // 등록 / 수정 공통 요청
    // =========================================================

    public class SaveReqDto
    {
        public string? Code { get; set; }

        public string? Name { get; set; }
    }


    // =========================================================
    // 삭제
    // =========================================================

    public class DeleteReqDto
    {
        public string? Code { get; set; }
    }
}