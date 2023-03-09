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
    var currentPage = 0
    var isLoading = false
    var searchResults: [Repository] = []
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case searchRepo
    case searchResponse(TaskResult<[Repository]>)
    case paginationRepo
    case paginationResponse(TaskResult<[Repository]>)
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
        state.currentPage = 0
        state.isLoading = true
        return .task { [query = state.searchQuery] in
          await .searchResponse(TaskResult {
            await self.gitHubSearchClient.fetchData(query, 0)
          })
        }
        
      case .searchResponse(.success(let response)):
        state.searchResults = response
        state.isLoading = false
        return .none
        
      case .searchResponse(.failure):
        print(".searchResponse Error")
        state.isLoading = false
        return .none
        
      case .paginationRepo:
        guard !state.searchResults.isEmpty else {
          return .none
        }
        state.currentPage += 1
        state.isLoading = true
        return .task { [query = state.searchQuery, page = state.currentPage] in
          await .paginationResponse(TaskResult {
            await self.gitHubSearchClient.fetchData(query, page)
          })
        }
        
      case .paginationResponse(.success(let response)):
        state.searchResults += response
        state.isLoading = false
        return .none
        
      case .paginationResponse(.failure):
        print(".paginationResponse Error")
        state.isLoading = false
        return .none
      }
    }
  }
}

// MARK: - API client interface

struct GitHubSearchClient {
  var fetchData: @Sendable (String, Int) async -> [Repository]
}

extension GitHubSearchClient: DependencyKey {
  static let liveValue = Self(
    fetchData: { query, page in
      let searchRepoRequestDTO = SearchRepoRequestDTO(searchText: query, currentPage: page)
      let endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
      let result = await ProviderImpl.shared.request(endpoint: endpoint)
      switch result {
      case .success(let response):
        return response.toDomain()
      case .failure(let error):
        print(error.description)
        return []
      }
    }
  )
  
  static let testValue = Self(
    fetchData: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var gitHubSearchClient: GitHubSearchClient {
    get { self[GitHubSearchClient.self] }
    set { self[GitHubSearchClient.self] = newValue }
  }
}
