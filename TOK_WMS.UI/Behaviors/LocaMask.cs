using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace TOK.WMS.UI.Behaviors;

/// <summary>
/// TextBox에 LOCA 마스크: 화면엔 ##-##-## 표시, 바인딩 Value는 숫자 6자리.
/// 사용: &lt;TextBox behaviors:LocaMask.Value="{Binding XxxLoca}"/&gt;  (Text는 바인딩하지 않음)
/// </summary>
public static class LocaMask
{
    public static readonly DependencyProperty ValueProperty =
        DependencyProperty.RegisterAttached("Value", typeof(string), typeof(LocaMask),
            new FrameworkPropertyMetadata(null, FrameworkPropertyMetadataOptions.BindsTwoWayByDefault, OnValueChanged));

    public static string GetValue(DependencyObject o) => (string)o.GetValue(ValueProperty);
    public static void SetValue(DependencyObject o, string v) => o.SetValue(ValueProperty, v);

    // 재진입 방지 플래그(TextBox별)
    private static readonly DependencyProperty SyncingProperty =
        DependencyProperty.RegisterAttached("Syncing", typeof(bool), typeof(LocaMask), new PropertyMetadata(false));

    private static void OnValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        if (d is not TextBox tb) return;

        tb.PreviewTextInput -= OnInput; tb.TextChanged -= OnTextChanged;
        tb.PreviewTextInput += OnInput; tb.TextChanged += OnTextChanged;

        if ((bool)tb.GetValue(SyncingProperty)) return;     // 내부 변경이면 무시

        var f = Format(Digits((string)(e.NewValue ?? "")));  // 외부(VM)에서 Value 설정 → 화면 마스킹
        if (tb.Text != f)
        {
            tb.SetValue(SyncingProperty, true);
            tb.Text = f; tb.CaretIndex = f.Length;
            tb.SetValue(SyncingProperty, false);
        }
    }

    private static void OnInput(object sender, TextCompositionEventArgs e)
        => e.Handled = !e.Text.All(char.IsDigit);

    private static void OnTextChanged(object sender, TextChangedEventArgs e)
    {
        var tb = (TextBox)sender;
        if ((bool)tb.GetValue(SyncingProperty)) return;

        var digits = Digits(tb.Text);
        var f = Format(digits);

        tb.SetValue(SyncingProperty, true);
        if (tb.Text != f) { tb.Text = f; tb.CaretIndex = f.Length; }
        SetValue(tb, digits);      // 바인딩(VM)엔 숫자 6자리
        tb.SetValue(SyncingProperty, false);
    }

    private static string Digits(string s)
    {
        var d = new string((s ?? "").Where(char.IsDigit).ToArray());
        return d.Length > 6 ? d[..6] : d;
    }
    private static string Format(string d)
        => d.Length <= 2 ? d : d.Length <= 4 ? $"{d[..2]}-{d[2..]}" : $"{d[..2]}-{d[2..4]}-{d[4..]}";
}
