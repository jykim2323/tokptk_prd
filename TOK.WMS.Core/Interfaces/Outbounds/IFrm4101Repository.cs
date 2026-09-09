using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.Core.Interfaces.Outbounds;

public interface IFrm4101Repository
{
    Task<Frm4101Dto.SaveResultDto> SaveAsync(
        Frm4101Dto.SaveReqDto reqDto);
}