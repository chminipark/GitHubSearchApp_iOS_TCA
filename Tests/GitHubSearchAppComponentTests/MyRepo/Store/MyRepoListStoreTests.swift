//
//  MyRepoListStoreTests.swift
//  GitHubSearchApp_iOS_TCA_Tests
//
//  Created by minii on 2023/03/16.
//

import XCTest
import ComposableArchitecture
@testable import GitHubSearchApp_iOS_TCA

@MainActor
final class MyRepoListStoreTests: XCTestCase {
  func testTapListCell() async {
    let testStore = TestStore(
      initialState: MyRepoListStore.State(),
      reducer: MyRepoListStore()
    )
    
    let selectedItem = Repository(
      name: "swift-composable-architecture",
      description: "A library for building applications in a consistent and understandable way, with composition, testing, and ergonomics in mind.",
      starCount: 8200,
      urlString: "https://github.com/pointfreeco/swift-composable-architecture"
    )
    
    let url = URL(string: selectedItem.urlString)!
    await testStore.send(.tapListCell(selectedItem: selectedItem)) {
      $0.url = url
      $0.showSafari.toggle()
    }
  }
}
