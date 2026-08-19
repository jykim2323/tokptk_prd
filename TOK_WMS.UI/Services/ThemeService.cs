using System.Windows;

namespace TOK.WMS.UI.Services;

/// <summary>
/// 앱 전역 Light / Dark 테마 전환 서비스.
/// Application.Resources.MergedDictionaries 의 테마 사전을 교체한다.
/// </summary>
public sealed class ThemeService
{
    private bool _isDark = false;
    public bool IsDark => _isDark;

    /// <summary>현재 테마를 반전 후 적용</summary>
    public void Toggle()
    {
        _isDark = !_isDark;
        Apply(_isDark);
    }

    /// <summary>지정 테마 적용</summary>
    public void Apply(bool dark)
    {
        _isDark = dark;
        var uri = dark
            ? new Uri("Themes/DarkTheme.xaml", UriKind.Relative)
            : new Uri("Themes/LightTheme.xaml", UriKind.Relative);

        var dict = Application.Current.Resources.MergedDictionaries;

        // 기존 테마 사전 제거
        var existing = dict.FirstOrDefault(d => d.Source?.OriginalString
            .Contains("Theme.xaml", StringComparison.OrdinalIgnoreCase) == true);
        if (existing != null) dict.Remove(existing);

        // 새 테마 적용
        dict.Add(new ResourceDictionary { Source = uri });
    }
}
