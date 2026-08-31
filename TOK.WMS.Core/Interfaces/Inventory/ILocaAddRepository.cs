using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface ILocaAddRepository
{
    Task<bool> SubkCheckAsync(LocaAddDto.ReqDto reqdto);
    Task<bool> ConfirmedAsync(LocaAddDto.ReqDto reqDto);
}
