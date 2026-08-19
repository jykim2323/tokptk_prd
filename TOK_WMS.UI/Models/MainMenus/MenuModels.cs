namespace TOK.WMS.UI.Models.MainMenus;

/// <summary>사이드바 하위 메뉴 1항목 → 문서 1개로 매핑.</summary>
public class MenuLeaf
{
    public string Title { get; init; } = "";
    public string IconKey { get; init; } = "";
    public string MenuKey { get; init; } = "";
}

/// <summary>사이드바 대분류(제어관리/입고관리/…).</summary>
public class MenuGroup
{
    public string Title { get; init; } = "";
    public string IconKey { get; init; } = "";
    public IReadOnlyList<MenuLeaf> Items { get; init; } = [];
}
