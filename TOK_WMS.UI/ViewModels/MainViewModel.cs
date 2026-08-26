using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Threading;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Factories;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels.Base;
using TOK.WMS.UI.ViewModels.Base.Interfaces;

namespace TOK.WMS.UI.ViewModels;

public partial class MainViewModel : ObservableObject
{
    private readonly DocumentFactory _factory;
    private readonly ThemeService _theme;
    private readonly IDialogService _dialog;


    private readonly Dispatcher _ui = Application.Current.Dispatcher;



    [ObservableProperty] private string _connectionStatus = "연결 중...";
    [ObservableProperty] private bool _isConnected = false;

    [ObservableProperty] private ObservableCollection<DocumentViewModelBase> _documents = [];
    [ObservableProperty] private DocumentViewModelBase? _activeDocument;

    //[ObservableProperty] private ObservableCollection<ToastItem> _toasts = [];

    [ObservableProperty] private bool _isMenuExpanded = true;   // 사이드바 열림=true → 서브메뉴 펼침

    /// <summary>사이드바 데이터 기반 메뉴</summary>
    public IReadOnlyList<MenuGroup> MenuGroups => MenuCatalog.Groups;

 

    //[RelayCommand]
    //private void SelectRawWarehouse()
    //{
    //    if (Documents.Any()) 
    //    {
    //        _dialog.ShowMessage("창을 모두 닫은 후 창을 선택해주세요.", "창이 열려있습니다.");
    //        return;
    //    }
    //    _warehouseContext.SelectedWarehouse = WarehouseType.Raw;
    //    SelectedWarehouse = WarehouseType.Raw;
    //}

    //[RelayCommand]
    //private void SelectProductWarehouse()
    //{
    //    if (Documents.Any())
    //    {
    //        _dialog.ShowMessage("창을 모두 닫은 후 창을 선택해주세요.", "창이 열려있습니다.");
    //        return;
    //    }
    //    _warehouseContext.SelectedWarehouse = WarehouseType.Product;
    //    SelectedWarehouse = WarehouseType.Product;
    //}

    [ObservableProperty]
    private WarehouseType selectedWarehouse = WarehouseType.Raw;

    public MainViewModel(DocumentFactory factory, ThemeService theme, IDialogService dialog)
    {
        _factory = factory;
        _theme = theme;
        _dialog = dialog;

        OpenDocument(DocumentKeys.Home);

    }

    // ── 로고 클릭: 모니터링 열기/포커스 + 새로고침 ──
    [RelayCommand]
    private void OpenHome()
    {
        OpenDocument(DocumentKeys.Home); // 없으면 생성, 있으면 포커스(ActiveDocument 설정)
        (ActiveDocument as IRefreshable)?.Refresh();    // 모니터면 즉시 새로고침
    }

    // ── 문서(탭) 열기: 같은 키면 새로 안 만들고 포커스 ──
    [RelayCommand]
    private void OpenDocument(string menuKey)
    {
        var existing = Documents.FirstOrDefault(d => d.ContentId == menuKey);
        if (existing != null) { ActiveDocument = existing; return; }

        var doc = _factory.Create(menuKey);
        Documents.Add(doc);
        ActiveDocument = doc;
    }

    /// <summary>탭이 닫힐 때 호출 — 컬렉션에서 제거 후 정리(구독/타이머 해제)</summary>
    public void CloseDocument(DocumentViewModelBase doc)
    {
        if (doc == null) return;
        Documents.Remove(doc);
        doc.Dispose();
    }

    // ── 다크/라이트 테마 토글 ─────────────────────────────────────────
    [RelayCommand]
    private void ToggleTheme() => _theme.Toggle();

    private void OnUi(Action action)
    {
        var d = _ui;
        if (d.HasShutdownStarted || d.HasShutdownFinished) return;
        try { d.Invoke(action); }
        catch (TaskCanceledException) { }
    }

}
