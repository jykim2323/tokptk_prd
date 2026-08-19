using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;

namespace TOK.WMS.Core.Interfaces.Inbounds;

/// <summary>
/// Frm3100 입고 메뉴 Repository가 제공해야 하는 조회/작업 계약을 정의합니다.
/// </summary>
public interface IFrm3100Repository
{
    Task<IEnumerable<Frm3100Dto>?> SearchAsync(Frm3100Dto model);

    Task SaveAsync(
            Frm3100Dto model,
            IReadOnlyCollection<Frm3100ResDto> reservationItems,
            IReadOnlyCollection<Frm3100ResDto> deleteItems);

    Task AddAsync(
    Frm3100Dto model,
    IReadOnlyCollection<Frm3100ResDto> Items
    );

    Task CancleAsync(IReadOnlyCollection<Frm3100ResDto> selectedReservation);

    Task<bool> TrakingAsync(string sPltno);
    Task<bool> Lstk_check(string sPltno);
    Task<bool> Trak_check(string sPltno);
    Task<bool> Subk_check(string sPltno);
    Task<int> Subk_Del(string sPltno, string? sSubkcode = null, string? sSubklotno = null);
    Task<int> Subk_insert(Frm3100ResDto resDto);
    Task<IEnumerable<Frm3100ResDto>?> SpeedhAsync(string sPltno);

}
