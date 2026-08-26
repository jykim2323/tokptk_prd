using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6100Repository
{

    Task<IEnumerable<Frm6100Dto.ResDto>?> SearchAsync(Frm6100Dto reqDto);

    Task<IEnumerable<Frm6100Dto.SubkDto>?> SubkSearchAsync(string lstkLoca);
    Task<bool> SubkCheckAsync(string lstkLoca);
    Task<int> DeleteAsync(string subkLoca);
    Task<int> LstkClearAsync(string lstkLoca);

}
