using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;

namespace TOK.WMS.Core.Interfaces.Inbounds;

/// <summary>
/// Frm3300 입고 메뉴 Repository가 제공해야 하는 조회/작업 계약을 정의합니다.
/// </summary>
public interface IFrm3300Repository
{
    Task<IEnumerable<Frm3300Dto.ResDto>?> SearchAsync();
    Task<bool> DeleteAsync(Frm3300Dto.DeleteReqDto reqDto);
    Task<bool> LabelPrintAsync(Frm3300Dto.ReqDto reqDto);
    Task<bool> LabelPrintCompleteAsync(Frm3300Dto.ReqDto reqDto);
}
