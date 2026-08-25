using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6100Repository
{

    Task<IEnumerable<Frm6100Dto.ResDto>?> SearchAsync(Frm6100Dto reqDto);

}
