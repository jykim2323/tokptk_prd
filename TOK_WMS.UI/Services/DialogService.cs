using System.Windows;

namespace TOK.WMS.UI.Services;

public class DialogService : IDialogService
{
    public bool ShowConfirm(string m, string t) =>
         MessageBox.Show(
         GetActiveWindow(),
         m,
         t,
         MessageBoxButton.YesNo,
         MessageBoxImage.Question) == MessageBoxResult.Yes;

    public void ShowMessage(string m, string t) =>
         MessageBox.Show(
         GetActiveWindow(),
         m,
         t,
         MessageBoxButton.OK,
         MessageBoxImage.Information);

    private static Window? GetActiveWindow()
    {
        var windows = Application.Current.Windows
       .OfType<Window>()
       .Where(w => w.GetType().Assembly == typeof(App).Assembly)
       .ToList();

        return windows.FirstOrDefault(w => w.IsActive)
            ?? windows.FirstOrDefault(w =>
                w != Application.Current.MainWindow &&
                w.IsVisible)
            ?? Application.Current.MainWindow;
    }
}

