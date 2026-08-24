using System.Globalization;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

/// <summary>LSTK_FLAG 코드 → 한글 표기</summary>
public class LstkFlagConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => (value as string) switch
        {
            "0" => "빈셀",
            "1" => "제품유",
            "X" => "입고예약",
            "Y" => "출고예약",
            "D" => "이중격납",
            "E" => "공출고",
            "N" => "금지셀",
            _ => value?.ToString() ?? ""
        };

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotImplementedException();
}
