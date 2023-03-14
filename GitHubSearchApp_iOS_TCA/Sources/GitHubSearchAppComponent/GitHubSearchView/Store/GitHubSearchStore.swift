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
  let coreDataManager = CoreDataManager.shared
  
  struct State: Equatable {
    @BindingState var searchQuery = ""
    var currentPage = 1
    var isLoading = false
    var searchResults: IdentifiedArrayOf<GitHubSearchRowStore.State> = []
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case searchRepo
    case searchResponse(TaskResult<[Repository]>)
    case paginationRepo
    case paginationResponse(TaskResult<[Repository]>)
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
            await self.gitHubSearchClient.apiFetchData(query, 1)
          })
        }
        
      case .searchResponse(.success(let response)):
        state.searchResults = []
        for repo in response {
          let starButtonState = coreDataManager.inCoreData(repo)
          state.searchResults.append(
            GitHubSearchRowStore.State(repo: repo,
                                       starButtonState: starButtonState)
          )
        }
        
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
            await self.gitHubSearchClient.apiFetchData(query, page)
          })
        }
        
      case .paginationResponse(.success(let response)):
        for repo in response {
          let starButtonState = coreDataManager.inCoreData(repo)
          state.searchResults.append(
            GitHubSearchRowStore.State(repo: repo,
                                       starButtonState: starButtonState)
          )
        }
        
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
}

extension CoreDataManager {
  func inCoreData(_ repo: Repository) -> Bool {
    let context = coreDataStorage.mainContext
    if let savedRepo = fetch(repo, context: context) {
      return true
    } else {
      return false
    }
  }
}
