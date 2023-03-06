//
//  RootView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
  var body: some View {
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
