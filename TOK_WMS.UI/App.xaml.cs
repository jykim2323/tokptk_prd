
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
using TOK.WMS.UI.Configuration;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Inbounds;
using TOK.WMS.UI.Services.Api.Inventory;
using TOK.WMS.UI.Services.Api.Login;
using TOK.WMS.UI.Services.Api.Outbounds;
using TOK.WMS.UI.Services.Factories;
using TOK.WMS.UI.Services.Interfaces;
using TOK.WMS.UI.Services.Interfaces.Popup;
using TOK.WMS.UI.ViewModels;
using TOK.WMS.UI.ViewModels.Base;
using TOK.WMS.UI.ViewModels.Login;
using TOK.WMS.UI.ViewModels.MainMenus.Inbounds;
using TOK.WMS.UI.ViewModels.MainMenus.Inventory;
using TOK.WMS.UI.ViewModels.MainMenus.Outbounds;
using TOK.WMS.UI.Views.Login;
using TOK.WMS.UI.Views.MainMenus.Inventory;

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

        //로그인
        sc.AddHttpClient<ILoginApi, LoginApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));


        // 입고관리
        sc.AddHttpClient<IFrm3100Api, Frm3100ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));//.AddHttpMessageHandler<WarehouseHeaderHandler>();
        sc.AddHttpClient<IFrm3130Api, Frm3130ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm3300Api, Frm3300ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm3400Api, Frm3400ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm3700Api, Frm3700ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm3900Api, Frm3900ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));


        // 출고관리
        sc.AddHttpClient<IFrm4100Api, Frm4100ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm4101Api, Frm4101ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm4102Api, Frm4102ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm4103Api, Frm4103ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm4300Api, Frm4300ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));

        // 재고관리
        sc.AddHttpClient<IFrm6100Api, Frm6100ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm6200Api, Frm6200ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm6300Api, Frm6300ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm6450Api, Frm6450ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm6550Api, Frm6550ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm6700Api, Frm6700ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<IFrm6900Api, Frm6900ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<ISFrm6110Api, SFrm6110ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<ISFrm6120Api, SFrm6120ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<ISFrm6130Api, SFrm6130ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<ISFrm6910Api, SFrm6910ApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));
        sc.AddHttpClient<ILocaAddApi, LocaAddApiClient>(c => c.BaseAddress = new Uri(settings.ApiBaseUrl));


        sc.AddSingleton<ThemeService>();
        sc.AddSingleton<IDialogService, DialogService>();
        sc.AddSingleton<ICurrentUserService, CurrentUserService>();
        sc.AddSingleton<DocumentFactory>();
        sc.AddSingleton<IExcelService, ExcelService>();

        //// 원료,제품, 창고 셀렉 변경 컨텍스트
        //sc.AddSingleton<IWarehouseContext, WarehouseContext>();


        sc.AddSingleton<MainViewModel>();
        sc.AddSingleton<MainWindow>();

        sc.AddSingleton<LoginView>();
        sc.AddSingleton<LoginViewModel>();


        // 문서(탭) VM — 메뉴키로 keyed 등록 (DocumentFactory가 키로 해석)


        // 원료,제품, 창고 셀렉 변경 컨텍스트 HTTP 핸들러 --> API 호출 시 헤더에 WarehouseId를 자동 추가
        //sc.AddTransient<WarehouseHeaderHandler>();

        // 모니터링
        sc.AddKeyedTransient<DocumentViewModelBase, HomeViewModel>(DocumentKeys.Home);


        // 입고관리
        sc.AddKeyedTransient<DocumentViewModelBase, Frm3100ViewModel>(DocumentKeys.Frm3100);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm3130ViewModel>(DocumentKeys.Frm3130);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm3300ViewModel>(DocumentKeys.Frm3300);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm3400ViewModel>(DocumentKeys.Frm3400);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm3700ViewModel>(DocumentKeys.Frm3700);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm3900ViewModel>(DocumentKeys.Frm3900);


        // 출고관리
        sc.AddKeyedTransient<DocumentViewModelBase, Frm4100ViewModel>(DocumentKeys.Frm4100);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm4101ViewModel>(DocumentKeys.Frm4101);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm4102ViewModel>(DocumentKeys.Frm4102);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm4103ViewModel>(DocumentKeys.Frm4103);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm4300ViewModel>(DocumentKeys.Frm4300);

        // 재고관리
        sc.AddKeyedTransient<DocumentViewModelBase, Frm6100ViewModel>(DocumentKeys.Frm6100);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm6200ViewModel>(DocumentKeys.Frm6200);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm6300ViewModel>(DocumentKeys.Frm6300);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm6450ViewModel>(DocumentKeys.Frm6450);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm6550ViewModel>(DocumentKeys.Frm6550);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm6700ViewModel>(DocumentKeys.Frm6700);
        sc.AddKeyedTransient<DocumentViewModelBase, Frm6900ViewModel>(DocumentKeys.Frm6900);

        //팝업창 관리
        sc.AddSingleton<IWindowService, WindowService>();
        sc.AddTransient<SFrm6110View>();
        sc.AddTransient<SFrm6110ViewModel>();
        sc.AddTransient<SFrm6120View>();
        sc.AddTransient<SFrm6120ViewModel>();
        sc.AddTransient<SFrm6130View>();
        sc.AddTransient<SFrm6130ViewModel>();
        sc.AddTransient<SFrm6910View>();
        sc.AddTransient<SFrm6910ViewModel>();
        sc.AddTransient<LocaAddView>();
        sc.AddTransient<LocaAddViewModel>();




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
        foreach (var p in Process.GetProcessesByName("TOK.WMS.Api"))
        {
            try { p.Kill(entireProcessTree: true); p.WaitForExit(3000); } catch { }
        }

        var exe = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, settings.ApiExePath));
        if (!File.Exists(exe))
        {
            MessageBox.Show($"API 실행파일을 찾을 수 없습니다.\n{exe}", "TOK WMS",
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

