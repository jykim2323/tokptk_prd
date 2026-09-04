using System.Globalization;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

/// <summary>SUBK_FLAG 코드 → 표시 (1=적재중, 0=공백)</summary>
public class SubkFlagInvetoryConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => (value as string) switch
        {
            "1" => "입고완료",
            "Y" => "Y",
            "N" => "금지",
            "0" => "바닥재고",
            "I" => "I",
            "R" => "재입고대기",
            _ => value?.ToString() ?? ""
        };

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotImplementedException();
}
