using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

public class LocationFormatConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        var text = value?.ToString() ?? string.Empty;

        return text.Length switch
        {
            4 => $"{text[0]}-{text.Substring(1, 2)}-{text[3]}",
            5 => $"{text[0]}-{text.Substring(1, 2)}-{text.Substring(3, 2)}",
            _ => text
        };
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => Binding.DoNothing;
}