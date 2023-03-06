//
//  GitHubSearchListRowView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI

struct GitHubSearchListRowView: View {
  let repo: Repo
  
  var body: some View {
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
          Image(systemName: "star")
        }
        .buttonStyle(.borderless)
        Text("\(repo.starCount)")
      }
    }
  }
}

struct GitHubSearchListRowView_Previews: PreviewProvider {
  static var previews: some View {
    GitHubSearchListRowView(repo: .mock())
  }
}
