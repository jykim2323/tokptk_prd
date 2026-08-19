using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels;

public partial class PlaceholderViewModel : DocumentViewModelBase
{
    public string MenuKey { get; }

    public PlaceholderViewModel(string menuKey, string title)
    {
        MenuKey = menuKey;
        ContentId = menuKey;
        Title = title;
    }
}
