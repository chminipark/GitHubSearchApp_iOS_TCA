//
//  MyRepoListView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI

struct MyRepoListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MyRepo.name, ascending: false)])
  private var myRepos: FetchedResults<MyRepo>
  
  var body: some View {
    NavigationView {
      List {
        ForEach(myRepos) { myRepo in
          if let repo = myRepo.toDomain() {
            myRepoRow(repo)
          } else {
            EmptyView()
          }
        }
      }
      .navigationTitle("MyRepo")
    }
  }

  func myRepoRow(_ repo: Repository) -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text(repo.name)
          .font(.title.bold())
        Text(repo.description)
      }
      
      Spacer()
      
      VStack {
        Button {
          Task {
            let removeError = await CoreDataManager.shared.remove(repo)
          }
        } label: {
          Image(systemName: "star.fill")
        }
        .buttonStyle(.borderless)
        Text("\(repo.starCount)")
      }
    }
  }
}
