using CommunityToolkit.Mvvm.ComponentModel;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Collections.ObjectModel;

namespace TOK.WMS.UI.Models.MainMenus.Controls;

/// <summary>
/// SC와 컨베이어가 공통으로 사용하는 16 BIT 항목 생성 규칙.
/// 화면별 ViewModel은 BIT00부터 BIT15까지의 라벨만 순서대로 전달한다.
/// </summary>
public static class SignalBitItems
{
    public const int Count = 16;

    public static ObservableCollection<SignalBitItem> Create(
        IReadOnlyList<string> labels)
    {
        ArgumentNullException.ThrowIfNull(labels);

        if (labels.Count > Count)
        {
            throw new ArgumentException(
                $"16 BIT 라벨은 최대 {Count}개까지 입력할 수 있습니다.",
                nameof(labels));
        }

        return new(Enumerable.Range(0, Count)
            .Select(index => new SignalBitItem(
                index,
                index < labels.Count ? labels[index] : string.Empty)));
    }
}

/// <summary>PLC CH01의 단일 비트 표시 항목.</summary>
public partial class SignalBitItem(int index, string label) : ObservableObject
{
    public int Index { get; } = index;
    public string DisplayIndex { get; } = $"BIT {index:00}";
    public string Label { get; } = label?.Trim() ?? string.Empty;
    public int LayoutRow => Index % 8;
    public int LayoutColumn => Index / 8;

    [ObservableProperty]
    private bool _isActive;

    public string ValueText => IsActive ? "1" : "0";

    partial void OnIsActiveChanged(bool value)
        => OnPropertyChanged(nameof(ValueText));
}

/// <summary>PLC CH02~CH05의 4자리 값 표시 및 수정 항목.</summary>
public partial class SignalWordItem(string channel, string description) : ObservableObject
{
    public string Channel { get; } = channel;
    public string Description { get; } = description;

    [ObservableProperty]
    private string _value = "0000";
}
