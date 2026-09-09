using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.Core.Interfaces.Outbounds;

public interface IFrm4102Repository
{
    Task<IEnumerable<Frm4102Dto.ResDto>?> SearchAsync(
        Frm4102Dto.ReqDto reqDto);

    Task<Frm4102Dto.ReserveResultDto> ReserveAsync(
        Frm4102Dto.ReserveReqDto reqDto);

    Task<int> DeleteAsync(
        Frm4102Dto.DeleteReqDto reqDto);

    Task<int> DeleteAllAsync();
}