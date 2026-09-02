using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6300Repository
{
    Task<IEnumerable<Frm6300Dto.ResDto>?> SearchAsync(Frm6300Dto.ReqDto reqDto);

    Task<IEnumerable<Frm6300Dto.LotnoResDto>?> LotnoSearchAsync(Frm6300Dto.ReqDto reqDto);

}
