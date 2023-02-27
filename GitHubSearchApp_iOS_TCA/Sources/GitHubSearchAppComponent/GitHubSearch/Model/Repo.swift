//
//  Repo.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/27.
//

import Foundation

struct Repo: Identifiable {
  let name: String
  let description: String
  let htmlURL: String
  var id: String { self.htmlURL }
  
  static func mock(idx: Int = 1) -> Repo {
    self.init(name: "name : \(idx)",
              description: "description : \(idx)",
              htmlURL: "htmlURL : \(idx)")
  }
}
