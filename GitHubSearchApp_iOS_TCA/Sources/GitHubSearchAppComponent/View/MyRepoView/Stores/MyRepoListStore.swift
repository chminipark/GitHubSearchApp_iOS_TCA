//
//  MyRepoListStore.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/16.
//

import ComposableArchitecture
import Foundation

struct MyRepoListStore: ReducerProtocol {
  struct State: Equatable {
    var url: URL? = nil
    @BindingState var showSafari = false
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case tapListCell(selectedItem: Repository)
  }
  
  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .tapListCell(let selectedRepo):
        if let url = URL(string: selectedRepo.urlString) {
          state.url = url
          state.showSafari.toggle()
        }
        return .none
      }
    }
  }
}
