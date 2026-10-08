using CommunityToolkit.Mvvm.ComponentModel;

using CommunityToolkit.Mvvm.Input;

namespace TOK.WMS.UI.ViewModels.Base;

/// <summary>
/// AvalonDock 문서(탭) 1개에 대응하는 VM 베이스.
/// 기존 화면 VM(MonitorViewModel 등)이 이 클래스를 상속한다.
/// </summary>

public abstract partial class DocumentViewModelBase : ObservableObject, IDisposable
{
    /// <summary>탭 헤더 텍스트 (AvalonDock Title 바인딩)</summary>
    [ObservableProperty] private string _title = "";

    /// <summary>탭 아이콘(이모지/문자). 선택.</summary>
    [ObservableProperty] private string _iconKey = "";

    /// <summary>닫기 버튼 노출 여부 (AvalonDock CanClose 바인딩)</summary>
    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(CloseCommand))]
    private bool _canClose = true;

    /// <summary>현재 활성(포커스) 문서 (AvalonDock IsActive 양방향)</summary>
    [ObservableProperty] private bool _isActive;

    /// <summary>탭 선택 여부 (AvalonDock IsSelected 양방향)</summary>
    [ObservableProperty] private bool _isSelected;

    /// <summary>
    /// 문서 유일키 — 같은 키면 중복 생성 대신 기존 탭 포커스.
    /// (AvalonDock ContentId 바인딩) 문서 팩토리에서 메뉴 키로 확정.
    /// </summary>
    public string ContentId { get; protected set; } = "";

    public event EventHandler? CloseRequested;

    internal void InitializeDocument(string contentId, string title)
    {
        ContentId = contentId;
        if (string.IsNullOrWhiteSpace(Title))
            Title = title;
    }

    /// <summary>현재 문서 탭의 닫기를 요청합니다.</summary>
    [RelayCommand(CanExecute = nameof(CanClose))]
    private void Close() => CloseRequested?.Invoke(this, EventArgs.Empty);

    public virtual void Dispose() { }
}
