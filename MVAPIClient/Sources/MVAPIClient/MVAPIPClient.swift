//
//  MVAPIPClient.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

public protocol MVAPIPClient {
  func sendRequest<T: Decodable>(endPoint: MVEndpoint,
                                 responseModel: T.Type) async throws -> T
}

extension MVAPIPClient {
  public func sendRequest<T: Decodable>(endPoint: MVEndpoint,
                                 responseModel: T.Type) async throws -> T {
    var urlComponents = URLComponents()
    urlComponents.scheme = endPoint.scheme
    urlComponents.host = endPoint.host
    urlComponents.path = endPoint.path
    urlComponents.queryItems = endPoint.queryItems
    
    guard let url = urlComponents.url else {
      throw URLError(.badURL)
    }
    var request = URLRequest(url: url)
    request.httpMethod = endPoint.method.rawValue
    request.allHTTPHeaderFields = endPoint.header
    if let body = endPoint.body {
      request.httpBody = try? JSONSerialization.data(withJSONObject: body,
                                                     options: [])
    }
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let response = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
      }
      switch response.statusCode {
      case 200...299:
        guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
          throw URLError(.cannotDecodeRawData)
        }
        return decodedResponse
      case 401:
        throw URLError(.userAuthenticationRequired)
      default:
        throw URLError(.badServerResponse)
      }
    } catch {
      throw URLError(.unknown)
    }
  }
}
