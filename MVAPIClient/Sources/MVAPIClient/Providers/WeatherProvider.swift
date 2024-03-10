//
//  WeatherService.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

public protocol WeatherProviding: MVAPIPClient {
  func getCurrentWeather(latitude: String, longtitude: String, units: String) async throws -> CurrentWeather
  func getCurrentAirPollution(latitude: String, longtitude: String) async throws -> AirPolution
}

public final class WeatherProvider: WeatherProviding {
  public func getCurrentAirPollution(latitude: String, longtitude: String) async throws -> AirPolution {
    do {
      let response = try await sendRequest(endPoint: WeatherEndpoint.currentPollution(latitude: latitude, longtitude: longtitude), responseModel: AirQualityResponse.self)
      
      if let airPolution = response.airQualityList.first?.airPolution {
        return airPolution
      } else {
        throw URLError(.dataNotAllowed)
      }
    } catch {
      throw error
    }
  }
  
  public init() { }
  
  public func getCurrentWeather(latitude: String, longtitude: String, units: String) async throws -> CurrentWeather {
    try await sendRequest(endPoint: WeatherEndpoint.currentDay(latitude: latitude, longtitude: longtitude, units: units), responseModel: CurrentWeather.self)
  }
}
