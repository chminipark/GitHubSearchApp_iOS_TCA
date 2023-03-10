//
//  GitHubSearchListRowView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI
import ComposableArchitecture

struct GitHubSearchListRowView: View {
  let store: StoreOf<GitHubSearchListRowStore>
  let repository: Repository
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        VStack(alignment: .leading) {
          Text(repository.name)
            .font(.title.bold())
          Text(repository.description)
        }
        
        Spacer()
        
        VStack {
          Button {
            viewStore.send(.tapStarButton)
          } label: {
            Image(systemName: viewStore.starButtonState ? "star.fill" : "star")
          }
          .buttonStyle(.borderless)
          Text("\(repository.starCount)")
        }
      }
      .onChange(of: viewStore.starButtonState) { newValue in
        print(viewStore.starButtonState)
      }
    }
  }
}

struct GitHubSearchListRowStore: ReducerProtocol {
  struct State: Equatable {
    var starButtonState = false
  }
  
  enum Action: Equatable {
    case tapStarButton
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .tapStarButton:
      state.starButtonState.toggle()
      return .none
    }
  }
}

struct GitHubSearchListRowView_Previews: PreviewProvider {
  static var previews: some View {
    GitHubSearchListRowView(store: Store(initialState: GitHubSearchListRowStore.State(), reducer: GitHubSearchListRowStore()), repository: .mock())
  }
}
