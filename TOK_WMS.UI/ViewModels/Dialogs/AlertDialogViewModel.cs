using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using TOK.WMS.UI.Models.Dialogs;

namespace TOK.WMS.UI.ViewModels.Dialogs;

public partial class AlertDialogViewModel : ObservableObject
{
    public AlertDialogViewModel(
        AlertKind kind,
        string message,
        string? title = null,
        bool allowCancel = false)
    {
        Kind = kind;
        Message = message ?? string.Empty;
        Title = string.IsNullOrWhiteSpace(title)
            ? kind switch
            {
                AlertKind.Warning => "경고",
                AlertKind.Confirmation => "작업 확인",
                _ => "알림"
            }
            : title.Trim();
        AllowCancel = IsConfirmation && allowCancel;
    }

    public AlertKind Kind { get; }
    public string Title { get; }
    public string Message { get; }
    public bool IsConfirmation => Kind == AlertKind.Confirmation;
    public bool AllowCancel { get; }
    public string PrimaryButtonText => IsConfirmation ? "네" : "확인";
    public string SecondaryButtonText => "아니오";
    public string CancelButtonText => "취소";
    public bool? Result { get; private set; }

    public event Action<bool?>? CloseRequested;

    [RelayCommand]
    private void Accept() => RequestClose(true);

    [RelayCommand]
    private void Reject() => RequestClose(false);

    [RelayCommand]
    private void Cancel() => RequestClose(AllowCancel ? null : false);

    private void RequestClose(bool? result)
    {
        Result = result;
        OnPropertyChanged(nameof(Result));
        CloseRequested?.Invoke(result);
    }
}
