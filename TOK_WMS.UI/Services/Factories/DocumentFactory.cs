using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.ViewModels;
using TOK.WMS.UI.ViewModels.Base;
using Microsoft.Extensions.DependencyInjection;

namespace TOK.WMS.UI.Services.Factories;

public class DocumentFactory(IServiceProvider sp)
{
    public DocumentViewModelBase Create(MenuLeaf leaf) => Create(leaf.MenuKey, leaf.Title);

    public DocumentViewModelBase Create(string menuKey, string title = "")
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(menuKey);

        if (string.IsNullOrWhiteSpace(title))
        {
            title = menuKey == DocumentKeys.Mornitor
                ? "모니터링"
                : MenuCatalog.Groups.SelectMany(group => group.Items)
                    .FirstOrDefault(menu => menu.MenuKey == menuKey)?.Title ?? menuKey;
        }

        var document = sp.GetKeyedService<DocumentViewModelBase>(menuKey)
            ?? new PlaceholderViewModel(menuKey, title);
        document.InitializeDocument(menuKey, title);
        return document;
    }
}
