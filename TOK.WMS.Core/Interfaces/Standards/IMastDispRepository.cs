using TOK.WMS.Core.DTOs.Standards;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public interface IMastDispRepository
{
    Task<IEnumerable<MastDispDto.ResDto>?> SearchAsync(
        MastDispDto.ReqDto reqDto);


    Task<IEnumerable<MastDispDto.ResDto>?> AllSearchAsync();
}