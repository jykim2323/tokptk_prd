using TOK.WMS.UI.Services.ETC;

namespace TOK.WMS.UI.Services;

/// <summary>
/// View의 코드 비하인드에서 사용하는 공통 알림 진입점입니다.
/// ViewModel에서는 테스트 대체가 가능한 IDialogService를 주입받습니다.
/// </summary>
public static class Alert
{
    internal static IDialogService Service { get; } = new DialogService();

    public static void ShowInfo(string message, string title = "알림") =>
        Service.ShowInfo(message, title);

    public static void ShowWarning(string message, string title = "경고") =>
        Service.ShowWarning(message, title);

    public static bool ShowConfirm(string message, string title = "작업 확인") =>
        Service.ShowConfirm(message, title);

    public static bool? ShowConfirmWithCancel(string message, string title = "작업 확인") =>
        Service.ShowConfirmWithCancel(message, title);
}
