//
//  GitHubSearchListRowView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI
import ComposableArchitecture

struct GitHubSearchListRowView: View {
  let store: StoreOf<GitHubSearchRowStore>
  
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
    }
  }
}

struct GitHubSearchRowStore: ReducerProtocol {
  let coreDataManager = CoreDataManager.shared
  
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
      print(".tapStarButton in GitHubSearchRowStore")
      let myRepo = coreDataManager.add(state.repo)
      state.starButtonState.toggle()
      return .none
    }
  }
}

struct GitHubSearchListRowView_Previews: PreviewProvider {
  static var previews: some View {
    GitHubSearchListRowView(
      store: Store(
        initialState: GitHubSearchRowStore.State(repo: .mock()),
        reducer: GitHubSearchRowStore()
      )
    )
  }
}
