# GitHub Repo Search App
GitHub API를 활용한 깃헙 레포 검색 앱

# Description
- 최소 타켓 : iOS 16.0
- TCA 아키텍쳐 사용
- CoreData 프레임워크를 사용하여 즐겨찾기 목록 유지
- Pagination 구현

# Feature
- 레포 검색 뷰
    - Pagination prefetching 방식
    - debounce
- 디테일 웹 뷰
    - WebView 기반 연결 `SFSafariViewController` 사용
    - 링크 클립보드 복사
- 즐겨찾기 뷰
    - 즐겨찾기 목록 관리

# Preview
![GitHubSearchAppgif](https://user-images.githubusercontent.com/77793412/201511799-21c0a681-9e9f-40b0-b3e6-2e5855c8df95.gif)

# Library
> [TCA](https://github.com/pointfreeco/swift-composable-architecture)

# Rules
- [Swift Style Guide](https://github.com/airbnb/swift)
- [Commit Convention](docs/CommitConvention.md)
- Git Flow 적용
    - main, feature 브랜치 운영
    - 되도록 두줄

# Issue