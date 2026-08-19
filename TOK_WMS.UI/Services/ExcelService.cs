using ClosedXML.Excel;
using DocumentFormat.OpenXml.Drawing;
using DocumentFormat.OpenXml.Wordprocessing;
using TOK.WMS.Core.Attributes;
using Microsoft.Win32;
using System.Globalization;
using System.Reflection;

namespace TOK.WMS.UI.Services;

public interface IExcelService
{
    /// <summary>rows를 .xlsx로 저장. 저장=true, 취소/빈데이터=false.</summary>
    bool Export<T>(IEnumerable<T> rows, string baseFileName, string sheetName = "데이터");
}

public class ExcelService : IExcelService
{
    private sealed record Col(PropertyInfo Prop, string Header, bool IsDateTime14);

    public bool Export<T>(IEnumerable<T> rows, string baseFileName, string sheetName = "데이터")
    {
        var list = rows?.ToList() ?? [];
        if (list.Count == 0) return false;

        var cols = BuildColumns(typeof(T));
        if (cols.Count == 0) return false;

        var dlg = new SaveFileDialog
        {
            Filter = "Excel 통합 문서 (*.xlsx)|*.xlsx",
            FileName = $"{baseFileName}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
        };
        if (dlg.ShowDialog() != true) return false;

        using var wb = new XLWorkbook();
        var ws = wb.Worksheets.Add(sheetName);

        for (int c = 0; c < cols.Count; c++)
            ws.Cell(1, c + 1).Value = cols[c].Header;
        ws.Row(1).Style.Font.Bold = true;

        for (int r = 0; r < list.Count; r++)
            for (int c = 0; c < cols.Count; c++)
                ws.Cell(r + 2, c + 1).Value = CellText(cols[c], list[r]);

        ws.Columns().AdjustToContents();
        wb.SaveAs(dlg.FileName);
        return true;
    }

    private static List<Col> BuildColumns(Type t)
    {
        var props = t.GetProperties(BindingFlags.Public | BindingFlags.Instance);

        var cols = props
            .Select(p => (p, a: p.GetCustomAttribute<ExcelColumnAttribute>()))
            .Where(x => x.a != null)
            .OrderBy(x => x.a!.Order)
            .Select(x => new Col(x.p, x.a!.Header, x.a!.IsDateTime14))
            .ToList();

        if (cols.Count == 0)
            cols = props.Select(p => new Col(p, p.Name, false)).ToList();

        return cols;
    }

    private static string CellText(Col col, object? row)
    {
        var v = col.Prop.GetValue(row);
        if (v == null) return "";

        if (col.IsDateTime14 && v is string s && s.Length == 14 &&
            DateTime.TryParseExact(s, "yyyyMMddHHmmss", CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt))
            return dt.ToString("yyyy-MM-dd HH:mm:ss");

        return v.ToString() ?? "";
    }
}
