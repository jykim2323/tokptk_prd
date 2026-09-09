using System.Globalization;
using System.Windows.Data;

namespace TOK.WMS.UI.Converters;

public class DateTimeFormatConverter : IValueConverter
{
    public object Convert(
        object value,
        Type targetType,
        object parameter,
        CultureInfo culture)
    {
        if (value is not string strDate ||
            string.IsNullOrWhiteSpace(strDate))
        {
            return value;
        }


        strDate =
            strDate.Trim();


        // =====================================================
        // yyyyMMddHHmmss
        // =====================================================

        if (strDate.Length == 14 &&
            DateTime.TryParseExact(
                strDate,
                "yyyyMMddHHmmss",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out var fullDateTime))
        {
            return fullDateTime.ToString(
                "yyyy-MM-dd HH:mm:ss");
        }


        // =====================================================
        // yyyyMMdd
        // =====================================================

        if (strDate.Length == 8 &&
            DateTime.TryParseExact(
                strDate,
                "yyyyMMdd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out var date))
        {
            return date.ToString(
                "yyyy-MM-dd");
        }


        // =====================================================
        // HHmmss
        // =====================================================

        if (strDate.Length == 6 &&
            DateTime.TryParseExact(
                strDate,
                "HHmmss",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out var time))
        {
            return time.ToString(
                "HH:mm:ss");
        }


        return value;
    }


    public object ConvertBack(
        object value,
        Type targetType,
        object parameter,
        CultureInfo culture)
    {
        return value;
    }
}