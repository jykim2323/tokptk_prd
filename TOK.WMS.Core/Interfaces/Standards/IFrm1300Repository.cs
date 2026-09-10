using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public interface IFrm1300Repository
{
    Task<IEnumerable<Frm1300Dto.ResDto>?> SearchAsync(
        Frm1300Dto.ReqDto reqDto);


    Task<IEnumerable<Frm1300Dto.ResDto>?> AllSearchAsync();


    Task<bool> DuplicateCheckAsync(
        Frm1300Dto.DuplicateReqDto reqDto);


    Task<int> InsertAsync(
        Frm1300Dto.SaveReqDto reqDto);


    Task<int> UpdateAsync(
        Frm1300Dto.SaveReqDto reqDto);


    Task<int> DeleteAsync(
        Frm1300Dto.DeleteReqDto reqDto);
}