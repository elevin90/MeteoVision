//
//  WeatherService.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

public enum WeatherProviderError: Error {
  case weather
  case airQuality
}

public protocol WeatherProviding: MVAPIPClient {
  func getCurrentWeather(
    latitude: String,
    longtitude: String,
    units: String,
    apiKey: String
  ) async throws -> CurrentWeather
  func getCurrentAirPollution(
    latitude: String,
    longtitude: String,
    apiKey: String
  ) async throws -> AirPolution
}

public final class WeatherProvider: WeatherProviding {
  public func getCurrentAirPollution(
    latitude: String,
    longtitude: String,
    apiKey: String
  ) async throws -> AirPolution {
    do {
      let response = try await sendRequest(endPoint: WeatherEndpoint.currentPollution(latitude: latitude, longtitude: longtitude, apiKey: apiKey), responseModel: AirQualityResponse.self)
      
      if let airPolution = response.airQualityList.first?.airPolution {
        return airPolution
      } else {
        throw WeatherProviderError.airQuality
      }
    } catch {
      throw WeatherProviderError.airQuality
    }
  }
  
  public init() { }
  
  public func getCurrentWeather(latitude: String, longtitude: String, units: String,
                                apiKey: String) async throws -> CurrentWeather {
    do {
      let currentWeatherResponse = try await sendRequest(endPoint: WeatherEndpoint.currentDay(latitude: latitude, longtitude: longtitude, units: units, apiKey: apiKey), responseModel: CurrentWeather.self)
      return currentWeatherResponse
    } catch {
      throw WeatherProviderError.weather
    }
  }
}
