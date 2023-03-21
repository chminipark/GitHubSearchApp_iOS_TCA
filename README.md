# GitHub Repo Search App
GitHub API를 활용한 깃헙 레포 검색 앱

# Preview
![GitHubSearchApp_TCA_Preview](https://user-images.githubusercontent.com/77793412/226512959-e8c56195-1ba1-45fa-b586-ac34013ebe5b.gif)

# Feature
- 최소 타켓 : iOS 16.0
- TCA 아키텍쳐 사용
- CoreData 프레임워크를 사용하여 즐겨찾기 목록 유지
- Pagination 구현

# Description
- 레포 검색 뷰
    - Pagination
    - debounce
- 디테일 웹 뷰
    - WebView 기반 연결 `SFSafariViewController` 사용
- 즐겨찾기 뷰
    - 즐겨찾기 목록 관리

## Project Layer Overview
##### 프로젝트 레이어
![Screenshot 2023-03-21 at 1 28 59 PM](https://user-images.githubusercontent.com/77793412/226517389-eba717e0-14ca-40a6-8633-d6b66a3f711b.png)

##### 폴더트리구조
<img width="272" alt="Screenshot 2023-03-21 at 1 16 08 PM" src="https://user-images.githubusercontent.com/77793412/226516024-c66286b4-f215-4e96-8934-1e17846d2b67.png">

# Dependency
- [TCA](https://github.com/pointfreeco/swift-composable-architecture)

# Rules
- [Swift Style Guide](https://github.com/airbnb/swift)
- [Commit Convention](docs/CommitConvention.md)
- Git Flow 적용
    - main, feature 브랜치 운영
    - 되도록 두줄

# [Issue](docs/Issue.md)