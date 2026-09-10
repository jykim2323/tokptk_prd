namespace TOK.WMS.Core.DTOs.Standards;

public partial class Frm1300Dto
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
        public string? UserId { get; set; }

        public string? UserPassword { get; set; }

        public string? UserName { get; set; }

        public DateTime? UserWdate { get; set; }

        public int UserKind { get; set; }

        public string? UserUses { get; set; }
    }


    // =========================================================
    // 등록 / 수정
    // =========================================================

    public class SaveReqDto
    {
        public string? UserId { get; set; }

        public string? UserPassword { get; set; }

        public string? UserName { get; set; }

        public int UserKind { get; set; }
    }


    // =========================================================
    // 삭제
    // =========================================================

    public class DeleteReqDto
    {
        public string? UserId { get; set; }
    }


    // =========================================================
    // 중복체크
    // =========================================================

    public class DuplicateReqDto
    {
        public string? UserId { get; set; }
    }


    // =========================================================
    // 등급 ComboBox
    // =========================================================

    public class UserKindDto
    {
        public int Value { get; set; }

        public string? Name { get; set; }
    }
}