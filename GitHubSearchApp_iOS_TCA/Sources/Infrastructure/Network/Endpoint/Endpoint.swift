//
//  Endpoint.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/06.
//

import Foundation

protocol RequestResponsable: Requestable, Responsable {}

struct Endpoint<R>: RequestResponsable {
  typealias Response = R
  
  var baseURL: String
  var path: String
  var queryParameter: Encodable
  
  init(baseURL: String,
       path: String,
       queryParameter: Encodable) {
    self.baseURL = baseURL
    self.path = path
    self.queryParameter = queryParameter
  }
}
