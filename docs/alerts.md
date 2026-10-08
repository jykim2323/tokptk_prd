# 공통 알림 사용법

안내, 경고, 작업 확인은 `TOK.WMS.UI.Services.IDialogService`로 표시한다. ViewModel은 서비스를 생성자에서 주입받고, View의 코드 비하인드는 주입받은 서비스 또는 `TOK.WMS.UI.Services.Alert`를 사용한다. `Alert`도 앱에 등록된 동일한 싱글턴 서비스를 호출한다.

## 알림 종류

| 메서드 | 용도 | 기본 제목 | 반환값 |
| --- | --- | --- | --- |
| `ShowInfo(message, title)` | 조회 결과, 완료 안내 등 사용자에게 알릴 내용 | 알림 | 없음 |
| `ShowWarning(message, title)` | 입력 오류, 처리 실패, 진행할 수 없는 상태 | 경고 | 없음 |
| `ShowConfirm(message, title)` | 사용자의 동의 후 실행할 작업 | 작업 확인 | `bool` |
| `ShowConfirmWithCancel(message, title)` | 네·아니오·취소를 구분해야 하는 작업 확인 | 작업 확인 | `bool?` |

제목을 생략하면 기본 제목이 표시된다. 필요한 화면에서는 두 번째 인수로 제목을 지정한다. 전체 화면의 알림은 의미에 맞는 `ShowInfo` 또는 `ShowWarning`을 명시해서 사용한다. `ShowMessage`는 이전 외부 호출이나 테스트 구현과의 호환을 위해 공통 서비스에만 남겨 두었다. 새 화면에서는 사용하지 않는다.

## ViewModel에서 사용

ViewModel에 `IDialogService`를 생성자 주입한다. 이미 `_dialog`가 있는 ViewModel은 해당 필드를 그대로 사용한다.

```csharp
using TOK.WMS.UI.Services;

public class InventoryViewModel
{
    private readonly IDialogService _dialog;

    public InventoryViewModel(IDialogService dialog)
    {
        _dialog = dialog;
    }
}
```

안내:

```csharp
_dialog.ShowInfo("조회가 완료되었습니다.", "조회 결과");
```

경고:

```csharp
_dialog.ShowWarning("삭제할 항목을 선택해 주세요.", "삭제 불가");
```

작업 확인:

```csharp
bool confirmed = _dialog.ShowConfirm("선택한 항목을 삭제하시겠습니까?", "삭제 확인");
if (!confirmed)
    return;

await DeleteSelectedAsync();
```

`ShowConfirm`은 사용자가 **네**를 선택한 경우에만 `true`를 반환한다. **아니오**, **ESC**, 창의 **X**로 종료하면 `false`다. 기본 선택은 **아니오**이며, 확인 후 실행할 코드는 `true`인 경우에만 진행한다.

네·아니오가 서로 다른 작업을 뜻하고 취소도 구분해야 하는 기존 기능은 `ShowConfirmWithCancel`을 사용한다. 같은 작업 확인 창의 세 버튼 형식이며, 별도의 알림 종류가 아니다. **네**는 `true`, **아니오**는 `false`, **취소·ESC·X**는 `null`을 반환한다. 기본 선택은 **취소**다. 취소 여부를 먼저 검사한 뒤 나머지 두 값을 처리한다. 아래 재지시 예시는 기존 본문의 예·아니요 표현을 유지하지만 실제 버튼은 네·아니오·취소로 표시된다.

```csharp
bool? hasProduct = _dialog.ShowConfirmWithCancel(
    "S/C Fork에 제품이 있습니까?\n\n" +
    "[예] 제품 있음    [아니요] 제품 없음    [취소] 작업 취소",
    "재지시 확인");

if (hasProduct is null)
    return;

await _api.ReissueStackerAsync(SelectedCraneNo, hasProduct.Value);
```

## View의 코드 비하인드에서 사용

View에 서비스를 주입할 수 있으면 동일한 `IDialogService`를 사용한다. 생성자 주입 없이 호출해야 하는 기존 View에서는 앱 초기화가 완료된 뒤 `Alert`를 사용할 수 있다.

```csharp
using TOK.WMS.UI.Services;

Alert.ShowInfo("작업이 완료되었습니다.");
Alert.ShowWarning("필수 입력값을 확인해 주세요.");

if (!Alert.ShowConfirm("이 창을 종료하시겠습니까?"))
    return;
```

새 `DialogService`를 화면마다 직접 생성하거나 별도의 알림 창을 만들어 호출하지 않는다. ViewModel에는 정적 `Alert`보다 생성자 주입을 사용해 테스트에서 `IDialogService`를 대체할 수 있게 한다.

## 창과 동작 유지보수

공통 서비스가 현재 화면에 맞는 owner를 정하고 UI Dispatcher에서 창을 표시한다. 알림이 닫힐 때 owner가 활성 상태이고 이전 입력 컨트롤을 사용할 수 있으면 해당 컨트롤로 포커스를 복원한다. 호출 화면은 owner 탐색, 스레드 전환, 포커스 복원 코드를 추가할 필요가 없다.

로그인 창이 열리기 전에도 `Alert`를 사용할 수 있다. 이때 공통 서비스가 알림을 닫는 동안 앱이 종료되지 않도록 보호하고, 기존 `MainWindow`와 종료 방식을 복원한다. 중복 실행 안내처럼 앱을 종료해야 하는 경우에는 알림을 닫은 뒤 호출 코드에서 종료한다.

공통 알림 창은 제목, 본문, 종류에 따른 표시와 버튼 배치를 담당한다. 공통 ViewModel은 알림 종류와 확인 결과를 관리한다. 디자인이나 공통 종료 동작은 이 창과 ViewModel에서 수정하고, 서비스와 `Alert`의 공개 호출 형식은 유지한다. 개별 화면에서는 메시지 내용과 종류만 선택한다.

| 파일 | 담당 |
| --- | --- |
| `TOK_WMS.UI/Models/Dialogs/AlertKind.cs` | 안내·경고·작업 확인 종류 |
| `TOK_WMS.UI/ViewModels/Dialogs/AlertDialogViewModel.cs` | 표시할 내용, 버튼 형식, 확인 결과 |
| `TOK_WMS.UI/Views/Dialogs/AlertDialogWindow.xaml` 및 `.xaml.cs` | 공통 창 디자인과 키보드·닫기 동작 |
| `TOK_WMS.UI/Services/ETC/DialogService.cs` | 창 표시, owner, Dispatcher, 포커스, 기존 호출 호환 |
| `TOK_WMS.UI/Services/Alert.cs` | 코드 비하인드용 공통 서비스 연결 |

안내·경고·확인 창의 테마, 제목 색, 버튼 모양을 변경할 때도 공통 알림 창과 리소스를 수정한다. 개별 화면에 같은 스타일이나 `MessageBox.Show` 호출을 복제하지 않는다.
