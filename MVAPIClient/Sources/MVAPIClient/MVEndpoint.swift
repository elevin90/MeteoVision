//
//  MVEndpoint.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

public enum MVRequestMethod: String {
  case get = "GET"
  case post = "POST"
  case delete = "DELETE"
  case patch = "PATCH"
  case put = "PUT"
}

public protocol MVEndpoint {
  var scheme: String { get }
  var host: String { get }
  var path: String { get }
  var method: MVRequestMethod { get }
  var header: [String: String]? { get }
  var body: [String: Any]? { get }
  var queryItems: [URLQueryItem] { get }
}

extension MVEndpoint {
  var scheme: String {
    "https"
  }
}
