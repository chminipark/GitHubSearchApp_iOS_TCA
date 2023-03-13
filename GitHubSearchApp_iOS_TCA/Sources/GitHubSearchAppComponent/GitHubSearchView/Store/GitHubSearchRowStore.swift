//
//  GitHubSearchRowStore.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/13.
//

import Foundation
import ComposableArchitecture

struct GitHubSearchRowStore: ReducerProtocol {
  let coreDataManager = CoreDataManager.shared
  
  struct State: Equatable, Identifiable {
    var repo: Repository
    var starButtonState = false
    var id: String { repo.urlString }
  }
  
  enum Action: Equatable {
    case toggleStarButtonState(isSuccess: Bool)
    case tapStarButton
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .toggleStarButtonState(let isSuccess):
      if isSuccess {
        state.starButtonState.toggle()
      }
      return .none
      
    case .tapStarButton:
      print(".tapStarButton in GitHubSearchRowStore")
      return .task { [repo = state.repo, isStore = state.starButtonState] in
        if !isStore {
          let isSuccess = await coreDataManager.add(repo) == nil ? true : false
          return .toggleStarButtonState(isSuccess: isSuccess)
        } else {
          let isSuccess = await coreDataManager.remove(repo) == nil ? true : false
          return .toggleStarButtonState(isSuccess: isSuccess)
        }
      }
    }
  }
}
