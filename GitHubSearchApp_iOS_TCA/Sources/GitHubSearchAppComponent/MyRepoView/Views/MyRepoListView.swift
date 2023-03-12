//
//  MyRepoListView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI

/*
 일단 두개 뷰 사이에 버튼 색상 매칭만, store 생성유무 x, 그냥 fetchRequest 쓰고 나중에 리팩토링
 fetch 할때 각각의 Repository -> Coredata에 있는지 유무 트리거 (한번만 체크가 아닌)
 
 
 */

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
        } label: {
          Image(systemName: "star.fill")
        }
        .buttonStyle(.borderless)
        Text("\(repo.starCount)")
      }
    }
  }
}
