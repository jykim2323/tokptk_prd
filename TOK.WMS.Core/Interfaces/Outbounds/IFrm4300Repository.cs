using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public interface IFrm4300Repository
{
    Task<IEnumerable<Frm4300Dto.ResDto>?> SearchAsync(
        Frm4300Dto.ReqDto reqDto);


    Task<int> DeleteAsync(
        Frm4300Dto.DeleteReqDto reqDto);


    Task<int> PendingCountAsync(
        string pltNo);


    Task<Frm4300Dto.CompleteResultDto> CompleteAsync(
        Frm4300Dto.CompleteReqDto reqDto);
}