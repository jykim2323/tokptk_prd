using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.UI.ViewModels.MainMenus.Inventory;
using TOK.WMS.UI.Views.MainMenus.Inventory;

namespace TOK.WMS.UI.Services.Interfaces.Popup;

public class WindowService : IWindowService
{
    private readonly IServiceProvider _services;

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
}