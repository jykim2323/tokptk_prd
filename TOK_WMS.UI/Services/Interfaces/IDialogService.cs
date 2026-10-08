namespace TOK.WMS.UI.Services;

public interface IDialogService
{
    /// <summary>안내와 작업 완료를 표시합니다.</summary>
    void ShowInfo(string message, string title = "알림") => ShowMessage(message, title);

    /// <summary>입력 경고, 처리 오류, 통신 오류를 표시합니다.</summary>
    void ShowWarning(string message, string title = "경고") => ShowMessage(message, title);

    /// <summary>네를 선택한 경우만 true입니다. 아니오, ESC, 닫기는 false입니다.</summary>
    bool ShowConfirm(string message, string title = "작업 확인");

    /// <summary>네=true, 아니오=false, 취소/ESC/닫기=null인 작업 확인입니다.</summary>
    bool? ShowConfirmWithCancel(string message, string title = "작업 확인") =>
        throw new NotSupportedException("이 알림 서비스는 취소 선택을 지원하지 않습니다.");

    /// <summary>기존 화면과의 호환용입니다. 새 코드는 ShowInfo 또는 ShowWarning을 사용합니다.</summary>
    void ShowMessage(string message, string title);
}
