using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

public class StokWhFlagConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => (value as string) switch
        {
            "A" => "창고A",
            "B" => "창고B",
            "W" => "외부동",
            "S" => "생산동",
            _ => value?.ToString() ?? ""
        };

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotImplementedException();
}
