using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public interface IFrm1100Repository
{
    Task<IEnumerable<Frm1100Dto.ResDto>?> SearchAsync(
        Frm1100Dto.ReqDto reqDto);


    Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn1SearchAsync();

    Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn2SearchAsync();

    Task<IEnumerable<Frm1100Dto.GubnDto>?> Gubn3SearchAsync();
}