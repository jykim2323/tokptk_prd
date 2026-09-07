using TOK.WMS.Core.DTOs.Inbounds;

namespace TOK.WMS.Core.Interfaces.Inbounds;

/// <summary>
/// Frm3400 입고 메뉴 Repository가 제공해야 하는 조회/작업 계약을 정의합니다.
/// </summary>
public interface IFrm3400Repository
{
    Task<IEnumerable<Frm3400Dto.ResDto>> SearchAsync(
        Frm3400Dto.ReqDto reqDto);

    Task<bool> DeleteAsync(
        Frm3400Dto.DeleteReqDto reqDto);
}