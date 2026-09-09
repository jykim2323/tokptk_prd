using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public interface IFrm4500Repository
{
    Task<IEnumerable<Frm4500Dto.ItemSummaryDto>?> SearchAsync(
        Frm4500Dto.ReqDto reqDto);


    Task<IEnumerable<Frm4500Dto.LotSummaryDto>?> LotSearchAsync(
        Frm4500Dto.LotReqDto reqDto);
}