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
  func test_bindingSearchTextToSearchQuery() async {
    // given
    let testStore = TestStore(initialState: GitHubSearchStore.State(),
                          reducer: GitHubSearchStore())
    let testSearchText = "testSearchText"
    
    // when, then
    await testStore.send(.set(\.$searchQuery, testSearchText)) {
      $0.searchQuery = testSearchText
    }
  }
  
  func test_searchRepoAndResponse_Success() async {
    // given
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
    
    // when, then
    await testStore.send(.searchRepo) {
      $0.isLoading = true
    }
    
    await testStore.receive(.searchResponse(.success(testSearchResults))) {
      $0.searchResults = testSearchResults
      $0.isLoading = false
    }
  }
  
  func test_searchRepoAndResponse_Fail() async {
    // given
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
    
    // when, then
    await testStore.send(.searchRepo) {
      $0.isLoading = true
    }

    await testStore.receive(.searchResponse(.failure(testError))) {
      $0.isLoading = false
    }
  }
  
  func test_paginationRepoAndResponse_Success() async {
    // given
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
    
    // when, then
    await testStore.send(.paginationRepo) {
      $0.isLoading = true
      $0.currentPage = 3
    }
    
    await testStore.receive(.paginationResponse(.success(testSearchResults))) {
      $0.searchResults += testSearchResults
      $0.isLoading = false
    }
  }
  
  func test_paginationRepoAndResponse_Fail() async {
    // given
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
    
    // when, then
    await testStore.send(.paginationRepo) {
      $0.isLoading = true
      $0.currentPage = 3
    }
    
    await testStore.receive(.paginationResponse(.failure(testError))) {
      $0.isLoading = false
    }
  }
  
  func test_forEachRepos() async {
    // given
    let rowStoreStates: IdentifiedArrayOf<GitHubSearchRowStore.State>
    = .init(
      uniqueElements: [
        GitHubSearchRowStore.State(repo: .mock(1)),
        GitHubSearchRowStore.State(repo: .mock(2)),
        GitHubSearchRowStore.State(repo: .mock(3))
      ]
    )
    
    let testStore = TestStore(
      initialState: GitHubSearchStore.State(
        searchResults: rowStoreStates
      ),
      reducer: GitHubSearchStore()
    ) { testDependency in
      testDependency.gitHubSearchClient.addToCoreData = { _ in
        return true
      }
    }
    
    // when, then
    await testStore.send(.forEachRepos(id: rowStoreStates[0].id,
                                       action: .tapStarButton))
    
    await testStore.receive(.forEachRepos(id: rowStoreStates[0].id,
                                          action: .toggleStarButtonState(isSuccess: true))) {
      $0.searchResults[0].starButtonState = true
    }
    
    await testStore.send(.forEachRepos(id: rowStoreStates[0].id, action: .showSafari)) {
      let repo = $0.searchResults[0].repo
      if let url = URL(string: repo.urlString) {
        $0.url = url
        $0.showSafari.toggle()
      }
    }
  }
}
