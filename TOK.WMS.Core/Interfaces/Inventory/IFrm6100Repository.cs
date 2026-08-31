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
    Task<bool> LstkCheckAsync(string lstkLoca);
    Task<string?> LstkpltnocheckAsync(string lstkPltno);
    Task<bool> SubklocacheckAsync(string lstkPltno);
    Task<bool> CancelSubkAsync(string subkPltno);
    Task<bool> CancelLstkAsync(string subkPltno);
    Task<bool> DeletePltNoAsync(Frm6100Dto.SubkDto subkDto);
    Task<bool> ResetLstkAsync(string lstkLoca);
}
