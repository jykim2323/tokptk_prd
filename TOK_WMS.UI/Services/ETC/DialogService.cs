using System.Windows;

using System.Windows.Input;
using TOK.WMS.UI.Models.Dialogs;
using TOK.WMS.UI.ViewModels.Dialogs;
using TOK.WMS.UI.Views.Dialogs;

namespace TOK.WMS.UI.Services.ETC;

public class DialogService : IDialogService
{
    public void ShowInfo(string message, string title = "알림") =>
        Show(AlertKind.Information, message, title);

    public void ShowWarning(string message, string title = "경고") =>
        Show(AlertKind.Warning, message, title);

    public bool ShowConfirm(string message, string title = "작업 확인") =>
        Show(AlertKind.Confirmation, message, title) == true;

    public bool? ShowConfirmWithCancel(string message, string title = "작업 확인") =>
        Show(AlertKind.Confirmation, message, title, allowCancel: true);

    public void ShowMessage(string message, string title)
    {
        // 기존 호출은 중앙에서 호환하고, 새 호출의 종류는 명시적으로 선택한다.
        var isWarning = title?.Contains("오류", StringComparison.Ordinal) == true
            || title?.Contains("경고", StringComparison.Ordinal) == true
            || title?.Contains("실패", StringComparison.Ordinal) == true
            || title is "입력 확인" or "권한 확인" or "이동 구간 확인";

        Show(isWarning ? AlertKind.Warning : AlertKind.Information, message, title);
    }

    private bool? Show(AlertKind kind, string message, string? title, bool allowCancel = false)
    {
        var app = Application.Current
            ?? throw new InvalidOperationException("알림은 WPF 앱이 실행 중일 때 사용할 수 있습니다.");

        bool? Display() => ShowDialog(new AlertDialogViewModel(kind, message, title, allowCancel));

        // ViewModel의 백그라운드 작업에서도 항상 앱의 UI 스레드에 창을 만든다.
        return app.Dispatcher.CheckAccess()
            ? Display()
            : app.Dispatcher.Invoke(Display);
    }

    protected virtual bool? ShowDialog(AlertDialogViewModel viewModel)
    {
        var app = Application.Current;
        var owner = GetActiveWindow();
        var focusedElement = Keyboard.FocusedElement as UIElement;
        var previousMainWindow = app.MainWindow;
        var previousShutdownMode = app.ShutdownMode;
        var beforeFirstWindow = previousMainWindow is null;

        // 로그인 전 첫 WPF 창이 알림이면 닫는 즉시 앱이 종료되지 않도록 한다.
        if (beforeFirstWindow)
            app.ShutdownMode = ShutdownMode.OnExplicitShutdown;

        try
        {
            var dialog = new AlertDialogWindow(viewModel)
            {
                Owner = owner,
                WindowStartupLocation = owner is null
                    ? WindowStartupLocation.CenterScreen
                    : WindowStartupLocation.CenterOwner
            };
            dialog.ShowDialog();
            return viewModel.Result;
        }
        finally
        {
            if (beforeFirstWindow)
            {
                if (app.MainWindow is AlertDialogWindow)
                    app.MainWindow = previousMainWindow;
                app.ShutdownMode = previousShutdownMode;
            }

            // 스캐너 입력 등 알림 전에 사용하던 컨트롤로 돌아간다.
            if (owner?.IsActive == true
                && focusedElement is { IsVisible: true, IsEnabled: true, Focusable: true }
                && Window.GetWindow(focusedElement) == owner)
            {
                focusedElement.Focus();
            }
        }
    }

    private static Window? GetActiveWindow()
    {
        var windows = Application.Current.Windows
            .OfType<Window>()
            .Where(w => w.IsVisible && w.GetType().Assembly == typeof(App).Assembly)
            .ToList();

        return windows.FirstOrDefault(w => w.IsActive)
            ?? windows.FirstOrDefault(w => w != Application.Current.MainWindow)
            ?? windows.FirstOrDefault(w => w == Application.Current.MainWindow);
    }
}

