//
//  GitHubSearchView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/23.
//

import SwiftUI
import ComposableArchitecture

struct GitHubSearchView: View {
  let store: StoreOf<GitHubSearchStore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        ForEach(viewStore.searchResults) { repo in
          Text(repo.name)
        }
      }
      .navigationTitle("GitHubSearch")
      .searchable(text: viewStore.binding(\.$searchQuery))
      .task(id: viewStore.searchQuery) {
        do {
          try await Task.sleep(for: .seconds(1))
          viewStore.send(.searchRepo)
        } catch {
        }
      }
    }
  }
}

struct GitHubSearchView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      GitHubSearchView(
        store: Store(
          initialState: GitHubSearchStore.State(),
          reducer: GitHubSearchStore()
        )
      )
    }
  }
}
