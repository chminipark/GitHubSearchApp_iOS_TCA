//
//  GitHubSearchClient.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/13.
//

import Foundation
import ComposableArchitecture

struct GitHubSearchClient {
  var apiFetchData: @Sendable (String, Int) async -> [Repository]
  var addToCoreData: @Sendable (Repository) async -> Bool?
  var removeRepoInCoreData: @Sendable (Repository) async -> Bool?
}

extension GitHubSearchClient: DependencyKey {
  static let liveValue = Self(
    apiFetchData: { query, page in
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
    },
    
    addToCoreData: { repo in
      let isSuccess = await CoreDataManager.shared.add(repo) == nil ? true : nil
      return isSuccess
    },
    
    removeRepoInCoreData: { repo in
      let isSuccess = await CoreDataManager.shared.remove(repo) == nil ? nil : false
      return isSuccess
    }
  )
  
  static let testValue = Self(
    apiFetchData: unimplemented("\(Self.self) testValue of search"),
    addToCoreData: unimplemented("\(Self.self) testValue of search"),
    removeRepoInCoreData: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var gitHubSearchClient: GitHubSearchClient {
    get { self[GitHubSearchClient.self] }
    set { self[GitHubSearchClient.self] = newValue }
  }
}
