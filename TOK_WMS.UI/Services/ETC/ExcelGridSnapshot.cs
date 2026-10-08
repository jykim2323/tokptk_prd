using System.Collections;
using System.Globalization;
using System.Reflection;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using TOK.WMS.Core.Attributes;

namespace TOK.WMS.UI.Services.ETC;

internal sealed record ExcelExportColumn(
    string Header,
    double SuggestedWidth,
    string? NumberFormat,
    bool IsDate,
    bool IsTime,
    Func<object?, int, object?> ReadValue);

internal sealed record ExcelExportSnapshot(
    IReadOnlyList<ExcelExportColumn> Columns,
    IReadOnlyList<IReadOnlyList<object?>> Rows);

/// <summary>표시 중인 그리드의 열, 정렬, 표시 변환을 내보내기 시점에 읽습니다.</summary>
internal static class ExcelGridSnapshot
{
    public static ExcelExportSnapshot Capture<T>(IEnumerable<T> rows, DataGrid? grid)
    {
        if (grid is null)
            return Freeze(BuildFallbackColumns(typeof(T)), rows.Cast<object?>().ToList());

        grid.Dispatcher.VerifyAccess();
        var columns = grid.Columns
            .Where(column => column.Visibility == Visibility.Visible)
            .OrderBy(column => column.DisplayIndex)
            .Select(BuildGridColumn)
            .ToList();

        // Items is the displayed collection view, including the user's sorting/filtering.
        var displayedRows = grid.Items.Cast<object?>()
            .Where(row => row != CollectionView.NewItemPlaceholder)
            .ToList();
        return Freeze(columns, displayedRows);
    }

    private static ExcelExportSnapshot Freeze(IReadOnlyList<ExcelExportColumn> columns, IReadOnlyList<object?> rows)
        => new(columns, rows.Select((row, index) => (IReadOnlyList<object?>)columns
            .Select(column => column.ReadValue(row, index)).ToArray()).ToArray());

    private static ExcelExportColumn BuildGridColumn(DataGridColumn column)
    {
        var header = HeaderText(column.Header);
        var binding = column switch
        {
            DataGridBoundColumn bound => bound.Binding,
            DataGridTemplateColumn template => FindTemplateBinding(template.CellTemplate),
            DataGridComboBoxColumn combo => combo.SelectedValueBinding ?? combo.SelectedItemBinding ?? combo.TextBinding,
            _ => null
        };

        var reader = CreateReader(binding);
        var culture = (binding as Binding)?.ConverterCulture ?? CultureInfo.CurrentCulture;
        var converterName = (binding as Binding)?.Converter?.GetType().Name;
        var isTime = converterName == "OnlyTimeFormatConverter" || header.Contains("시간", StringComparison.Ordinal);
        var isDate = !isTime && (converterName == "DateTimeFormatConverter" ||
            header.Contains("일자", StringComparison.Ordinal) || header.Contains("일시", StringComparison.Ordinal));
        var pixels = column.ActualWidth;
        if (!double.IsFinite(pixels) || pixels <= 0)
            pixels = column.Width.IsAbsolute ? column.Width.Value : Math.Max(column.MinWidth, 140);

        return new(header, Math.Clamp(pixels / 7, 10, 48),
            NumericFormat((binding as Binding)?.StringFormat, culture), isDate, isTime, reader);
    }

    private static Func<object?, int, object?> CreateReader(BindingBase? binding)
    {
        if (binding is Binding rowBinding &&
            rowBinding.RelativeSource?.AncestorType == typeof(DataGridRow) &&
            rowBinding.Path?.Path == "Header")
            return (_, index) => index + 1;

        if (binding is null)
            return (_, _) => null;

        // A detached read-only target avoids generating/scrolling cells and preserves converters.
        var target = new BindingValueReader();
        return (row, _) =>
        {
            // An explicit source also works before this detached target enters a visual tree.
            BindingOperations.SetBinding(target, BindingValueReader.ValueProperty, ReadOnlyBinding(binding, row));
            switch (BindingOperations.GetBindingExpressionBase(target, BindingValueReader.ValueProperty))
            {
                case BindingExpression expression:
                    expression.UpdateTarget();
                    break;
                case MultiBindingExpression expression:
                    expression.UpdateTarget();
                    break;
            }
            return target.GetValue(BindingValueReader.ValueProperty);
        };
    }

    private static BindingBase ReadOnlyBinding(BindingBase original, object? row)
    {
        if (original is MultiBinding multi)
        {
            var result = new MultiBinding
            {
                Mode = BindingMode.OneWay,
                Converter = multi.Converter,
                ConverterParameter = multi.ConverterParameter,
                ConverterCulture = multi.ConverterCulture,
                FallbackValue = multi.FallbackValue,
                TargetNullValue = multi.TargetNullValue
            };
            foreach (var child in multi.Bindings)
                result.Bindings.Add(ReadOnlyBinding(child, row));
            return result;
        }

        if (original is not Binding binding)
            throw new NotSupportedException("이 열의 바인딩은 엑셀 내보내기를 지원하지 않습니다.");

        var clone = new Binding
        {
            Path = binding.Path,
            Mode = BindingMode.OneWay,
            Converter = binding.Converter,
            ConverterParameter = binding.ConverterParameter,
            ConverterCulture = binding.ConverterCulture,
            FallbackValue = binding.FallbackValue,
            TargetNullValue = binding.TargetNullValue
        };
        if (binding.Source is not null && binding.Source != DependencyProperty.UnsetValue)
            clone.Source = binding.Source;
        else if (binding.RelativeSource is not null)
            clone.RelativeSource = binding.RelativeSource;
        else if (!string.IsNullOrEmpty(binding.ElementName))
            clone.ElementName = binding.ElementName;
        else
            clone.Source = row;
        return clone;
    }

    private static BindingBase? FindTemplateBinding(DataTemplate? template)
    {
        if (template?.LoadContent() is not DependencyObject content)
            return null;
        return FindBinding(content);
    }

    private static BindingBase? FindBinding(DependencyObject element)
    {
        var property = element switch
        {
            TextBlock => TextBlock.TextProperty,
            TextBox => TextBox.TextProperty,
            ToggleButton => ToggleButton.IsCheckedProperty,
            ContentControl => ContentControl.ContentProperty,
            _ => null
        };
        if (property is not null && BindingOperations.GetBindingBase(element, property) is { } binding)
            return binding;
        foreach (var child in LogicalTreeHelper.GetChildren(element).OfType<DependencyObject>())
            if (FindBinding(child) is { } childBinding)
                return childBinding;
        return null;
    }

    private static string HeaderText(object? header) => header switch
    {
        TextBlock text => new TextRange(text.ContentStart, text.ContentEnd).Text.Trim(),
        AccessText text => text.Text,
        ContentControl content => HeaderText(content.Content),
        _ => header?.ToString() ?? string.Empty
    };

    private static IReadOnlyList<ExcelExportColumn> BuildFallbackColumns(Type type)
    {
        var properties = type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(property => property.GetIndexParameters().Length == 0 && property.CanRead)
            .Select(property => (Property: property, Attribute: property.GetCustomAttribute<ExcelColumnAttribute>()))
            .ToList();
        var attributed = properties.Where(item => item.Attribute is not null).OrderBy(item => item.Attribute!.Order).ToList();
        if (attributed.Count > 0)
            properties = attributed;
        return properties.Select(item => new ExcelExportColumn(
            item.Attribute?.Header ?? item.Property.Name, 16, null,
            item.Attribute?.IsDateTime14 == true, false,
            (row, _) => row is null ? null : item.Property.GetValue(row))).ToList();
    }

    private static string? NumericFormat(string? format, CultureInfo culture)
    {
        if (string.IsNullOrWhiteSpace(format))
            return null;
        var colon = format.IndexOf(':');
        var specifier = colon >= 0 ? format[(colon + 1)..].TrimEnd('}') : format;
        if (specifier.Length == 0 || !int.TryParse(specifier[1..], out var precision) || precision is < 0 or > 10)
            return null;
        var fraction = precision == 0 ? string.Empty : "." + new string('0', precision);
        return char.ToUpperInvariant(specifier[0]) switch
        {
            'N' => "#,##0" + fraction,
            'F' => "0" + fraction,
            'P' => "0" + fraction + "%",
            'D' => new string('0', Math.Max(1, precision)),
            'C' => "\"" + culture.NumberFormat.CurrencySymbol + "\"#,##0" + fraction,
            _ => null
        };
    }

    private sealed class BindingValueReader : FrameworkElement
    {
        public static readonly DependencyProperty ValueProperty = DependencyProperty.Register(
            "Value", typeof(object), typeof(BindingValueReader), new PropertyMetadata(null));
    }
}
