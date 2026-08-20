using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

public class LstkStatusConverter : IValueConverter
{

    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        return value?.ToString() switch
        {
            "X" => "입고",
            "1" => "제품유",
            "0" => "빈셀",
            "N" => "금지",
            "W" => "이중",
            "E" => "공출",
            _ => value?.ToString() ?? string.Empty
        };
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => Binding.DoNothing;

}
