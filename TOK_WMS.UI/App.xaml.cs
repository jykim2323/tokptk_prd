
using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using DocumentFormat.OpenXml.Wordprocessing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualBasic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Runtime;
using System.Windows;
using TOK.WMS.Core;
using TOK.WMS.UI.Configuration;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.Api.Login;
using TOK.WMS.UI.Services.Factories;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.ViewModels;
using TOK.WMS.UI.ViewModels.Base;
using TOK.WMS.UI.ViewModels.Login;
using TOK.WMS.UI.ViewModels.MainMenus.Inbounds;
using TOK.WMS.UI.Views.Login;

namespace TOK.WMS.UI;

    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
public partial class App : Application
{
    private IServiceProvider _services = null!;
    private Process? _apiProcess;
    private static Mutex? _instanceMutex;
    private bool _ownsMutex;

    private void Application_Startup(object sender, StartupEventArgs e)
    {

        // 중복 실행 방지
        _instanceMutex = new Mutex(true, @"Global\TOK.WMS.UI.SingleInstance", out _ownsMutex);
        if (!_ownsMutex)
        {
            MessageBox.Show("메인메뉴가 이미 실행 중입니다.", "메인메뉴",
                MessageBoxButton.OK, MessageBoxImage.Information);
            Shutdown();
            return;
        }

        DispatcherUnhandledException += (s, ex) =>
        {
            MessageBox.Show($"오류가 발생했습니다.\n{ex.Exception.Message}", "메인메뉴",
                MessageBoxButton.OK, MessageBoxImage.Error);
            ex.Handled = true;
        };

        var config = new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: false)
            .Build();


        var settings = config.GetSection("Ui").Get<UiSettings>() ?? new UiSettings();

        StartApiIfNeeded(settings);

        var sc = new ServiceCollection();

        sc.AddSingleton(settings);


        sc.AddHttpClient<ILoginApi, LoginApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm3100Api, Frm3100ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));


        sc.AddSingleton<ThemeService>();
        sc.AddSingleton<IDialogService, DialogService>();
        sc.AddSingleton<ICurrentUserService, CurrentUserService>();
        sc.AddSingleton<DocumentFactory>();
        sc.AddSingleton<IExcelService, ExcelService>();


        sc.AddSingleton<MainViewModel>();
        sc.AddSingleton<MainWindow>();

        sc.AddSingleton<LoginView>();
        sc.AddSingleton<LoginViewModel>();

        // 문서(탭) VM — 메뉴키로 keyed 등록 (DocumentFactory가 키로 해석)
        sc.AddKeyedTransient<DocumentViewModelBase, HomeViewModel>(DocumentKeys.Home);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm3100ViewModel>(DocumentKeys.Frm3100);




        _services = sc.BuildServiceProvider();
        //_services.GetRequiredService<MainWindow>().Show();

        ShowLoginView();

    }

    private void ShowLoginView()
    {
        if (_services is null)
        {
            Shutdown();
            return;
        }

        LoginView loginView = _services.GetRequiredService<LoginView>();
        loginView.LoginSucceeded += ViewModel_LoginSucceeded;
        MainWindow = loginView;
        loginView.Show();
        loginView.Activate();
    }

    private void ViewModel_LoginSucceeded(object? sender, EventArgs e)
    {
        if (sender is LoginView loginView)
        {
            loginView.LoginSucceeded -= ViewModel_LoginSucceeded;
            ShowMainShell(loginView);
        }
    }

    private void ShowMainShell(Window loginView)
    {
        if (_services is null)
        {
            Shutdown();
            return;
        }

        MainWindow appShell = _services.GetRequiredService<MainWindow>();
        ShutdownMode = ShutdownMode.OnMainWindowClose;
        MainWindow = appShell;
        appShell.Show();
        appShell.Activate();
        loginView.Close();
    }

    private void StartApiIfNeeded(UiSettings settings)
    {
        if (!settings.AutoStartApi) return;

        // 1) API가 실제로 응답 중이면 그대로 사용
        if (IsApiResponding(settings.ApiBaseUrl)) return;

        // 2) 응답이 없는데 프로세스만 남아 있으면(고아) 정리 후 재기동
        foreach (var p in Process.GetProcessesByName("LSE.WMS.Api"))
        {
            try { p.Kill(entireProcessTree: true); p.WaitForExit(3000); } catch { }
        }

        var exe = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, settings.ApiExePath));
        if (!File.Exists(exe))
        {
            MessageBox.Show($"API 실행파일을 찾을 수 없습니다.\n{exe}", "LSE WMS",
                MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }

        _apiProcess = Process.Start(new ProcessStartInfo
        {
            FileName = exe,
            WorkingDirectory = Path.GetDirectoryName(exe)!,
            UseShellExecute = false,
            CreateNoWindow = true   // ← 콘솔창 생성 안 함
        });

        WaitForApi(settings.ApiBaseUrl, timeoutSeconds: 15);
    }

    private static bool IsApiResponding(string baseUrl)
    {
        try
        {
            using var http = new HttpClient { BaseAddress = new Uri(baseUrl), Timeout = TimeSpan.FromSeconds(2) };
            http.GetAsync("/").GetAwaiter().GetResult();   // 404여도 응답이면 리슨 중
            return true;
        }
        catch { return false; }
    }

    /// <summary>Api가 요청을 받을 수 있을 때까지 대기 (최초 화면의 조회 실패 방지)</summary>
    private static void WaitForApi(string baseUrl, int timeoutSeconds)
    {
        using var http = new HttpClient
        {
            BaseAddress = new Uri(baseUrl),
            Timeout =
            TimeSpan.FromSeconds(2)
        };

        var deadline = DateTime.Now.AddSeconds(timeoutSeconds);
        while (DateTime.Now < deadline)
        {
            try { http.GetAsync("/").GetAwaiter().GetResult(); return; }
            catch { Thread.Sleep(500); }
        }
    }
}

