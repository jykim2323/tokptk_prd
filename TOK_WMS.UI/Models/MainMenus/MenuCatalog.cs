

namespace TOK.WMS.UI.Models.MainMenus;

public static class MenuCatalog
{

    public static IReadOnlyList<MenuGroup> Groups { get; } = new[]
    {
         new MenuGroup { Title = "입고관리", IconKey = "📥", Items = new[]
        {
            new MenuLeaf { Title = "핸드스캔 입고 등록",  MenuKey = DocumentKeys.Frm3130 },
            new MenuLeaf { Title = "미입고 현황",  MenuKey = DocumentKeys.Frm3300 },
            new MenuLeaf { Title = "입고 이력 현황",  MenuKey = DocumentKeys.Frm3400 },
            new MenuLeaf { Title = "입고 실적 현황",  MenuKey = DocumentKeys.Frm3700 },
            new MenuLeaf { Title = "재 입고 작업",  MenuKey = DocumentKeys.Frm3900 },
            new MenuLeaf { Title = "수동입고등록",  MenuKey = DocumentKeys.Frm3100 }
        }},
        new MenuGroup { Title = "출고관리", IconKey = "📤", Items = new[]
        {
            new MenuLeaf { Title = "출고 엑셀 수신", MenuKey = DocumentKeys.Frm4101 },
            new MenuLeaf { Title = "출고 지시", MenuKey = DocumentKeys.Frm4102 }, 
            new MenuLeaf { Title = "피킹 리스트", MenuKey = DocumentKeys.Frm4103 },
            new MenuLeaf { Title = "재고 출고 지시", MenuKey = DocumentKeys.Frm4100 },
            new MenuLeaf { Title = "미 출고 현황", MenuKey = DocumentKeys.Frm4300 },
            new MenuLeaf { Title = "출고 이력 현황", MenuKey = DocumentKeys.Frm4400 },
            new MenuLeaf { Title = "출고 실적 현황", MenuKey = DocumentKeys.Frm4500 }
        }},
        new MenuGroup { Title = "재고관리", IconKey = "📦", Items = new[]
        {
            new MenuLeaf { Title = "저장위치 조회", MenuKey = DocumentKeys.Frm6100 },
            new MenuLeaf { Title = "재고 자료 조회", MenuKey = DocumentKeys.Frm6200 },
            new MenuLeaf { Title = "재고 집계 자료조회", MenuKey = DocumentKeys.Frm6300 },
            new MenuLeaf { Title = "PLT NO 관리", MenuKey = DocumentKeys.Frm6900 },
            new MenuLeaf { Title = "수/자동 전일재고 현황", MenuKey = DocumentKeys.Frm6450 },
            new MenuLeaf { Title = "수/자동 전일재고 집계", MenuKey = DocumentKeys.Frm6550 },
            new MenuLeaf { Title = "전일 재고 현황", MenuKey = DocumentKeys.Frm6700 }
        }},
        new MenuGroup { Title = "기준정보관리", IconKey = "📊", Items = new[]
        {
            new MenuLeaf { Title = "품목코드 관리", MenuKey = DocumentKeys.Frm1100 },
            new MenuLeaf { Title = "구분코드 관리", MenuKey = DocumentKeys.Frm1500 },
            new MenuLeaf { Title = "사용자 관리", MenuKey = DocumentKeys.Frm1300 }
        }},
        new MenuGroup { Title = "시스템제어관리", IconKey = "🛠️", Items = new[]
        {
            new MenuLeaf { Title = "시스템운전 설정", MenuKey = DocumentKeys.Frm6100 },
            new MenuLeaf { Title = "스택커 예약현황", MenuKey = DocumentKeys.Frm6200 },
            new MenuLeaf { Title = "입출고 완료 대기", MenuKey = DocumentKeys.Frm6300 },
            new MenuLeaf { Title = "스택커 신호 관리", MenuKey = DocumentKeys.Frm6900 },
            new MenuLeaf { Title = "컨베어 신호 관리", MenuKey = DocumentKeys.Frm6450 },
            new MenuLeaf { Title = "에러 이력 현황", MenuKey = DocumentKeys.Frm6550 }
        }},
        new MenuGroup { Title = "전일 재고 작성", IconKey = "🏭", Items = new[]
        {
            new MenuLeaf { Title = "전일 재고 작성", MenuKey = DocumentKeys.Frm7100 }
        }},

    };
}
