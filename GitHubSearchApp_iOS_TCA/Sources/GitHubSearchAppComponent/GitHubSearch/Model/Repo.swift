//
//  Repo.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/27.
//

import Foundation

struct Repo: Equatable, Identifiable {
  var name: String
  var description: String
  var htmlURL: String
  var starCount: Int
  var id: String { self.htmlURL }
  
  static func mock() -> Repo {
    Repo(name: "repo name",
         description: "repo description",
         htmlURL: "htmlURL",
         starCount: 100
    )
  }
  
  static func mockRepoList(_ count: Int = 20) -> [Repo] {
    (1...count).map { index in
      Repo(name: "name : \(index)",
           description: "description : \(index)",
           htmlURL: "htmlURL : \(index)",
           starCount: 100
      )
    }
  }
}
