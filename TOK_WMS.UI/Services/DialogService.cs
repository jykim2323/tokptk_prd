using System.Windows;

namespace TOK.WMS.UI.Services;

public class DialogService : IDialogService
{
    public bool ShowConfirm(string m, string t) =>
         MessageBox.Show(
         Application.Current.MainWindow,
         m,
         t,
         MessageBoxButton.YesNo,
         MessageBoxImage.Question) == MessageBoxResult.Yes;

    public void ShowMessage(string m, string t) =>
         MessageBox.Show(
         Application.Current.MainWindow,
         m,
         t,
         MessageBoxButton.OK,
         MessageBoxImage.Information);
}

