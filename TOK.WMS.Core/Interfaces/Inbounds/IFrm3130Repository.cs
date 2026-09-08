using TOK.WMS.Core.DTOs.Inbounds;

namespace TOK.WMS.Core.Interfaces.Inbounds;

public interface IFrm3130Repository
{
    Task<IEnumerable<Frm3130Dto.ResDto>?> SearchAsync(
        Frm3130Dto.ReqDto reqDto);

    Task<Frm3130Dto.PltCheckDto?> PltCheckAsync(
        string pltNo);

    Task<Frm3130Dto.InsertResultDto> InsertAsync(
        Frm3130Dto.InsertReqDto reqDto);

    Task<Frm3130Dto.EmptyResultDto> EmptyInsertAsync(
        string pltNo,
        string userId);

    Task<int> DeleteAsync(
        Frm3130Dto.DeleteReqDto reqDto);

    Task<int> DeleteAllAsync(
        string pltNo);
}