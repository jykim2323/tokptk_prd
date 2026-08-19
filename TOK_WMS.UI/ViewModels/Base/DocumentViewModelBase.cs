using CommunityToolkit.Mvvm.ComponentModel;

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
    [ObservableProperty] private bool _canClose = true;

    /// <summary>현재 활성(포커스) 문서 (AvalonDock IsActive 양방향)</summary>
    [ObservableProperty] private bool _isActive;

    /// <summary>탭 선택 여부 (AvalonDock IsSelected 양방향)</summary>
    [ObservableProperty] private bool _isSelected;

    /// <summary>
    /// 문서 유일키 — 같은 키면 중복 생성 대신 기존 탭 포커스.
    /// (AvalonDock ContentId 바인딩) 파생 ctor에서 지정.
    /// </summary>
    public string ContentId { get; protected set; } = "";


    public void Dispose() { }
}
