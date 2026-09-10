using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public interface IFrm1500Repository
{
    // =========================================================
    // 조회
    // =========================================================

    Task<IEnumerable<Frm1500Dto.Gubn1Dto>?> Gubn1SearchAsync();

    Task<IEnumerable<Frm1500Dto.Gubn2Dto>?> Gubn2SearchAsync();

    Task<IEnumerable<Frm1500Dto.Gubn3Dto>?> Gubn3SearchAsync();


    // =========================================================
    // 구분#1
    // =========================================================

    Task<int> InsertGubn1Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> UpdateGubn1Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> DeleteGubn1Async(
        Frm1500Dto.DeleteReqDto reqDto);


    // =========================================================
    // 구분#2
    // =========================================================

    Task<int> InsertGubn2Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> UpdateGubn2Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> DeleteGubn2Async(
        Frm1500Dto.DeleteReqDto reqDto);


    // =========================================================
    // 구분#3
    // =========================================================

    Task<int> InsertGubn3Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> UpdateGubn3Async(
        Frm1500Dto.SaveReqDto reqDto);

    Task<int> DeleteGubn3Async(
        Frm1500Dto.DeleteReqDto reqDto);
}