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
  func testToggleStarButtonState_Success() async {
    let isSuccess = true
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(repo: mockRepo),
      reducer: GitHubSearchRowStore()
    )
    
    await testStore.send(.toggleStarButtonState(isSuccess: isSuccess)) {
      $0.starButtonState = isSuccess
    }
  }
  
  func testToggleStarButtonState_Fail() async {
    let isSuccess: Bool? = nil
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(repo: mockRepo),
      reducer: GitHubSearchRowStore()
    )
    
    await testStore.send(.toggleStarButtonState(isSuccess: isSuccess))
  }
  
  func testTapStarButton_Add() async {
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
    
    await testStore.send(.tapStarButton)
    
    await testStore.receive(.toggleStarButtonState(isSuccess: true)) {
      $0.starButtonState = true
    }
  }
  
  func testTapStarButton_Remove() async {
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(
        repo: mockRepo,
        starButtonState: true
      ),
      reducer: GitHubSearchRowStore()
    ) { testDependency in
      testDependency.gitHubSearchClient.removeRepoInCoreData = { _ in
        return false
      }
    }
    
    await testStore.send(.tapStarButton)
    
    await testStore.receive(.toggleStarButtonState(isSuccess: false)) {
      $0.starButtonState = false
    }
  }
  
  func testShowSafari() async {
    let mockRepo = Repository.mock()
    let testStore = TestStore(
      initialState: GitHubSearchRowStore.State(repo: mockRepo),
      reducer: GitHubSearchRowStore()
    )
    
    await testStore.send(.showSafari(isShow: true)) {
      $0.isShowSafari = true
    }
  }
}
