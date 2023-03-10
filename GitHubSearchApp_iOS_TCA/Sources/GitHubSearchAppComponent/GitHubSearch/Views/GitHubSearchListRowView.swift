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
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        VStack(alignment: .leading) {
          Text(viewStore.repo.name)
            .font(.title.bold())
          Text(viewStore.repo.description)
        }
        
        Spacer()
        
        VStack {
          Button {
            viewStore.send(.tapStarButton)
          } label: {
            Image(systemName: viewStore.starButtonState ? "star.fill" : "star")
          }
          .buttonStyle(.borderless)
          Text("\(viewStore.repo.starCount)")
        }
      }
      .onChange(of: viewStore.starButtonState) { newValue in
        print(viewStore.starButtonState)
      }
    }
  }
}

struct GitHubSearchListRowStore: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var repo: Repository
    var starButtonState = false
    var id: String { repo.urlString }
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
    GitHubSearchListRowView(
      store: Store(
        initialState: GitHubSearchListRowStore.State(repo: .mock()),
        reducer: GitHubSearchListRowStore()
      )
    )
  }
}
