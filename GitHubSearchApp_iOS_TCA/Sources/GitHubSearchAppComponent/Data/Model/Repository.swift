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
  
  static func mock(_ index: Int = 1) -> Repository {
    Repository(name: "repository name : \(index)",
               description: "repository description : \(index)",
               starCount: index,
               urlString: "urlString : \(index)"
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
