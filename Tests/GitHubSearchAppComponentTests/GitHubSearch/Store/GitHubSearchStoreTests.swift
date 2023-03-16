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
    let testStore = TestStore(initialState: GitHubSearchStore.State(),
                          reducer: GitHubSearchStore())
    let testSearchText = "testSearchText"
    
    // then
    await testStore.send(.set(\.$searchQuery, testSearchText)) {
      $0.searchQuery = testSearchText
    }
  }
  
  func testSearchRepoAndResponse_Success() async {
    // given, when
    let testSearchText = "123"
    let mockRepoList = Repository.mockRepoList(testSearchText.count)
    let testSearchResults: IdentifiedArrayOf<GitHubSearchRowStore.State>
    = IdentifiedArrayOf(
      uniqueElements: mockRepoList.map { repo in
        GitHubSearchRowStore.State(repo: repo)
      }
    )
    let testStore = TestStore(
      initialState: GitHubSearchStore.State(searchQuery: testSearchText),
      reducer: GitHubSearchStore()
    ) { testDependency in
      testDependency.gitHubSearchClient.apiFetchData = { _, _ in
        return mockRepoList
      }
      
      testDependency.gitHubSearchClient.matchStarButtonStates = { _ in
        return testSearchResults
      }
    }
    
    // then
    await testStore.send(.searchRepo) {
      $0.isLoading = true
    }
    
    await testStore.receive(.searchResponse(.success(testSearchResults))) {
      $0.searchResults = testSearchResults
      $0.isLoading = false
    }
  }
  
  func testSearchRepoAndResponse_Fail() async {
    // given, when
    let testSearchText = "123"
    let testError = NetworkError.noDataError
    let testStore = TestStore(
      initialState: GitHubSearchStore.State(
        searchQuery: testSearchText
      ),
      reducer: GitHubSearchStore()
    ) { testDependency in
      testDependency.gitHubSearchClient.apiFetchData = { _, _ in
        throw testError
      }
    }
    
    // then
    await testStore.send(.searchRepo) {
      $0.isLoading = true
    }

    await testStore.receive(.searchResponse(.failure(testError))) {
      $0.isLoading = false
    }
  }
  
  func testPaginationRepoAndResponse_Success() async {
    // given, when
    let testSearchText = "123"
    let mockRepoList = Repository.mockRepoList(testSearchText.count)
    let testSearchResults: IdentifiedArrayOf<GitHubSearchRowStore.State>
    = IdentifiedArrayOf(
      uniqueElements: mockRepoList.map { repo in
        GitHubSearchRowStore.State(repo: repo)
      }
    )
    let testStore = TestStore(
      initialState: GitHubSearchStore.State(
        searchQuery: testSearchText,
        currentPage: 2,
        searchResults: testSearchResults
      ),
      reducer: GitHubSearchStore()) { testDependency in
        testDependency.gitHubSearchClient.apiFetchData = { _, _ in
          return mockRepoList
        }
        
        testDependency.gitHubSearchClient.matchStarButtonStates = { _ in
          return testSearchResults
        }
      }
    
    // then
    await testStore.send(.paginationRepo) {
      $0.isLoading = true
      $0.currentPage = 3
    }
    
    await testStore.receive(.paginationResponse(.success(testSearchResults))) {
      $0.searchResults += testSearchResults
      $0.isLoading = false
    }
  }
  
  func testPaginationRepoAndResponse_Fail() async {
    // given, when
    let testSearchText = "123"
    let testError = NetworkError.noDataError
    let mockRepoList = Repository.mockRepoList(testSearchText.count)
    let testSearchResults: IdentifiedArrayOf<GitHubSearchRowStore.State>
    = IdentifiedArrayOf(
      uniqueElements: mockRepoList.map { repo in
        GitHubSearchRowStore.State(repo: repo)
      }
    )
    let testStore = TestStore(
      initialState: GitHubSearchStore.State(
        searchQuery: testSearchText,
        currentPage: 2,
        searchResults: testSearchResults
      ),
      reducer: GitHubSearchStore()) { testDependency in
        testDependency.gitHubSearchClient.apiFetchData = { _, _ in
          throw testError
        }
      }
    
    // then
    await testStore.send(.paginationRepo) {
      $0.isLoading = true
      $0.currentPage = 3
    }
    
    await testStore.receive(.paginationResponse(.failure(testError))) {
      $0.isLoading = false
    }
  }
}
