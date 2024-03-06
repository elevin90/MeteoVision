//
//  WeatherService.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

public protocol WeatherProviding: MVAPIPClient {
  func getCurrentWeather(latitude: String, longtitude: String) async throws -> CurrentWeather
}

public final class WeatherProvider: WeatherProviding {
  public init() { }
  
  public func getCurrentWeather(latitude: String, longtitude: String) async throws -> CurrentWeather {
    try await sendRequest(endPoint: WeatherEndpoint.currentDay(latitude: latitude, longtitude: longtitude), responseModel: CurrentWeather.self)
  }
}
