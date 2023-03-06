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
  var id: String { self.htmlURL }
  
  static func mock(_ count: Int = 20) -> [Repo] {
    (1...count).map { index in
      Repo(name: "name : \(index)",
           description: "description : \(index)",
           htmlURL: "htmlURL : \(index)")
    }
  }
}
