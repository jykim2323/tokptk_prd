using System;
using System.Windows;
using System.Windows.Input;

namespace TOK.WMS.UI.Behaviors;

/// <summary>
/// 카드형 보조 창의 공통 동작(ESC 닫기, 헤더 드래그)을 제공합니다.
/// </summary>
public static class PopupWindowBehavior
{
    public static readonly DependencyProperty IsEnabledProperty =
        DependencyProperty.RegisterAttached(
            "IsEnabled",
            typeof(bool),
            typeof(PopupWindowBehavior),
            new PropertyMetadata(false, OnIsEnabledChanged));

    public static readonly DependencyProperty IsDragHandleProperty =
        DependencyProperty.RegisterAttached(
            "IsDragHandle",
            typeof(bool),
            typeof(PopupWindowBehavior),
            new PropertyMetadata(false, OnIsDragHandleChanged));

    public static bool GetIsEnabled(DependencyObject element) =>
        (bool)element.GetValue(IsEnabledProperty);

    public static void SetIsEnabled(DependencyObject element, bool value) =>
        element.SetValue(IsEnabledProperty, value);

    public static bool GetIsDragHandle(DependencyObject element) =>
        (bool)element.GetValue(IsDragHandleProperty);

    public static void SetIsDragHandle(DependencyObject element, bool value) =>
        element.SetValue(IsDragHandleProperty, value);

    private static void OnIsEnabledChanged(
        DependencyObject dependencyObject,
        DependencyPropertyChangedEventArgs e)
    {
        if (dependencyObject is not Window window)
            return;

        if ((bool)e.NewValue)
        {
            window.PreviewKeyDown += Window_PreviewKeyDown;
            return;
        }

        window.PreviewKeyDown -= Window_PreviewKeyDown;
    }

    private static void OnIsDragHandleChanged(
        DependencyObject dependencyObject,
        DependencyPropertyChangedEventArgs e)
    {
        if (dependencyObject is not UIElement element)
            return;

        if ((bool)e.NewValue)
        {
            element.MouseLeftButtonDown += DragHandle_MouseLeftButtonDown;
            return;
        }

        element.MouseLeftButtonDown -= DragHandle_MouseLeftButtonDown;
    }

    private static void Window_PreviewKeyDown(object sender, KeyEventArgs e)
    {
        if (sender is not Window window || e.Key != Key.Escape)
            return;

        window.Close();
        e.Handled = true;
    }

    private static void DragHandle_MouseLeftButtonDown(
        object sender,
        MouseButtonEventArgs e)
    {
        if (sender is not DependencyObject dragHandle
            || e.ChangedButton != MouseButton.Left
            || e.ButtonState != MouseButtonState.Pressed)
        {
            return;
        }

        var window = Window.GetWindow(dragHandle);
        if (window is null)
            return;

        try
        {
            window.DragMove();
            e.Handled = true;
        }
        catch (InvalidOperationException)
        {
            // 마우스 버튼이 이미 해제된 경우 WPF가 DragMove를 거부할 수 있습니다.
        }
    }
}
