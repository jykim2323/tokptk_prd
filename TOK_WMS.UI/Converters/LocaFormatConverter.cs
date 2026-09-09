using System.Globalization;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

/// <summary>
/// LOCA 표시 변환
///
/// 01014  → 01-01-4
/// 01021  → 01-02-1
/// 010105 → 01-01-05
/// 이미 '-' 포함 → 그대로
/// </summary>
public class LocaFormatConverter : IValueConverter
{
    public object Convert(
        object value,
        Type targetType,
        object parameter,
        CultureInfo culture)
    {
        var s =
            value?.ToString()?.Trim()
            ?? string.Empty;


        if (string.IsNullOrWhiteSpace(s))
            return string.Empty;


        // 이미 포맷된 값이면 그대로
        if (s.Contains('-'))
            return s;


        // 5자리
        // 01014 → 01-01-4
        if (s.Length == 5)
        {
            return
                $"{s.Substring(0, 2)}-" +
                $"{s.Substring(2, 2)}-" +
                $"{s.Substring(4, 1)}";
        }


        // 6자리
        // 010105 → 01-01-05
        if (s.Length == 6)
        {
            return
                $"{s.Substring(0, 2)}-" +
                $"{s.Substring(2, 2)}-" +
                $"{s.Substring(4, 2)}";
        }


        return s;
    }


    public object ConvertBack(
        object value,
        Type targetType,
        object parameter,
        CultureInfo culture)
    {
        var s =
            value?.ToString()?.Trim()
            ?? string.Empty;


        return s.Replace("-", "");
    }
}