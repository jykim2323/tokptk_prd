using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.Core.Interfaces.Outbounds;

public interface IFrm4103Repository
{
    Task<IEnumerable<Frm4103Dto.ChasuDto>?> SearchChasuAsync(
        string outDate);

    Task<IEnumerable<Frm4103Dto.SummaryDto>?> SearchSummaryAsync(
        Frm4103Dto.ReqDto reqDto);

    Task<IEnumerable<Frm4103Dto.ScheduleDto>?> SearchSchedulesAsync();

    Task<int> DeleteAsync(
        Frm4103Dto.DeleteReqDto reqDto);

    Task<Frm4103Dto.ConfirmResultDto> ConfirmAsync(
        Frm4103Dto.ConfirmReqDto reqDto);
}