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

final class GitHubSearchStoreTests: XCTestCase {
  let store = TestStore(initialState: GitHubSearchStore.State(),
                        reducer: GitHubSearchStore())
 
  func testBindingSearchTextToSearchQuery() async {
    let testString = "TestString"    
    await store.send(.set(\.$searchQuery, testString)) {
      $0.searchQuery = testString
    }
  }
}
