# Issue
- 리스트 셀을 탭하면 bottomSheet로 각 셀에 맞는 깃헙 저장소를 사파리뷰로 띄어줌
- 모든 셀이 같은 깃헙 저장소를 띄우는 버그가 있었음

### 해결과정
1. 브레이킹 포인트를 찍고 디버깅 과정중 `.sheet` 메소드가 셀 길이 만큼 호출되는 것을 발견
-> 기존 `.sheet` 메소드는 셀에 위치해서 각 셀마다 호출되고 있어서 GitHubSearchList 리스트 범위로 옮김

2. ListRowView(Child)에서 각 레포지토리에 대한 데이터를 가지고 있는데 ListView(Parent)에서 이벤트가 발생한 그 데이터를 알 수 있는 방법은? 🧐
``` swift
struct State: Equatable {
    var searchResults: IdentifiedArrayOf<GitHubSearchRowStore.State> = []
}
```
- ChildState를 `IdentifiedArrayOf`를 사용하여 ParentState에서 `searchResults`라는 변수명으로 선언

``` swift
enum Action: Equatable {
    case forEachRepos(id: GitHubSearchRowStore.State.ID,
                      action: GitHubSearchRowStore.Action)
}

case .forEachRepos(id: let id, action: .showSafari):
        if let rowState = state.searchResults.first(where: { $0.id == id }),
        let url = URL(string: rowState.repo.urlString) {
          state.url = url
          state.showSafari.toggle()
        }
        return .none

// Reduce 부분에 추가
.forEach(\.searchResults, action: /Action.forEachRepos(id: action:)) {
      GitHubSearchRowStore()
    }
```
- ParentStore에서 `id` 값으로 이벤트가 발생한 `childState.repo.urlString`에 접근
- url 생성 후 `showSafari` 작업 실행