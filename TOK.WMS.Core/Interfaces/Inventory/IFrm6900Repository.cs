using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.ETC;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6900Repository
{
    Task<IEnumerable<Frm6900Dto.ResDto>?> SearchAsync(Frm6900Dto.ReqDto reqDto);
    Task<IEnumerable<Frm6900Dto.SubkDto>?> SubkSearchAsync(Frm6900Dto.ReqDto reqDto);
    Task<bool> TrakingAsync(string sPltno);
    Task<bool> LstkCheckAsync(string sPltno);
    Task<bool> SubkLocaCheck(string sPltno);
    Task<bool> SubkCheck(string subkLoca);
    Task<int> DeleteAsync(string subkLoca);
    Task<int> LstkClearAsync(string lstkLoca);
}
