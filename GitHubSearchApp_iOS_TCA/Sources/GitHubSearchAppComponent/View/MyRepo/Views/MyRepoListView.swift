//
//  MyRepoListView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI
import ComposableArchitecture

struct MyRepoListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MyRepo.name, ascending: false)])
  private var myRepos: FetchedResults<MyRepo>
  
  let store: StoreOf<MyRepoListStore>
  
  
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        List {
          ForEach(myRepos) { myRepo in
            if let repo = myRepo.toDomain() {
              myRepoRow(repo: repo, viewStore: viewStore)
                .onTapGesture {
                  viewStore.send(.tapListCell(selectedItem: repo))
                }
            } else {
              EmptyView()
            }
          }
        }
        .sheet(isPresented: viewStore.binding(\.$showSafari)) {
          SafariView(url: viewStore.url!)
        }
        .navigationTitle("MyRepo")
      }
    }
  }
  
  func myRepoRow(
    repo: Repository,
    viewStore: ViewStore<MyRepoListStore.State, MyRepoListStore.Action>
  ) -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text(repo.name)
          .font(.title.bold())
        Text(repo.description)
      }
      
      Spacer()
      
      VStack {
        Button {
          viewStore.send(.tapStarButton(selectedItem: repo))
        } label: {
          Image(systemName: "star.fill")
        }
        .buttonStyle(.borderless)
        Text("\(repo.starCount)")
      }
    }
  }
}
