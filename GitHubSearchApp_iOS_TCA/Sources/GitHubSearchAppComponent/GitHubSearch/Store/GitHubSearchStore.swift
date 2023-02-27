//
//  GitHubSearchStore.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/27.
//

import SwiftUI
import ComposableArchitecture

struct GitHubSearchStore: ReducerProtocol {
  struct State: Equatable {
    @BindingState var searchQuery = ""
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
  }
                 
  var body: some ReducerProtocol<State, Action> {
     BindingReducer()
   }
}
