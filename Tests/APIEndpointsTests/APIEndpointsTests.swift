//
//  APIEndpointsTests.swift
//  GitHubSearchAppComponentTests
//
//  Created by minii on 2023/03/07.
//

import XCTest
@testable import GitHubSearchApp_iOS_TCA

// teardown?
final class APIEndpointsTests: XCTestCase {
  var searchRepoRequestDTO: SearchRepoRequestDTO!
  var endpoint: Endpoint<SearchRepoResponseDTO>!
  
  override func setUpWithError() throws {
    self.searchRepoRequestDTO = SearchRepoRequestDTO(searchText: "searchText", currentPage: 1)
    self.endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
  }
  
  func test_ProviderRequestWithSearchRepo_Success() async {
    // given
    let providerImpl = ProviderImpl(session: MockURLSession(isFail: false))
    
    // when
    let result = await providerImpl.request(endpoint: self.endpoint)
    
    // then
    switch result {
    case .success(let searchRepoResponseDTO):
      XCTAssertEqual(searchRepoResponseDTO.totalCount, 39)
    case .failure:
      XCTFail()
    }
  }
  
  func test_ProviderRequestWithSearchRepo_Fail() async {
    // given
    let providerImpl = ProviderImpl(session: MockURLSession(isFail: true))
    
    // when
    let result = await providerImpl.request(endpoint: self.endpoint)
    
    // then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error, NetworkError.statusCodeError(500))
    case .success:
      XCTFail()
    }
  }
}
