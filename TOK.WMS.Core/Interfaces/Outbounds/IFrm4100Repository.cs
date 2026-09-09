using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public interface IFrm4100Repository
{
    Task<IEnumerable<Frm4100Dto.StockDto>?> SearchAsync(
        Frm4100Dto.ReqDto reqDto);


    Task<IEnumerable<Frm4100Dto.PalletItemDto>?> PalletSearchAsync(
        string loca);


    Task<Frm4100Dto.StationStatusDto?> StationStatusAsync(
        string loca);


    Task<Frm4100Dto.ReserveResultDto> ReserveAsync(
        Frm4100Dto.ReserveReqDto reqDto);


    Task<Frm4100Dto.DirectOutputResultDto> DirectOutputAsync(
        Frm4100Dto.DirectOutputReqDto reqDto);
}