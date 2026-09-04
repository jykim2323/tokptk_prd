using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface ISFrm6130Repository
{
    Task<bool> ConfirmedAsync(SFrm6130Dto.ReqDto reqDto);
    Task<bool> SubkCheckAsync(SFrm6130Dto.ReqDto reqdto);
    Task<int> SubkInsert(SFrm6130Dto.ReqDto reqdto);
    Task<bool> SubkUpdateAsync(SFrm6130Dto.ReqDto reqdto);
}
