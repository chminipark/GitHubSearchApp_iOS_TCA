//
//  Provider.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import Foundation

protocol URLSessionable {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionable {}




protocol Provider {
  func request<E: RequestResponsable, R: Decodable>(endpoint: E)
  async -> Result<R, NetworkError>
  where E.Response == R
}

class ProviderImpl: Provider {
  static let shared = ProviderImpl(session: URLSession.shared)
  
  let session: URLSessionable
  
  init(session: URLSessionable) {
    self.session = session
  }
  
  func request<E: RequestResponsable, R: Decodable>(endpoint: E)
  async -> Result<R, NetworkError>
  where E.Response == R {
    var urlRequest: URLRequest
    do {
      urlRequest = try endpoint.makeURLRequest()
    } catch let error {
      if let urlRequestError = error as? URLRequestError {
        return .failure(NetworkError.urlReqeustError(urlRequestError))
      } else {
        return .failure(.unknownError)
      }
    }
    
    guard let tmp = try? await session.data(for: urlRequest) else {
      return .failure(.unknownError)
    }
    
    let data: Data = tmp.0
    let response: URLResponse = tmp.1
    let result = checkError(data: data, response: response)
    switch result {
    case .failure(let error):
      return .failure(error)
    case .success(let data):
      guard let decodedData = try? JSONDecoder().decode(R.self, from: data) else {
        return .failure(.decodingError)
      }
      return .success(decodedData)
    }
  }
  
  func checkError(data: Data, response: URLResponse) -> Result<Data, NetworkError> {
    guard let response = response as? HTTPURLResponse else {
      return .failure(.unknownError)
    }
    
    if response.statusCode != 200 {
      if response.statusCode == 403 {
        return .failure(.requestLimitError)
      }
      return .failure(.statusCodeError(response.statusCode))
    }
    
    if data.isEmpty {
      return .failure(.noDataError)
    }
    
    return .success(data)
  }
}
