//
//  GitHubSearchClient.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/13.
//

import Foundation
import ComposableArchitecture

struct GitHubSearchClient {
  var apiFetchData: @Sendable (String, Int) async throws -> [Repository]
  var addToCoreData: @Sendable (Repository) async -> Bool?
  var removeRepoInCoreData: @Sendable (Repository) async -> Bool?
  var matchStarButtonStates: @Sendable ([Repository]) async -> IdentifiedArrayOf<GitHubSearchRowStore.State>
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
        throw error
      }
    },
    
    addToCoreData: { repo in
      let isSuccess = await CoreDataManager.shared.add(repo) == nil ? true : nil
      return isSuccess
    },
    
    removeRepoInCoreData: { repo in
      let isSuccess = await CoreDataManager.shared.remove(repo) == nil ? false : nil
      return isSuccess
    },
    
    matchStarButtonStates: { repos in
      var rowStoreStates: IdentifiedArrayOf<GitHubSearchRowStore.State> = []
      for repo in repos {
        let starButtonState = CoreDataManager.shared.inCoreData(repo)
        rowStoreStates.append(
          GitHubSearchRowStore.State(
            repo: repo,
            starButtonState: starButtonState,
            id: .init()
          )
        )
      }
      return rowStoreStates
    }
  )
  
  static let testValue = Self(
    apiFetchData: unimplemented("\(Self.self) testValue of search"),
    addToCoreData: unimplemented("\(Self.self) testValue of search"),
    removeRepoInCoreData: unimplemented("\(Self.self) testValue of search"),
    matchStarButtonStates: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var gitHubSearchClient: GitHubSearchClient {
    get { self[GitHubSearchClient.self] }
    set { self[GitHubSearchClient.self] = newValue }
  }
}
