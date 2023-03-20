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
  func test_tapListCell() async {
    // given
    let testStore = TestStore(
      initialState: MyRepoListStore.State(),
      reducer: MyRepoListStore()
    )
    let selectedItem: Repository = .mock()
    
    // when, then
    await testStore.send(.tapListCell(selectedItem: selectedItem)) {
      if let url = URL(string: selectedItem.urlString) {
        $0.url = url
        $0.showSafari.toggle()
      }
    }
  }
  
  func test_tapStarButton() async {
    // given
    let mockRepo: Repository = .mock()
    let testStore = TestStore(
      initialState: MyRepoListStore.State(),
      reducer: MyRepoListStore()
    ) { testDependency in
      testDependency.gitHubSearchClient.removeRepoInCoreData = { _ in
        return false
      }
    }
    
    // when, then
    await testStore.send(.tapStarButton(selectedItem: mockRepo))
  }
}
