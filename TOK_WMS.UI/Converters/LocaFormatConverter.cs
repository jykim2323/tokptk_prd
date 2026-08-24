using System.Globalization;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

/// <summary>LOCA 6자리 → 00-00-00 표시</summary>
public class LocaFormatConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        var s = (value as string)?.Trim() ?? "";
        return s.Length == 6 ? $"{s.Substring(0, 2)}-{s.Substring(2, 2)}-{s.Substring(4, 2)}" : s;
    }
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotImplementedException();
}
