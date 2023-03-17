//
//  GitHubSearchRowStore.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/13.
//

import Foundation
import ComposableArchitecture

struct GitHubSearchRowStore: ReducerProtocol {
  @Dependency(\.gitHubSearchClient) var gitHubSearchClient
  
  struct State: Equatable, Identifiable {
    var repo: Repository
    var starButtonState = false
    let id: UUID
    
    init(repo: Repository, starButtonState: Bool = false, id: UUID = UUID()) {
      self.repo = repo
      self.starButtonState = starButtonState
      self.id = id
    }
  }
  
  enum Action: Equatable {
    case toggleStarButtonState(isSuccess: Bool?)
    case tapStarButton
    case showSafari
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .toggleStarButtonState(let isSuccess):
      if let isSuccess = isSuccess {
        state.starButtonState = isSuccess
      }
      return .none
      
    case .tapStarButton:
      return .task { [repo = state.repo, isStore = state.starButtonState] in
        let isSuccess = await isStore ? gitHubSearchClient.removeRepoInCoreData(repo) : gitHubSearchClient.addToCoreData(repo)
        return .toggleStarButtonState(isSuccess: isSuccess)
      }
      
    case .showSafari:
      return .none
    }
  }
}
