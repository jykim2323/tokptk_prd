using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public interface ISFrm1100Repository
{
    Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn1SearchAsync();

    Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn2SearchAsync();

    Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn3SearchAsync();


    Task<int> InsertAsync(
        SFrm1100Dto.ReqDto reqDto);


    Task<int> UpdateAsync(
        SFrm1100Dto.ReqDto reqDto);


    Task<int> DeleteAsync(
        SFrm1100Dto.DeleteReqDto reqDto);
}