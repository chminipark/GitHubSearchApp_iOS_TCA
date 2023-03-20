//
//  GitHubSearchRowStoreTests.swift
//  GitHubSearchApp_iOS_TCA_Tests
//
//  Created by minii on 2023/03/15.
//

import XCTest
import SwiftUI
import ComposableArchitecture
@testable import GitHubSearchApp_iOS_TCA

@MainActor
final class GitHubSearchRowStoreTests: XCTestCase {
  func test_toggleStarButtonState_Success() async {
    // given
    let isSuccess = true
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(repo: mockRepo),
      reducer: GitHubSearchRowStore()
    )
    
    // when, then
    await testStore.send(.toggleStarButtonState(isSuccess: isSuccess)) {
      $0.starButtonState = isSuccess
    }
  }
  
  func test_toggleStarButtonState_Fail() async {
    // given
    let isSuccess: Bool? = nil
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(repo: mockRepo),
      reducer: GitHubSearchRowStore()
    )
    
    // when, then
    await testStore.send(.toggleStarButtonState(isSuccess: isSuccess))
  }
  
  func test_tapStarButtonAndAddToCoreData_Success() async {
    // given
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(
        repo: mockRepo,
        starButtonState: false
      ),
      reducer: GitHubSearchRowStore()
    ) { testDependency in
      testDependency.gitHubSearchClient.addToCoreData = { _ in
        return true
      }
    }
    
    // when, then
    await testStore.send(.tapStarButton)
    
    await testStore.receive(.toggleStarButtonState(isSuccess: true)) {
      $0.starButtonState = true
    }
  }
  
  func test_tapStarButton_Fail() async {
    // given
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(
        repo: mockRepo,
        starButtonState: true
      ),
      reducer: GitHubSearchRowStore()
    ) { testDependency in
      testDependency.gitHubSearchClient.removeRepoInCoreData = { _ in
        return nil
      }
    }
    
    // when, then
    await testStore.send(.tapStarButton)
    
    await testStore.receive(.toggleStarButtonState(isSuccess: nil))
  }
  
  func test_showSafari() async {
    // given
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(repo: mockRepo),
      reducer: GitHubSearchRowStore()
    )
    
    // when, then
    await testStore.send(.showSafari)
  }
}
