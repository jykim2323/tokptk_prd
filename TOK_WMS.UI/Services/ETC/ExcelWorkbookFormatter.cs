using System.Globalization;
using ClosedXML.Excel;
using System.Windows;

namespace TOK.WMS.UI.Services.ETC;

/// <summary>표 제목이나 장식 없이 표시 열·데이터와 필터·값 형식만 출력합니다.</summary>
internal static class ExcelWorkbookFormatter
{
    private const int HeaderRow = 1;

    public static XLWorkbook Create(ExcelExportSnapshot snapshot, string sheetName)
    {
        if (snapshot.Columns.Count == 0)
            throw new InvalidOperationException("엑셀로 저장할 표시 열이 없습니다.");
        if (snapshot.Rows.Count > 1_048_576 - HeaderRow)
            throw new InvalidOperationException("엑셀 한 시트에 저장할 수 있는 행 수를 초과했습니다.");

        var workbook = new XLWorkbook();
        try
        {
            var sheet = workbook.Worksheets.Add(SafeSheetName(sheetName));
            var lastRow = HeaderRow + snapshot.Rows.Count;
            var lastColumn = snapshot.Columns.Count;

            var widths = snapshot.Columns.Select(column => Math.Max(column.SuggestedWidth, TextWidth(column.Header) + 4)).ToArray();
            for (var columnIndex = 0; columnIndex < lastColumn; columnIndex++)
                sheet.Cell(HeaderRow, columnIndex + 1).Value = snapshot.Columns[columnIndex].Header;

            var textLengths = new double[snapshot.Rows.Count, lastColumn];
            for (var rowIndex = 0; rowIndex < snapshot.Rows.Count; rowIndex++)
            {
                var rowNumber = HeaderRow + rowIndex + 1;
                for (var columnIndex = 0; columnIndex < lastColumn; columnIndex++)
                {
                    var column = snapshot.Columns[columnIndex];
                    var cell = sheet.Cell(rowNumber, columnIndex + 1);
                    var value = snapshot.Rows[rowIndex][columnIndex];
                    WriteValue(cell, value, column);
                    var display = cell.GetFormattedString(CultureInfo.CurrentCulture);
                    textLengths[rowIndex, columnIndex] = TextWidth(display);
                    if (rowIndex < 500)
                        widths[columnIndex] = Math.Max(widths[columnIndex], Math.Min(48, TextWidth(display) + 3));
                }
            }

            for (var columnIndex = 0; columnIndex < lastColumn; columnIndex++)
            {
                widths[columnIndex] = Math.Clamp(widths[columnIndex], 10, 48);
                sheet.Column(columnIndex + 1).Width = widths[columnIndex];
                for (var rowIndex = 0; rowIndex < snapshot.Rows.Count; rowIndex++)
                {
                    var cell = sheet.Cell(HeaderRow + rowIndex + 1, columnIndex + 1);
                    if (textLengths[rowIndex, columnIndex] <= widths[columnIndex] - 2 && !cell.GetString().Contains('\n'))
                        continue;
                    cell.Style.Alignment.WrapText = true;
                    var lines = Math.Max(cell.GetString().Split('\n').Length,
                        (int)Math.Ceiling(textLengths[rowIndex, columnIndex] / (widths[columnIndex] - 2)));
                    sheet.Row(cell.Address.RowNumber).Height = Math.Max(sheet.Row(cell.Address.RowNumber).Height,
                        Math.Clamp(lines * sheet.RowHeight, sheet.RowHeight, 409));
                }
            }

            sheet.Range(HeaderRow, 1, lastRow, lastColumn).SetAutoFilter();
            sheet.SheetView.FreezeRows(HeaderRow);
            return workbook;
        }
        catch
        {
            workbook.Dispose();
            throw;
        }
    }

    private static void WriteValue(IXLCell cell, object? value, ExcelExportColumn column)
    {
        if (value is null || value == DependencyProperty.UnsetValue || value == System.Windows.Data.Binding.DoNothing)
            return;
        if (value is string text)
        {
            if (column.IsTime && TimeSpan.TryParseExact(text.Trim(), ["hhmmss", "hh\\:mm\\:ss"], CultureInfo.InvariantCulture, out var time))
            {
                cell.Value = time;
                cell.Style.NumberFormat.Format = "hh:mm:ss";
                return;
            }
            if (column.IsDate && DateTime.TryParseExact(text.Trim(),
                ["yyyyMMddHHmmss", "yyyy-MM-dd HH:mm:ss", "yyyyMMdd", "yyyy-MM-dd", "yyyy/MM/dd"],
                CultureInfo.InvariantCulture, DateTimeStyles.None, out var date) && date.Year >= 1900)
            {
                cell.Value = date;
                cell.Style.NumberFormat.Format = text.Trim().Length is 8 or 10 ? "yyyy-mm-dd" : "yyyy-mm-dd hh:mm:ss";
                return;
            }
            // Identifiers (PLT, LOT, item codes and indexes) remain text, including leading zeros.
            cell.Value = text;
            cell.Style.NumberFormat.Format = "@";
            return;
        }

        cell.Value = XLCellValue.FromObject(value, CultureInfo.InvariantCulture);
        switch (value)
        {
            case DateTime:
                cell.Style.NumberFormat.Format = column.IsTime ? "hh:mm:ss" : column.IsDate ? "yyyy-mm-dd" : "yyyy-mm-dd hh:mm:ss";
                break;
            case TimeSpan:
                cell.Style.NumberFormat.Format = "hh:mm:ss";
                break;
            case byte or sbyte or short or ushort or int or uint or long or ulong:
                cell.Style.NumberFormat.Format = column.NumberFormat ?? "#,##0";
                break;
            case float or double or decimal:
                cell.Style.NumberFormat.Format = column.NumberFormat ?? "#,##0.##";
                break;
        }
    }

    private static double TextWidth(string text) => text.Split('\n').Max(line => line.Sum(character => character >= 0x2E80 ? 2.0 : 1.0));

    private static string SafeSheetName(string name)
    {
        var cleaned = string.Concat(name.Where(character => !"\\/?*[]:".Contains(character))).Trim().Trim('\'');
        if (string.IsNullOrWhiteSpace(cleaned))
            return "데이터";
        return cleaned[..Math.Min(cleaned.Length, 31)];
    }
}
