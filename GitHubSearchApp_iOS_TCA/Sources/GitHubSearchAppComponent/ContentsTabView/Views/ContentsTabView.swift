//
//  ContentsTabView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI
import ComposableArchitecture

struct ContentsTabView: View {
  var body: some View {
    TabView {
      GitHubSearchListView(
        store: Store(
          initialState: GitHubSearchStore.State(),
          reducer: GitHubSearchStore()
        )
      )
      .tabItem {
        VStack {
          Image(systemName: "doc.text")
          Text("Repo")
        }
      }
      
      MyRepoView()
        .tabItem {
          VStack {
            Image(systemName: "bookmark")
            Text("Favorite")
          }
        }
    }
  }
}


// Repo
// doc.text
// doc.text.fill

//Favorite
//bookmark
//bookmark.fill
