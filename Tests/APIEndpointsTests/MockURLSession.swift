//
//  File.swift
//  GitHubSearchApp_iOS_TCA_Tests
//
//  Created by minii on 2023/03/08.
//

import Foundation
@testable import GitHubSearchApp_iOS_TCA

class MockURLSession: URLSessionable {
  var isFail: Bool
  
  init(isFail: Bool) {
    self.isFail = isFail
  }
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    let data = APIMockData.searchRepoResponseDTO
    let successResponse = HTTPURLResponse(url: request.url!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
    let failureResponse = HTTPURLResponse(url: request.url!,
                                          statusCode: 500,
                                          httpVersion: nil,
                                          headerFields: nil)
    
    try? await Task.sleep(for: .seconds(5))
    if isFail {
      return (Data(), failureResponse ?? URLResponse())
    } else {
      return (data, successResponse ?? URLResponse())
    }
  }
}
