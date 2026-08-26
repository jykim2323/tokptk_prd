using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface ISFrm6110Repository
{
    Task<bool> ConfirmedAsync(SFrm6110Dto.ReqDto reqDto);
}
