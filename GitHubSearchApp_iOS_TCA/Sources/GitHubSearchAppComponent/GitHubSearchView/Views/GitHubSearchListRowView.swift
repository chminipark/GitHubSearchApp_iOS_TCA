//
//  GitHubSearchListRowView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI
import ComposableArchitecture
import SafariServices

struct GitHubSearchListRowView: View {
  let store: StoreOf<GitHubSearchRowStore>
  
  @State var showSafari = false
  @State var urlString = ""
  
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
      .onTapGesture {
        showSafari = true
      }
      .sheet(isPresented: $showSafari) {
        if let url = URL(string: viewStore.repo.urlString) {
          SafariView(url: url)
        } else {
          EmptyView()
        }
      }
    }
  }
}

struct SafariView: UIViewControllerRepresentable {
  let url: URL
  
  func makeUIViewController(
    context: UIViewControllerRepresentableContext<SafariView>
  ) -> SFSafariViewController {
    return SFSafariViewController(url: url)
  }
  
  func updateUIViewController(
    _ uiViewController: SFSafariViewController,
    context: UIViewControllerRepresentableContext<SafariView>
  ) {
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
