//
//  MWWeatherCacheProviding.swift
//
//  Created by YAUHENI LEVIN on 17.03.24.
//

import MVAPIClient
import Foundation

public enum MVWeatherCacheError: Error {
  case encodingFailed
  case decodingFailed
  case noDataFound
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
      throw MVWeatherCacheError.encodingFailed
    }
  }
  
  /// Gets previously saved OpenWeatherMap response from local json file
  /// - Parameters:
  ///   - type: Response codable model type
  public func read<T: Codable>(type: MVWeatherCacheResponse) throws -> T? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      throw MVWeatherCacheError.noDocumentsFolderFound
    }
    let fileURL = documentsDirectory.appendingPathComponent("\(type.cacheFileName).json", isDirectory: false)
    do {
      let jsonData = try Data(contentsOf: fileURL)
      switch type {
      case .weather:
        return try? JSONDecoder().decode(CurrentWeather.self, from: jsonData) as? T
      case .pollution:
        return try? JSONDecoder().decode(AirPolution.self, from: jsonData) as? T
      }
    } catch {
      throw MVWeatherCacheError.noDataFound
    }
  }
}
