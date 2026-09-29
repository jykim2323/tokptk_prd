using TOK.WMS.Core.DTOs.Controls;

namespace TOK.WMS.Core.Interfaces.Controls;

public interface IScChannelRepository
{
    Task<IReadOnlyList<ScChannelDto>> GetChannelsAsync(int scNo);

    Task UpdateChannelGroupAsync(
        int scNo,
        string sr,
        ScChannelUpdateGroup group,
        ScChannelUpdateDto values);
}
