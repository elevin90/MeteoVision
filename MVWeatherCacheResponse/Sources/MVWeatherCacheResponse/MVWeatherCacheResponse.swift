//
//  MWWeatherCacheProviding.swift
//
//  Created by YAUHENI LEVIN on 17.03.24.
//

import MVAPIClient
import Foundation

public enum MVWeatherCacheError: Error {
  case cannotEncodeModel
  case noDocumentsFolderFound
  case cannotSaveModel
}

public enum MVWeatherCacheResponse {
  case weather
  case pollution
  
  var cacheFileName: String {
    return switch self {
    case .weather:
      "Current_Weather_Response"
    case .pollution:
      "Air_Pollution_Response"
    }
  }
}

public protocol MVWeatherCacheProviding {
  func cache<T: Encodable>(_ response: T, type: MVWeatherCacheResponse) throws
}

public final class MVWeatherCacheProvider: MVWeatherCacheProviding {

  public init() { }
  
  /// Saves remote OpenWeatherMap response to local json file
  /// - Parameters:
  ///   - response: Remote OpenWeatherMap response codable model
  ///   - type: Response codable model type
  public func cache<T: Encodable>(_ response: T, type: MVWeatherCacheResponse) throws {
    do {
      let jsonData = try JSONEncoder().encode(response)
      guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        throw MVWeatherCacheError.noDocumentsFolderFound
      }
      let fileURL = documentsDirectory.appendingPathComponent("\(type.cacheFileName).json")
      do {
        try jsonData.write(to: fileURL)
      } catch {
        throw MVWeatherCacheError.cannotSaveModel
      }
    } catch {
      throw MVWeatherCacheError.cannotEncodeModel
    }
  }
}
