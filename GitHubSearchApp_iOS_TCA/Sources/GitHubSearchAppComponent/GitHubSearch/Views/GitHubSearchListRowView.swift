//
//  GitHubSearchListRowView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import SwiftUI

struct GitHubSearchListRowView: View {
  let repository: Repository
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(repository.name)
          .font(.title.bold())
        Text(repository.description)
      }
      
      Spacer()
      
      VStack {
        Button {
          
        } label: {
          Image(systemName: "star")
        }
        .buttonStyle(.borderless)
        Text("\(repository.starCount)")
      }
    }
  }
}

struct GitHubSearchListRowView_Previews: PreviewProvider {
  static var previews: some View {
    GitHubSearchListRowView(repository: .mock())
  }
}
