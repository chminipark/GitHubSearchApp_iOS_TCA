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
    var currentPage = 1
    var isLoading = false
    var searchResults: IdentifiedArrayOf<GitHubSearchRowStore.State> = []
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case searchRepo
    case searchResponse(TaskResult<IdentifiedArrayOf<GitHubSearchRowStore.State>>)
    case paginationRepo
    case paginationResponse(TaskResult<IdentifiedArrayOf<GitHubSearchRowStore.State>>)
    case forEachRepos(id: GitHubSearchRowStore.State.ID,
                      action: GitHubSearchRowStore.Action)
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
        state.currentPage = 1
        state.isLoading = true
        return .task { [query = state.searchQuery] in
          await .searchResponse(TaskResult {
            let response = await self.gitHubSearchClient.apiFetchData(query, 1)
            return await matchStarButtonStates(response)
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
            let response = await self.gitHubSearchClient.apiFetchData(query, page)
            return await matchStarButtonStates(response)
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
        
      case .forEachRepos(id: let id, action: .tapStarButton):
        return .none
        
      case .forEachRepos(id: let id, action: .toggleStarButtonState):
        return .none
        
      case .forEachRepos(id: let id, action: .showSafari):
        return .none
      }
    }
    .forEach(\.searchResults, action: /Action.forEachRepos(id: action:)) {
      GitHubSearchRowStore()
    }
  }
  
  func matchStarButtonStates(_ repos: [Repository])
  async -> IdentifiedArrayOf<GitHubSearchRowStore.State> {
    var rowStoreStates: IdentifiedArrayOf<GitHubSearchRowStore.State> = []
    for repo in repos {
      let starButtonState = CoreDataManager.shared.inCoreData(repo)
      rowStoreStates.append(
        GitHubSearchRowStore.State(
          repo: repo,
          starButtonState: starButtonState
        )
      )
    }
    return rowStoreStates
  }
}