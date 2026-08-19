using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels;

public partial class HomeViewModel : DocumentViewModelBase
{
    public HomeViewModel()
    {
        Title = "Home";
        ContentId = DocumentKeys.Home;
    }

}
