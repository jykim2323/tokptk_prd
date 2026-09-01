using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6200Repository
{
    Task<IEnumerable<Frm6200Dto.ResDto>?> SearchAsync(Frm6200Dto.SearchReqDto searchDto);

    Task<bool> ProhibitionAsync(Frm6200Dto.ProhibitionReqDto reqDto);
}
