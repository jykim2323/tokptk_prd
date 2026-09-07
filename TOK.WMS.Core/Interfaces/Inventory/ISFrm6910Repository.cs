using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface ISFrm6910Repository
{
    Task<IEnumerable<SFrm6910Dto.ResDto>> SearchAsync(string pltNo);

    Task<bool> SaveAsync(SFrm6910Dto.SaveReqDto reqDto);
}
