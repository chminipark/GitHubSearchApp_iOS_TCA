//
//  APIEndpoints.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/07.
//

import Foundation

struct APIEndpoints {
  static func searchRepo(with searchRepoRequestDTO: SearchRepoRequestDTO)
  -> Endpoint<SearchRepoResponseDTO> {
    return Endpoint(baseURL: "https://api.github.com/",
                    path: "/search/repositories",
                    queryParameter: searchRepoRequestDTO)
  }
}
