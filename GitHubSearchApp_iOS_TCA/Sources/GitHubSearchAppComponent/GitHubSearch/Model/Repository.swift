//
//  Repository.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/27.
//

import Foundation

struct Repository: Equatable, Identifiable {
  var name: String
  var description: String
  var starCount: Int
  var urlString: String
  var id: String { self.urlString }
  
  static func mock() -> Repository {
    Repository(name: "repository name",
               description: "repository description",
               starCount: 100,
               urlString: "urlString"
    )
  }
  
  static func mockRepoList(_ count: Int = 20) -> [Repository] {
    (1...count).map { index in
      Repository(name: "name : \(index)",
                 description: "description : \(index)",
                 starCount: 100,
                 urlString: "urlString : \(index)"
      )
    }
  }
}
