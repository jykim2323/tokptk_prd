namespace TOK.WMS.UI.Services;

public interface IDialogService
{
    bool ShowConfirm(string message, string title);
    void ShowMessage(string message, string title);
}
