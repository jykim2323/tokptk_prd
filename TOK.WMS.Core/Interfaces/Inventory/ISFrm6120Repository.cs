using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface ISFrm6120Repository
{
    public Task<IEnumerable<SFrm6120Dto.ReqDto>?> LstkpltnocheckAsync(SFrm6120Dto.ReqDto reqdto);
    public Task<string?> SubklocacheckAsync(string subkpltno);
    public Task<bool> LstkcheckAsync(string subkpltno);
    Task<bool> ConfirmedAsync(SFrm6120Dto.ReqDto reqDto);
    Task<IEnumerable<SFrm6120Dto.ReqDto>?> SubkSearchAsync(string subkpltno);
    public Task<bool> MilstkUpdateAsync(SFrm6120Dto.ReqDto reqDto);
    public Task<bool> MisubkUpdateAsync(SFrm6120Dto.ReqDto reqDto);
}
