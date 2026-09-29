using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.UI.ViewModels.MainMenus.Inventory;
using TOK.WMS.UI.ViewModels.MainMenus.Monitoring.Popups;
using TOK.WMS.UI.ViewModels.MainMenus.Standards;
using TOK.WMS.UI.Views.MainMenus.Inventory;
using TOK.WMS.UI.Views.MainMenus.Standards;
using TOK.WMS.UI.Views.Monitoring.Popups;

namespace TOK.WMS.UI.Services.Interfaces.Popup;

public class WindowService : IWindowService
{
    private readonly IServiceProvider _services;
    private readonly Dictionary<string, Window> _openMonitoringPopups = new();

    public WindowService(IServiceProvider services)
    {
        _services = services;
    }

    public void ShowSFrm6110(Frm6100Dto.ResDto item)
    {
        var view = _services.GetRequiredService<SFrm6110View>();

        if (view.DataContext is SFrm6110ViewModel vm)
        {
            vm.Initialize(item);
        }

        view.Owner = Application.Current.MainWindow;
        view.WindowStartupLocation = WindowStartupLocation.CenterOwner;

        view.ShowDialog();
    }

    public void ShowSFrm6120(Frm6100Dto.SubkDto item)
    {
        var view = _services.GetRequiredService<SFrm6120View>();

        if (view.DataContext is SFrm6120ViewModel vm)
        {
            vm.Initialize(item);
        }

        view.Owner = Application.Current.MainWindow;
        view.WindowStartupLocation = WindowStartupLocation.CenterOwner;

        view.ShowDialog();
    }
    public void ShowSFrm6130(Frm6900Dto.SubkDto item)
    {
        var view = _services.GetRequiredService<SFrm6130View>();

        if (view.DataContext is SFrm6130ViewModel vm)
        {
            vm.Initialize(item);
        }

        view.Owner = Application.Current.MainWindow;
        view.WindowStartupLocation = WindowStartupLocation.CenterOwner;

        view.ShowDialog();
    }
    public void ShowSFrm6910(string leftPltno, string rightPltno)
    {
        var view = _services.GetRequiredService<SFrm6910View>();

        if (view.DataContext is SFrm6910ViewModel vm)
        {
            vm.Initialize(leftPltno, rightPltno);
        }

        view.Owner = Application.Current.MainWindow;
        view.WindowStartupLocation = WindowStartupLocation.CenterOwner;

        view.ShowDialog();
    }
    public void ShowLocaAdd(Frm6100Dto.SubkDto item)
    {
        var view = _services.GetRequiredService<LocaAddView>();

        if (view.DataContext is LocaAddViewModel vm)
        {
            vm.Initialize(item);
        }

        view.Owner = Application.Current.MainWindow;
        view.WindowStartupLocation = WindowStartupLocation.CenterOwner;

        view.ShowDialog();
    }
    public void ShowSFrm1100(SFrm1100Dto.InitDto item, string mode)
    {
        var view =
            _services.GetRequiredService<SFrm1100View>();

        if (view.DataContext is SFrm1100ViewModel vm)
        {
            vm.Initialize(
                item,
                mode);
        }

        view.Owner =
            Application.Current.MainWindow;

        view.WindowStartupLocation =
            WindowStartupLocation.CenterOwner;

        view.ShowDialog();
    }

    public MastDispDto.ResDto? ShowMastDisp(
    string searchText)
    {
        var view =
            _services.GetRequiredService<
                MastDispView>();


        if (view.DataContext is not
            MastDispViewModel vm)
        {
            return null;
        }


        vm.Initialize(
            searchText);


        view.Owner =
            Application.Current.MainWindow;


        view.WindowStartupLocation =
            WindowStartupLocation.CenterOwner;


        view.ShowDialog();


        return vm.SelectedResult;
    }

    public void ShowTrackingInfo(string trackNo)
    {
        var popupKey = $"TRACK:{trackNo}";
        if (TryActivatePopup(popupKey))
            return;

        var view = _services.GetRequiredService<TrackingInfoView>();
        if (view.DataContext is TrackingInfoViewModel vm)
            vm.Initialize(trackNo);
        ShowOwnedPopup(popupKey, view);
    }

    public void ShowStackerWork(int craneNo)
    {
        var popupKey = $"SC:{craneNo}";
        if (TryActivatePopup(popupKey))
            return;

        var view = _services.GetRequiredService<StackerWorkView>();
        if (view.DataContext is StackerWorkViewModel vm)
            vm.Initialize(craneNo);
        ShowOwnedPopup(popupKey, view);
    }

    public void ShowRackOverview(int bank, int selectedBay)
    {
        var popupKey = $"RACK:{bank}:{selectedBay}";
        if (TryActivatePopup(popupKey))
            return;

        var view = _services.GetRequiredService<RackOverviewView>();
        if (view.DataContext is RackOverviewViewModel vm)
            vm.Initialize(bank, selectedBay);
        ShowOwnedPopup(popupKey, view);
    }

    public void ShowRackCellDetail(string location)
    {
        var popupKey = $"CELL:{location}";
        if (TryActivatePopup(popupKey))
            return;

        var view = _services.GetRequiredService<RackCellDetailView>();
        if (view.DataContext is RackCellDetailViewModel vm)
            vm.Initialize(location);
        ShowOwnedPopup(popupKey, view);
    }

    private bool TryActivatePopup(string popupKey)
    {
        if (!_openMonitoringPopups.TryGetValue(popupKey, out var popup))
            return false;

        if (!popup.IsLoaded || !popup.IsVisible)
        {
            _openMonitoringPopups.Remove(popupKey);
            return false;
        }

        if (popup.WindowState == WindowState.Minimized)
            popup.WindowState = WindowState.Normal;

        popup.Activate();
        popup.Focus();
        return true;
    }

    private void ShowOwnedPopup(string popupKey, Window view)
    {
        var returnFocusWindow = Application.Current.Windows
            .OfType<Window>()
            .FirstOrDefault(window => window.IsActive && window != view);
        var mainWindow = Application.Current.MainWindow;
        var mainWindowState = mainWindow?.WindowState ?? WindowState.Normal;

        // 모든 모니터링 팝업의 Owner는 청주 소스와 동일하게 메인 창으로 고정한다.
        // 팝업끼리 Owner/Child 관계를 만들면 자식 창 종료 시 전체 창이 내려가는
        // WPF 포커스 문제가 발생할 수 있다.
        view.Owner = mainWindow;
        view.WindowStartupLocation = WindowStartupLocation.CenterOwner;

        _openMonitoringPopups[popupKey] = view;
        view.Closed += (_, _) =>
        {
            if (_openMonitoringPopups.TryGetValue(popupKey, out var current)
                && ReferenceEquals(current, view))
            {
                _openMonitoringPopups.Remove(popupKey);
            }

            view.Dispatcher.BeginInvoke(() =>
                RestoreFocus(returnFocusWindow, mainWindow, mainWindowState));
        };

        // 청주 모니터링과 동일하게 메인 화면을 막지 않는 보조 창으로 연다.
        view.Show();
    }

    private static void RestoreFocus(
        Window? preferredWindow,
        Window? mainWindow,
        WindowState mainWindowState)
    {
        var target = IsAvailable(preferredWindow)
            ? preferredWindow
            : IsAvailable(mainWindow)
                ? mainWindow
                : null;

        if (target is null)
            return;

        if (target.WindowState == WindowState.Minimized)
        {
            target.WindowState = ReferenceEquals(target, mainWindow)
                ? mainWindowState
                : WindowState.Normal;
        }

        target.Activate();
        target.Focus();
    }

    private static bool IsAvailable(Window? window) =>
        window is { IsLoaded: true, IsVisible: true };
}