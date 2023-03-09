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
    let mockRepoList = Repository.mockRepoList(testSearchText.count)
    let store = TestStore(initialState: GitHubSearchStore.State(),
                          reducer: GitHubSearchStore()) { testDependency in
      testDependency.gitHubSearchClient.fetchData = { _, _ in
        return mockRepoList
      }
    }

    // then
    await store.send(.set(\.$searchQuery, testSearchText)) {
      $0.searchQuery = testSearchText
    }
    
    await store.send(.searchRepo) {
      $0.isLoading = true
    }
    
    await store.receive(.searchResponse(.success(mockRepoList))) {
      $0.searchResults = mockRepoList
      $0.isLoading = false
    }
  }
  
  func testPaginationRepo() async {
    // given, when
    let testSearchText = "123"
    let mockRepoList = Repository.mockRepoList(testSearchText.count)
    let store = TestStore(initialState: GitHubSearchStore.State(searchQuery: testSearchText,
                                                                currentPage: 1,
                                                                searchResults: mockRepoList
                                                               ),
                          reducer: GitHubSearchStore()) { testDependency in
      testDependency.gitHubSearchClient.fetchData = { _, _ in
        return mockRepoList
      }
    }
    
    // then
    await store.send(.paginationRepo) {
      $0.isLoading = true
      $0.currentPage = 2
    }
    
    await store.receive(.paginationResponse(.success(mockRepoList))) {
      $0.searchResults += mockRepoList
      $0.isLoading = false
    }
  }
}
