//
//  GitHubSearchView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/23.
//

import SwiftUI

struct Repo: Identifiable {
  let name: String
  let description: String
  let htmlURL: String
  var id: String { self.htmlURL }
}

struct GitHubSearchView: View {
  @State var searchQueryString = ""
  var datas: [Repo] = (0...20).map { index in
    Repo(name: "name : \(index)",
         description: "description : \(index)",
         htmlURL: "htmlURL : \(index)")
  }
  var filteredDatas: [Repo] {
    if searchQueryString.isEmpty {
      return datas
    } else {
      return datas.filter { $0.name == "name : \(searchQueryString)"}
    }
  }
  
  var body: some View {
    NavigationView {
      List(filteredDatas) { data in
        NavigationLink {
          SomeView(name: data.name)
        } label: {
          Text(data.name)
        }
      }
      .listStyle(.plain)
      .navigationTitle("Search Test")
    }
    .searchable(
      text: $searchQueryString,
      placement: .navigationBarDrawer,
      prompt: "검색 placholder..."
    )
    .onSubmit(of: .search) {
      print("검색 완료: \(searchQueryString)")
    }
    .onChange(of: searchQueryString) { newValue in
      // viewModel 사용 시 이곳에서 새로운 값 입력
      print("검색 입력: \(newValue)")
    }
  }
}

struct SomeView: View {
  var name: String
  var body: some View {
    Text(name)
  }
}

struct GitHubSearchView_Previews: PreviewProvider {
  static var previews: some View {
    GitHubSearchView()
  }
}
