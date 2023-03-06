//
//  GitHubSearchStoreTests.swift
//  GitHubSearchAppComponentTests
//
//  Created by minii on 2023/02/24.
//

import XCTest
import SwiftUI
import ComposableArchitecture
@testable import GitHubSearchApp_iOS_TCA

@MainActor
final class GitHubSearchStoreTests: XCTestCase {
  func testBindingSearchTextToSearchQuery() async {
    // given, when
    let store = TestStore(initialState: GitHubSearchStore.State(),
                          reducer: GitHubSearchStore())
    let testSearchText = "testSearchText"
    
    // then
    await store.send(.set(\.$searchQuery, testSearchText)) {
      $0.searchQuery = testSearchText
    }
  }
  
  func testSearchRepo() async {
    // given, when
    let testSearchText = "123"
    let store = TestStore(initialState: GitHubSearchStore.State(),
                          reducer: GitHubSearchStore()) { testDependency in
      testDependency.gitHubSearchClient.search = { _ in
        return Repo.mockRepoList(testSearchText.count)
      }
    }
    
    await store.send(.set(\.$searchQuery, testSearchText)) {
      $0.searchQuery = testSearchText
    }
    
    await store.send(.searchRepo)
    
    await store.receive(.searchResponse(.success(
      Repo.mockRepoList(testSearchText.count)
    ))) {
      $0.searchResults = Repo.mockRepoList(testSearchText.count)
    }
  }
}
