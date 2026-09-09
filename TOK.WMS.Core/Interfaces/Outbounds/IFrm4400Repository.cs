using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public interface IFrm4400Repository
{
    Task<IEnumerable<Frm4400Dto.ResDto>?> SearchAsync(
        Frm4400Dto.ReqDto reqDto);


    Task<IEnumerable<Frm4400Dto.CustomerDto>?> CustomerSearchAsync();


    Task<int> DeleteAsync(
        Frm4400Dto.DeleteReqDto reqDto);
}