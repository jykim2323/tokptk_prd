using TOK.WMS.Core.DTOs.Inbounds;

namespace TOK.WMS.Core.Interfaces.Inbounds;

public interface IFrm3900Repository
{
    Task<IEnumerable<Frm3900Dto.ResDto>?> SearchAsync(
        Frm3900Dto.ReqDto reqDto);

    Task<IEnumerable<Frm3900Dto.WorkDto>?> FloorStockSearchAsync(
        string pltNo);

    Task<Frm3900Dto.ItemDto?> ItemCheckAsync(
        string itemCode);

    Task<Frm3900Dto.PltCheckDto?> PltCheckAsync(
        string pltNo);

    Task<int> SaveAsync(
        Frm3900Dto.SaveReqDto reqDto);
}