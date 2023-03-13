//
//  GitHubSearchClient.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/13.
//

import Foundation
import ComposableArchitecture

struct GitHubSearchClient {
  var fetchData: @Sendable (String, Int) async -> [Repository]
}

extension GitHubSearchClient: DependencyKey {
  static let liveValue = Self(
    fetchData: { query, page in
      let searchRepoRequestDTO = SearchRepoRequestDTO(searchText: query, currentPage: page)
      let endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
      let result = await ProviderImpl.shared.request(endpoint: endpoint)
      switch result {
      case .success(let response):
        return response.toDomain()
      case .failure(let error):
        print(error.description)
        return []
      }
    }
  )
  
  static let testValue = Self(
    fetchData: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var gitHubSearchClient: GitHubSearchClient {
    get { self[GitHubSearchClient.self] }
    set { self[GitHubSearchClient.self] = newValue }
  }
}
