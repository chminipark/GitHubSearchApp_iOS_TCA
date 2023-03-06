//
//  GitHubSearchStore.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/27.
//

import SwiftUI
import ComposableArchitecture

struct GitHubSearchStore: ReducerProtocol {
  @Dependency(\.gitHubSearchClient) var gitHubSearchClient
  
  struct State: Equatable {
    @BindingState var searchQuery = ""
    var searchResults: [Repo] = []
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case searchRepo
    case searchResponse(TaskResult<[Repo]>)
  }
  
  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .searchRepo:
        guard !state.searchQuery.isEmpty else {
          return .none
        }
        return .task { [query = state.searchQuery] in
          await .searchResponse(TaskResult {
            try await self.gitHubSearchClient.search(query)
          })
        }
      case .searchResponse(.success(let response)):
        state.searchResults = response
        return .none
      case .searchResponse(.failure):
        print(".searchResponse Error")
        return .none
      }
    }
  }
}

// MARK: - API client interface

struct GitHubSearchClient {
  var search: @Sendable (String) async throws -> [Repo]
}

extension GitHubSearchClient: DependencyKey {
  static let liveValue = Self(
    search: { query in
      try await Task.sleep(for: .seconds(1))
      return Repo.mock(query.count+3)
    }
  )
  
  static let testValue = Self(
    search: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var gitHubSearchClient: GitHubSearchClient {
    get { self[GitHubSearchClient.self] }
    set { self[GitHubSearchClient.self] = newValue }
  }
}