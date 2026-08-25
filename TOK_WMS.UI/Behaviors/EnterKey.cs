using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace TOK.WMS.UI.Behaviors;

/// <summary>Enter 키 입력 시 지정 Command 실행.
/// 포커스된 TextBox의 미반영 입력을 먼저 커밋(UpdateSource)한 뒤 실행한다.</summary>
public static class EnterKey
{
    public static readonly DependencyProperty CommandProperty =
        DependencyProperty.RegisterAttached("Command", typeof(ICommand), typeof(EnterKey),
            new PropertyMetadata(null, OnCommandChanged));

    public static ICommand? GetCommand(DependencyObject o) =>
        (ICommand?)o.GetValue(CommandProperty);
    public static void SetCommand(DependencyObject o, ICommand? v) =>
        o.SetValue(CommandProperty, v);

    private static void OnCommandChanged(DependencyObject d,
        DependencyPropertyChangedEventArgs e)
    {
        if (d is not UIElement el) return;
        el.PreviewKeyDown -= OnPreviewKeyDown;
        if (e.NewValue != null) el.PreviewKeyDown += OnPreviewKeyDown;
    }

    private static void OnPreviewKeyDown(object sender, KeyEventArgs e)
    {
        if (e.Key != Key.Enter) return;

        if (e.OriginalSource is TextBox tb)
        {
            if (tb.AcceptsReturn) return;
            tb.GetBindingExpression(TextBox.TextProperty)?.UpdateSource();
        }

        if (IsInside<DataGrid>(e.OriginalSource as DependencyObject)) return;

        var cmd = GetCommand((DependencyObject)sender);
        if (cmd?.CanExecute(null) == true)
        {
            cmd.Execute(null);
            e.Handled = true;
        }
    }

    private static bool IsInside<T>(DependencyObject? d) where T : DependencyObject
    {
        while (d != null)
        {
            if (d is T) return true;
            d = d is Visual ? VisualTreeHelper.GetParent(d) : LogicalTreeHelper.GetParent(d);
        }
        return false;
    }
}
