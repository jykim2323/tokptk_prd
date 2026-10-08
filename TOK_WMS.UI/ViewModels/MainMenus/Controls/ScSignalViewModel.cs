using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;
using System.Windows.Threading;
using TOK.WMS.Core.DTOs.Controls;
using TOK.WMS.UI.Configuration;
using TOK.WMS.UI.Models.MainMenus;
using TOK.WMS.UI.Models.MainMenus.Controls;
using TOK.WMS.UI.Services;
using TOK.WMS.UI.Services.Api.Controls;
using TOK.WMS.UI.ViewModels.Base;

namespace TOK.WMS.UI.ViewModels.MainMenus.Controls;

public partial class ScSignalData : ObservableObject
{
    private readonly HashSet<string> _dirtySections = new(StringComparer.OrdinalIgnoreCase);
    private bool _isApplying;

    private static readonly string[] SendLabels =
    [
        "입고 (자동)", "출고 (자동)", "랙→랙 (자동)", "",
        "", "FROM 1열 지령", "FROM 2열 지령", "FROM 3열 지령",
        "FROM 4열 지령", "TO 1열 지령", "TO 2열 지령", "TO 3열 지령",
        "TO 4열 지령", "", "원점복귀", "RESET"
    ];

    private static readonly string[] SendCh06Labels =
    [
        "", "", "", "", "", "", "", "",
        "", "", "", "", "", "", "", "통신 상태"
    ];

    private static readonly string[][] ReceiveCh06Labels =
    [
        // SC #1
        [
            "1층 입고 스테이션 Ready", "1층 출고 스테이션 Ready", "", "",
            "", "", "", "",
            "", "", "", "",
            "", "", "", ""
        ],
        // SC #2
        [
            "1층 입고 스테이션 Ready", "1층 출고 스테이션 Ready", "", "",
            "", "", "", "",
            "2층 입고 스테이션 Ready", "2층 출고 스테이션 Ready", "", "",
            "", "", "", ""
        ],
        // SC #3
        [
            "1층 입고 스테이션 Ready", "1층 출고 스테이션 Ready", "", "",
            "", "", "", "",
            "2층 입고 스테이션 Ready", "2층 출고 스테이션 Ready", "", "",
            "", "", "", ""
        ],
        // SC #4
        [
            "1층 입고 스테이션 Ready", "1층 출고 스테이션 Ready", "", "",
            "", "", "", "",
            "2층 입고 스테이션 Ready", "2층 출고 스테이션 Ready", "", "",
            "", "", "", ""
        ],
        // SC #5
        [
            "1층 입고 스테이션 Ready", "1층 출고 스테이션 Ready", "", "",
            "", "", "", "",
            "2층 입고 스테이션 Ready", "2층 출고 스테이션 Ready", "", "",
            "", "", "", ""
        ],
        // SC #6
        [
            "1층 입고 스테이션 Ready", "1층 출고 스테이션 Ready", "", "",
            "", "", "", "",
            "2층 입고 스테이션 Ready", "2층 출고 스테이션 Ready", "", "",
            "", "", "", ""
        ],
        // SC #7
        [
            "1층 입고 스테이션 Ready", "1층 출고 스테이션 Ready", "", "",
            "", "", "", "",
            "2층 입고 스테이션 Ready", "2층 출고 스테이션 Ready", "", "",
            "", "", "", ""
        ]
    ];

    public ScSignalData(int scNo)
    {
        ScNo = scNo;
        DisplayName = $"SC #{scNo} 호기";

        var receiveLabels = BuildReceiveLabels(scNo);
        ReceiveBits = SignalBitItems.Create(receiveLabels);
        SendBits = SignalBitItems.Create(SendLabels);
        ReceiveBits06 = SignalBitItems.Create(ReceiveCh06Labels[scNo - 1]);
        SendBits06 = SignalBitItems.Create(SendCh06Labels);

        ReceiveWords =
        [
            new("CH03", "승강 단"),
            new("CH02", "주행 연"),
            new("CH04", "에러 코드")
        ];

        SendWords =
        [
            new("CH03", "FROM 승강 단"),
            new("CH02", "FROM 주행 연"),
            new("CH05", "TO 승강 단"),
            new("CH04", "TO 주행 연")
        ];

        SubscribeBits(ReceiveBits, "R_CH01", raw => ReceiveRawCh01 = raw);
        SubscribeBits(ReceiveBits06, "R_CH06", raw => ReceiveRawCh06 = raw);
        SubscribeWords(ReceiveWords, "R_WORDS");
        SubscribeBits(SendBits, "S_CH01", raw => SendRawCh01 = raw);
        SubscribeBits(SendBits06, "S_CH06", raw => SendRawCh06 = raw);
        SubscribeWords(SendWords, "S_WORDS");
    }

    public int ScNo { get; }
    public string DisplayName { get; }
    public ObservableCollection<SignalBitItem> ReceiveBits { get; }
    public ObservableCollection<SignalBitItem> SendBits { get; }
    public ObservableCollection<SignalBitItem> ReceiveBits06 { get; }
    public ObservableCollection<SignalBitItem> SendBits06 { get; }
    public ObservableCollection<SignalWordItem> ReceiveWords { get; }
    public ObservableCollection<SignalWordItem> SendWords { get; }

    [ObservableProperty] private string _receiveRawCh01 = "0000000000000000";
    [ObservableProperty] private string _sendRawCh01 = "0000000000000000";
    [ObservableProperty] private string _receiveRawCh06 = "0000000000000000";
    [ObservableProperty] private string _sendRawCh06 = "0000000000000000";

    public bool HasPendingChanges => _dirtySections.Count > 0;

    public void Apply(IReadOnlyList<ScChannelDto> channels)
    {
        var receive = channels.FirstOrDefault(channel =>
            string.Equals(channel.Sr, "R", StringComparison.OrdinalIgnoreCase));
        var send = channels.FirstOrDefault(channel =>
            string.Equals(channel.Sr, "S", StringComparison.OrdinalIgnoreCase));

        _isApplying = true;
        try
        {
            ApplyBits(receive?.Ch01, ReceiveBits, "R_CH01", raw => ReceiveRawCh01 = raw);
            ApplyBits(receive?.Ch06, ReceiveBits06, "R_CH06", raw => ReceiveRawCh06 = raw);
            ApplyWords(receive, ReceiveWords, "R_WORDS");

            ApplyBits(send?.Ch01, SendBits, "S_CH01", raw => SendRawCh01 = raw);
            ApplyBits(send?.Ch06, SendBits06, "S_CH06", raw => SendRawCh06 = raw);
            ApplyWords(send, SendWords, "S_WORDS");
        }
        finally
        {
            _isApplying = false;
        }
    }

    public void MarkSectionSaved(string section)
    {
        if (_dirtySections.Remove(section))
            OnPropertyChanged(nameof(HasPendingChanges));
    }

    public string BuildBits(string section)
        => section.ToUpperInvariant() switch
        {
            "R_CH01" => BuildBitString(ReceiveBits),
            "R_CH06" => BuildBitString(ReceiveBits06),
            "S_CH01" => BuildBitString(SendBits),
            "S_CH06" => BuildBitString(SendBits06),
            _ => throw new ArgumentException("비트 신호 영역이 아닙니다.", nameof(section))
        };

    public string GetWordValue(bool isReceive, string channel)
    {
        var words = isReceive ? ReceiveWords : SendWords;
        var word = words.FirstOrDefault(item =>
            string.Equals(item.Channel, channel, StringComparison.OrdinalIgnoreCase))
            ?? throw new InvalidOperationException($"{channel} 항목을 찾을 수 없습니다.");

        var normalized = NormalizeWord(word.Value);
        word.Value = normalized;
        return normalized;
    }

    private void ApplyBits(
        string? value,
        IReadOnlyList<SignalBitItem> bits,
        string section,
        Action<string> setRaw)
    {
        if (_dirtySections.Contains(section))
            return;

        var normalized = NormalizeBits(value);
        setRaw(normalized);
        for (var index = 0; index < bits.Count; index++)
            bits[index].IsActive = normalized[index] == '1';
    }

    private void ApplyWords(
        ScChannelDto? channel,
        IEnumerable<SignalWordItem> words,
        string section)
    {
        if (_dirtySections.Contains(section))
            return;

        foreach (var word in words)
        {
            var value = word.Channel.ToUpperInvariant() switch
            {
                "CH02" => channel?.Ch02,
                "CH03" => channel?.Ch03,
                "CH04" => channel?.Ch04,
                "CH05" => channel?.Ch05,
                _ => null
            };

            word.Value = NormalizeWord(value);
        }
    }

    private void SubscribeBits(
        IReadOnlyList<SignalBitItem> bits,
        string section,
        Action<string> setRaw)
    {
        foreach (var bit in bits)
        {
            bit.PropertyChanged += (_, args) =>
            {
                if (_isApplying || args.PropertyName != nameof(SignalBitItem.IsActive))
                    return;

                _dirtySections.Add(section);
                setRaw(BuildBitString(bits));
                OnPropertyChanged(nameof(HasPendingChanges));
            };
        }
    }

    private void SubscribeWords(IEnumerable<SignalWordItem> words, string section)
    {
        foreach (var word in words)
        {
            word.PropertyChanged += (_, args) =>
            {
                if (_isApplying || args.PropertyName != nameof(SignalWordItem.Value))
                    return;

                _dirtySections.Add(section);
                OnPropertyChanged(nameof(HasPendingChanges));
            };
        }
    }

    private static string BuildBitString(IEnumerable<SignalBitItem> bits)
        => string.Concat(bits
            .OrderBy(bit => bit.Index)
            .Select(bit => bit.IsActive ? '1' : '0'));

    private static string NormalizeBits(string? value)
    {
        var normalized = (value ?? string.Empty).Trim();
        if (normalized.Length > 16)
            normalized = normalized[..16];

        return normalized.PadRight(16, '0');
    }

    private static string NormalizeWord(string? value)
    {
        var normalized = (value ?? string.Empty).Trim();
        if (normalized.Length > 4)
            normalized = normalized[^4..];

        return normalized.PadLeft(4, '0');
    }

    private static string[] BuildReceiveLabels(int scNo)
        =>
        [
            "온라인", "자동", "수동", "지령수신 OK",
            "지령수신 대기", "작업중", "홈위치", "포크 센터",
            "팔레트 유", "Loading 완료", "UnLoading 완료", "",
            "", $"SC#{scNo} 공출고", $"SC#{scNo} 이중격납", $"SC#{scNo} 기타에러"
        ];
}

public partial class ScSignalViewModel : DocumentViewModelBase
{
    private readonly IScChannelApi _api;
    private readonly UiSettings _settings;
    private readonly IDialogService _dialog;
    private DispatcherTimer? _timer;
    private bool _isViewActive;
    private bool _refreshPending;

    public ScSignalViewModel(
        IScChannelApi api,
        UiSettings settings,
        IDialogService dialog)
    {
        _api = api;
        _settings = settings;
        _dialog = dialog;

        Cranes = new(Enumerable.Range(1, 7).Select(number => new ScSignalData(number)));
        _selectedCrane = Cranes[0];

        Title = "스태커 크레인 신호 관리";
        ContentId = DocumentKeys.Frm2400;
    }

    public ObservableCollection<ScSignalData> Cranes { get; }

    [ObservableProperty] private ScSignalData _selectedCrane;
    [ObservableProperty] private bool _isAutoRefresh = true;
    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private bool _isConnected;
    [ObservableProperty] private string _statusMessage = "조회 대기 중";
    [ObservableProperty] private string _lastUpdatedText = "-";

    partial void OnSelectedCraneChanged(ScSignalData value)
    {
        if (_isViewActive)
            _ = RefreshAsync();
    }

    partial void OnIsAutoRefreshChanged(bool value)
    {
        if (!_isViewActive)
            return;

        if (value)
            StartTimer();
        else
            StopTimer();
    }

    public async Task ActivateAsync()
    {
        _isViewActive = true;
        await RefreshAsync();

        if (IsAutoRefresh)
            StartTimer();
    }

    public void Deactivate()
    {
        _isViewActive = false;
        _refreshPending = false;
        StopTimer();
    }

    [RelayCommand]
    private Task Refresh() => RefreshAsync();

    [RelayCommand]
    private async Task SaveChannel(string? section)
    {
        var normalizedSection = (section ?? string.Empty).Trim().ToUpperInvariant();
        var requestedCrane = SelectedCrane;

        if (!_dialog.ShowConfirm("정말로 수정 하시겠습니까?", "확인"))
        {
            StatusMessage = "수정을 취소했습니다.";
            return;
        }

        (string sr, ScChannelUpdateGroup group, ScChannelUpdateDto values) update;
        try
        {
            update = CreateUpdateRequest(requestedCrane, normalizedSection);
        }
        catch (Exception ex)
        {
            StatusMessage = $"수정할 값 확인 실패: {ex.Message}";
            _dialog.ShowWarning(StatusMessage, "오류");
            return;
        }

        IsBusy = true;
        try
        {
            await _api.UpdateChannelGroupAsync(
                requestedCrane.ScNo,
                update.sr,
                update.group,
                update.values);

            requestedCrane.MarkSectionSaved(normalizedSection);
            IsConnected = true;
            LastUpdatedText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            StatusMessage = $"{requestedCrane.ScNo}호기 {GetSectionName(normalizedSection)} 수정 완료";

            try
            {
                var channels = await _api.GetChannelsAsync(requestedCrane.ScNo);
                requestedCrane.Apply(channels);
            }
            catch (Exception ex)
            {
                StatusMessage = $"{requestedCrane.ScNo}호기 수정 완료 (재조회 실패: {ex.Message})";
                _dialog.ShowWarning(StatusMessage, "오류");
            }
        }
        catch (Exception ex)
        {
            IsConnected = false;
            StatusMessage = $"수정 실패: {ex.Message}";
            _dialog.ShowWarning(StatusMessage, "오류");
        }
        finally
        {
            IsBusy = false;
        }

        if (_isViewActive && _refreshPending)
        {
            _refreshPending = false;
            await RefreshAsync();
        }
    }

    private async Task RefreshAsync()
    {
        if (IsBusy)
        {
            _refreshPending = true;
            return;
        }

        var requestedCrane = SelectedCrane;
        IsBusy = true;
        try
        {
            var channels = await _api.GetChannelsAsync(requestedCrane.ScNo);
            requestedCrane.Apply(channels);

            if (ReferenceEquals(SelectedCrane, requestedCrane))
            {
                IsConnected = true;
                LastUpdatedText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                StatusMessage = requestedCrane.HasPendingChanges
                    ? $"{requestedCrane.ScNo}호기 신호 수신 (미저장 수정값 유지 중)"
                    : $"{requestedCrane.ScNo}호기 신호 정상 수신";
            }
        }
        catch (Exception ex)
        {
            if (ReferenceEquals(SelectedCrane, requestedCrane))
            {
                IsConnected = false;
                StatusMessage = $"조회 실패: {ex.Message}";
            }
        }
        finally
        {
            IsBusy = false;
        }

        if (_isViewActive && _refreshPending)
        {
            _refreshPending = false;
            await RefreshAsync();
        }
    }

    private static (string Sr, ScChannelUpdateGroup Group, ScChannelUpdateDto Values)
        CreateUpdateRequest(ScSignalData crane, string section)
        => section switch
        {
            "R_CH01" => ("R", ScChannelUpdateGroup.Ch01, new ScChannelUpdateDto
            {
                Ch01 = crane.BuildBits(section)
            }),
            "R_CH06" => ("R", ScChannelUpdateGroup.Ch06, new ScChannelUpdateDto
            {
                Ch06 = crane.BuildBits(section)
            }),
            "R_WORDS" => ("R", ScChannelUpdateGroup.Words, new ScChannelUpdateDto
            {
                Ch02 = crane.GetWordValue(true, "CH02"),
                Ch03 = crane.GetWordValue(true, "CH03"),
                Ch04 = crane.GetWordValue(true, "CH04")
            }),
            "S_CH01" => ("S", ScChannelUpdateGroup.Ch01, new ScChannelUpdateDto
            {
                Ch01 = crane.BuildBits(section)
            }),
            "S_CH06" => ("S", ScChannelUpdateGroup.Ch06, new ScChannelUpdateDto
            {
                Ch06 = crane.BuildBits(section)
            }),
            "S_WORDS" => ("S", ScChannelUpdateGroup.Words, new ScChannelUpdateDto
            {
                Ch02 = crane.GetWordValue(false, "CH02"),
                Ch03 = crane.GetWordValue(false, "CH03"),
                Ch04 = crane.GetWordValue(false, "CH04"),
                Ch05 = crane.GetWordValue(false, "CH05")
            }),
            _ => throw new ArgumentException("지원하지 않는 신호 수정 영역입니다.", nameof(section))
        };

    private static string GetSectionName(string section)
        => section switch
        {
            "R_CH01" => "수신 상태 비트",
            "R_CH06" => "수신 Ready 신호",
            "R_WORDS" => "수신 위치·에러 값",
            "S_CH01" => "송신 명령 비트",
            "S_CH06" => "송신 통신 상태",
            "S_WORDS" => "송신 FROM·TO 값",
            _ => "신호"
        };

    private void StartTimer()
    {
        if (_timer is not null)
            return;

        _timer = new DispatcherTimer
        {
            Interval = TimeSpan.FromMilliseconds(Math.Max(500, _settings.SignalPollMs))
        };
        _timer.Tick += OnTimerTick;
        _timer.Start();
    }

    private void StopTimer()
    {
        if (_timer is null)
            return;

        _timer.Tick -= OnTimerTick;
        _timer.Stop();
        _timer = null;
    }

    private async void OnTimerTick(object? sender, EventArgs e)
        => await RefreshAsync();

    public override void Dispose()
        => Deactivate();
}
