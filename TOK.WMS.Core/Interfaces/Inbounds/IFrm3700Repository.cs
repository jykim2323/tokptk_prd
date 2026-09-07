using TOK.WMS.Core.DTOs.Inbounds;

namespace TOK.WMS.Core.Interfaces.Inbounds;

/// <summary>
/// Frm3700 입고 메뉴 Repository가 제공해야 하는 조회/작업 계약을 정의합니다.
/// </summary>
public interface IFrm3700Repository
{
    Task<IEnumerable<Frm3700Dto.ResDto>> SearchAsync(
        Frm3700Dto.ReqDto reqDto);

    Task<IEnumerable<Frm3700Dto.LotResDto>> LotSearchAsync(
        Frm3700Dto.LotReqDto reqDto);
}