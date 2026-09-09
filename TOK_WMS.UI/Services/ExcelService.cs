using ClosedXML.Excel;
using Microsoft.Win32;
using System.Globalization;
using System.Reflection;
using System.Runtime.InteropServices;
using TOK.WMS.Core.Attributes;
using TOK.WMS.Core.DTOs.Outbounds;

namespace TOK.WMS.UI.Services;


public interface IExcelService
{
    bool Export<T>(
        IEnumerable<T> rows,
        string baseFileName,
        string sheetName = "데이터");


    List<Frm4101Dto.ExcelRowDto>? ImportFrm4101(
        int startLine);
}


public class ExcelService : IExcelService
{
    private sealed record Col(
        PropertyInfo Prop,
        string Header,
        bool IsDateTime14);


    // =========================================================
    // EXPORT
    // 기존 기능 그대로
    // =========================================================

    public bool Export<T>(
        IEnumerable<T> rows,
        string baseFileName,
        string sheetName = "데이터")
    {
        var list =
            rows?.ToList() ?? [];


        if (list.Count == 0)
            return false;


        var cols =
            BuildColumns(typeof(T));


        if (cols.Count == 0)
            return false;


        var dlg =
            new SaveFileDialog
            {
                Filter =
                    "Excel 통합 문서 (*.xlsx)|*.xlsx",

                FileName =
                    $"{baseFileName}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
            };


        if (dlg.ShowDialog() != true)
            return false;


        using var wb =
            new XLWorkbook();


        var ws =
            wb.Worksheets.Add(
                sheetName);


        // =====================================================
        // Header
        // =====================================================

        for (var c = 0;
             c < cols.Count;
             c++)
        {
            ws.Cell(
                    1,
                    c + 1)
                .Value =
                cols[c].Header;
        }


        ws.Row(1)
            .Style
            .Font
            .Bold =
            true;


        // =====================================================
        // Data
        // =====================================================

        for (var r = 0;
             r < list.Count;
             r++)
        {
            for (var c = 0;
                 c < cols.Count;
                 c++)
            {
                ws.Cell(
                        r + 2,
                        c + 1)
                    .Value =
                    CellText(
                        cols[c],
                        list[r]);
            }
        }


        ws.Columns()
            .AdjustToContents();


        wb.SaveAs(
            dlg.FileName);


        return true;
    }


    // =========================================================
    // Frm4101 Excel IMPORT
    //
    // Delphi:
    // CreateOleObject('Excel.application')
    //
    // 방식과 동일하게 Excel COM 사용
    // =========================================================

    public List<Frm4101Dto.ExcelRowDto>? ImportFrm4101(
        int startLine)
    {
        var dlg =
            new OpenFileDialog
            {
                Title =
                    "출고 Excel 파일 선택",

                Filter =
                    "Excel 파일 (*.xls;*.xlsx;*.xlsm)|*.xls;*.xlsx;*.xlsm|" +
                    "모든 파일 (*.*)|*.*",

                CheckFileExists =
                    true,

                Multiselect =
                    false
            };


        // 파일 선택 취소
        if (dlg.ShowDialog() != true)
            return null;


        object? excelApp =
            null;

        object? workbooks =
            null;

        object? workbook =
            null;

        object? worksheets =
            null;

        object? worksheet =
            null;

        object? usedRange =
            null;

        object? rows =
            null;


        try
        {
            // =================================================
            // Excel 설치 여부 확인
            // =================================================

            var excelType =
                Type.GetTypeFromProgID(
                    "Excel.Application");


            if (excelType == null)
            {
                throw new Exception(
                    "Microsoft Excel이 설치되어 있지 않습니다.");
            }


            // =================================================
            // Excel 실행
            // =================================================

            excelApp =
                Activator.CreateInstance(
                    excelType);


            if (excelApp == null)
            {
                throw new Exception(
                    "Microsoft Excel을 실행할 수 없습니다.");
            }


            dynamic excel =
                excelApp;


            excel.Visible =
                false;

            excel.DisplayAlerts =
                false;


            // =================================================
            // WorkBooks
            // =================================================

            workbooks =
                excel.Workbooks;


            dynamic books =
                workbooks;


            // =================================================
            // 파일 OPEN
            // =================================================

            workbook =
                books.Open(
                    dlg.FileName);


            dynamic wb =
                workbook;


            // =================================================
            // 첫 번째 Worksheet
            // =================================================

            worksheets =
                wb.Worksheets;


            dynamic sheets =
                worksheets;


            worksheet =
                sheets[1];


            dynamic ws =
                worksheet;


            // =================================================
            // UsedRange
            // =================================================

            usedRange =
                ws.UsedRange;


            dynamic range =
                usedRange;


            rows =
                range.Rows;


            dynamic rangeRows =
                rows;


            var totalRows =
                Convert.ToInt32(
                    rangeRows.Count);


            var result =
                new List<
                    Frm4101Dto.ExcelRowDto>();


            var no =
                1;


            // =================================================
            // Delphi 원본
            //
            // For iRow := 1 to cnt
            //
            // eRow := iRow + li_line
            //
            // StartLine = 9
            //
            // 첫 데이터:
            // 1 + 9 = Excel 10행
            // =================================================

            for (var iRow = 1;
                 iRow <= totalRows;
                 iRow++)
            {
                var excelRow =
                    iRow + startLine;


                if (excelRow > totalRows)
                    break;


                // =============================================
                // C열(3)
                // 품목코드
                // =============================================

                var itemCode =
                    GetComCellText(
                        ws,
                        excelRow,
                        3);


                // Delphi:
                //
                // If Trim(v.cells[eRow, 3]) = '' Then Break;
                if (string.IsNullOrWhiteSpace(
                    itemCode))
                {
                    break;
                }


                // =============================================
                // D열(4)
                // 품명
                // =============================================

                var itemName =
                    GetComCellText(
                        ws,
                        excelRow,
                        4);


                // =============================================
                // E열(5)
                // 출고수량
                // =============================================

                var qtyText =
                    GetComCellText(
                            ws,
                            excelRow,
                            5)
                        .Replace(",", "")
                        .Trim();


                decimal qty =
                    0;


                if (!string.IsNullOrWhiteSpace(
                    qtyText))
                {
                    if (!decimal.TryParse(
                            qtyText,
                            NumberStyles.Any,
                            CultureInfo.CurrentCulture,
                            out qty))
                    {
                        decimal.TryParse(
                            qtyText,
                            NumberStyles.Any,
                            CultureInfo.InvariantCulture,
                            out qty);
                    }
                }


                // =============================================
                // H열(8)
                // LOTNO
                // =============================================

                var lotNo =
                    GetComCellText(
                        ws,
                        excelRow,
                        8);


                // =============================================
                // K열(11)
                // 납품처
                // =============================================

                var customer =
                    GetComCellText(
                        ws,
                        excelRow,
                        11);


                // =============================================
                // N열(14)
                // BOXNO
                // =============================================

                var boxNo =
                    GetComCellText(
                        ws,
                        excelRow,
                        14);


                // =============================================
                // O열(15)
                // 비고
                // =============================================

                var remark =
                    GetComCellText(
                        ws,
                        excelRow,
                        15);


                // =============================================
                // Grid Item
                // =============================================

                result.Add(
                    new Frm4101Dto.ExcelRowDto
                    {
                        No =
                            no++,

                        ItemCode =
                            itemCode,

                        ItemName =
                            itemName,

                        LotNo =
                            lotNo,

                        Qty =
                            qty,

                        Customer =
                            customer,

                        BoxNo =
                            boxNo,

                        Remark =
                            remark
                    });
            }


            return result;
        }
        catch (Exception ex)
        {
            throw new Exception(
                $"Excel 파일을 읽을 수 없습니다.\n\n{ex.Message}",
                ex);
        }
        finally
        {
            // =================================================
            // Excel Workbook Close
            // =================================================

            try
            {
                if (workbook != null)
                {
                    dynamic wb =
                        workbook;

                    wb.Close(false);
                }
            }
            catch
            {
            }


            // =================================================
            // Excel Quit
            // =================================================

            try
            {
                if (excelApp != null)
                {
                    dynamic excel =
                        excelApp;

                    excel.Quit();
                }
            }
            catch
            {
            }


            // =================================================
            // COM 객체 해제
            //
            // 안 하면 EXCEL.EXE가 남을 수 있음
            // =================================================

            ReleaseComObject(
                rows);

            ReleaseComObject(
                usedRange);

            ReleaseComObject(
                worksheet);

            ReleaseComObject(
                worksheets);

            ReleaseComObject(
                workbook);

            ReleaseComObject(
                workbooks);

            ReleaseComObject(
                excelApp);


            GC.Collect();

            GC.WaitForPendingFinalizers();

            GC.Collect();

            GC.WaitForPendingFinalizers();
        }
    }


    // =========================================================
    // COM Excel Cell 읽기
    // =========================================================

    private static string GetComCellText(
        dynamic worksheet,
        int row,
        int column)
    {
        object? cell =
            null;


        try
        {
            cell =
                worksheet.Cells[
                    row,
                    column];


            dynamic excelCell =
                cell;


            var value =
                excelCell.Value2;


            if (value == null)
                return string.Empty;


            return value
                .ToString()
                .Trim();
        }
        finally
        {
            ReleaseComObject(
                cell);
        }
    }


    // =========================================================
    // COM Release
    // =========================================================

    private static void ReleaseComObject(
        object? obj)
    {
        if (obj == null)
            return;


        try
        {
            if (Marshal.IsComObject(
                obj))
            {
                Marshal.FinalReleaseComObject(
                    obj);
            }
        }
        catch
        {
            // COM 해제 중 오류는 무시
        }
    }


    // =========================================================
    // EXPORT Helper
    // =========================================================

    private static List<Col> BuildColumns(
        Type t)
    {
        var props =
            t.GetProperties(
                BindingFlags.Public |
                BindingFlags.Instance);


        var cols =
            props
                .Select(
                    p =>
                    (
                        p,

                        a:
                        p.GetCustomAttribute<
                            ExcelColumnAttribute>()
                    ))
                .Where(
                    x =>
                        x.a != null)
                .OrderBy(
                    x =>
                        x.a!.Order)
                .Select(
                    x =>
                        new Col(
                            x.p,
                            x.a!.Header,
                            x.a!.IsDateTime14))
                .ToList();


        if (cols.Count == 0)
        {
            cols =
                props
                    .Select(
                        p =>
                            new Col(
                                p,
                                p.Name,
                                false))
                    .ToList();
        }


        return cols;
    }


    // =========================================================
    // EXPORT Cell 변환
    // =========================================================

    private static string CellText(
        Col col,
        object? row)
    {
        var value =
            col.Prop.GetValue(
                row);


        if (value == null)
            return string.Empty;


        if (col.IsDateTime14 &&
            value is string s &&
            s.Length == 14 &&
            DateTime.TryParseExact(
                s,
                "yyyyMMddHHmmss",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out var dt))
        {
            return dt.ToString(
                "yyyy-MM-dd HH:mm:ss");
        }


        return value.ToString()
               ?? string.Empty;
    }
}