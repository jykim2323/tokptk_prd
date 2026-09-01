using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

public class DateTimeFormatConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        if (value is string strDate && !string.IsNullOrWhiteSpace(strDate))
        {
            // 길이가 14자리 연월일시분초 포맷일 경우
            if (strDate.Length == 14 && DateTime.TryParseExact(strDate, "yyyyMMddHHmmss", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime parsedDate))
            {
                return parsedDate.ToString("yyyy-MM-dd HH:mm:ss");
            }

            // 길이가 8자리 연월일 포맷일 경우
            if (strDate.Length == 8 && DateTime.TryParseExact(strDate, "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime parsedDateShort))
            {
                return parsedDateShort.ToString("yyyy-MM-dd");
            }

        }

        // 형식이 맞지 않거나 null인 경우 원본 그대로 반환
        return value;
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
        return value;
    }
}
