//
//  SearchRepoRequestDTO.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/07.
//

import Foundation

struct SearchRepoRequestDTO: Encodable {
  let searchText: String
  let perPage: Int = 20
  let currentPage: Int
  
  enum CodingKeys: String, CodingKey {
    case searchText = "q"
    case perPage = "per_page"
    case currentPage = "page"
  }
}
