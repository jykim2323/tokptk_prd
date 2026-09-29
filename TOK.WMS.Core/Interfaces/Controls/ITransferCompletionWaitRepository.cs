using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.Core.Interfaces.Controls;

public interface ITransferCompletionWaitRepository
{
    Task<IReadOnlyList<TransferCompletionWaitDto>> GetAsync(
        TransferCompletionWaitQueryDto? query = null,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// 작업 순번에 해당하는 대기 항목 한 건을 삭제한다.
    /// 이미 처리되어 존재하지 않으면 false를 반환한다.
    /// </summary>
    Task<bool> DeleteAsync(
        string sequence,
        CancellationToken cancellationToken = default);
}
