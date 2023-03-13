//
//  APIEndpointsTests.swift
//  GitHubSearchAppComponentTests
//
//  Created by minii on 2023/03/07.
//

import XCTest
@testable import GitHubSearchApp_iOS_TCA

final class APIEndpointsTests: XCTestCase {
  var session: MockURLSession!
  var providerImpl: ProviderImpl!
  
  override func setUp() {
    super.setUp()
    self.session = MockURLSession(isFail: false)
    self.providerImpl = ProviderImpl(session: session)
  }
  
  override func tearDown() {
    self.session = nil
    self.providerImpl = nil
  }
  
  func test_ProviderRequestWithSearchRepo_Success() async {
    // given
    let searchRepoRequestDTO = SearchRepoRequestDTO(searchText: "searchText", currentPage: 1)
    let endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
    
    // when
    let result = await providerImpl.request(endpoint: endpoint)
    
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
    let searchRepoRequestDTO = SearchRepoRequestDTO(searchText: "searchText", currentPage: 1)
    let endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
    providerImpl = ProviderImpl(session: MockURLSession(isFail: true))
    
    // when
    let result = await providerImpl.request(endpoint: endpoint)
    
    // then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error, NetworkError.statusCodeError(500))
    case .success:
      XCTFail()
    }
  }
}
