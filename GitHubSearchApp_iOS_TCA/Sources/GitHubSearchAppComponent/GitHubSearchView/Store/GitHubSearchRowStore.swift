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
    var isShowSafari = false
    var id: String { repo.urlString }
  }
  
  enum Action: Equatable {
    case toggleStarButtonState(isSuccess: Bool?)
    case tapStarButton
    case showSafari(isShow: Bool)
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
        if !isStore {
          let isSuccess = await gitHubSearchClient.addToCoreData(repo)
          return .toggleStarButtonState(isSuccess: isSuccess)
        } else {
          let isSuccess = await gitHubSearchClient.removeRepoInCoreData(repo)
          return .toggleStarButtonState(isSuccess: isSuccess)
        }
      }
      
    case .showSafari(let isShow):
      state.isShowSafari = isShow
      return .none
    }
  }
}
