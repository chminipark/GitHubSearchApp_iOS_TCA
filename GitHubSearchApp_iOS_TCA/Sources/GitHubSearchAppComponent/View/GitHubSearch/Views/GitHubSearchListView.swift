//
//  GitHubSearchListView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/23.
//

import SwiftUI
import ComposableArchitecture

struct GitHubSearchListView: View {
  let store: StoreOf<GitHubSearchStore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        List {
          ForEachStore(store.scope(
            state: \.searchResults,
            action: GitHubSearchStore.Action.forEachRepos(id: action:))
          ) { myStore in
            GitHubSearchListRowView(store: myStore)
          }
          
          if !viewStore.searchResults.isEmpty {
            HStack {
              Spacer()
              ProgressView()
                .onAppear {
                  viewStore.send(.paginationRepo)
                }
              Spacer()
            }
          }
        }
        .sheet(isPresented: viewStore.binding(\.$showSafari)) {
          SafariView(url: viewStore.url!)
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
}

struct GitHubSearchView_Previews: PreviewProvider {
  static var previews: some View {
    GitHubSearchListView(
      store: Store(
        initialState: GitHubSearchStore.State(),
        reducer: GitHubSearchStore()
      )
    )
  }
}
