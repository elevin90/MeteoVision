//
//  WeatherEndpoint.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

enum WeatherEndpoint {
  case currentDay(latitude: String, longtitude: String, units: String, apiKey: String)
  case currentPollution(latitude: String, longtitude: String, apiKey: String)
}

extension WeatherEndpoint: MVEndpoint {
  var host: String {
    "api.openweathermap.org"
  }
  var path: String {
    return switch self {
    case .currentDay(_, _, _, _):
      "/data/2.5/weather"
    case .currentPollution(_, _, _):
      "/data/2.5/air_pollution"
    }
  }
  
  var method: MVRequestMethod {
    .get
  }
  
  var header: [String: String]? {
    ["Content-Type": "application/json"]
  }
  
  var queryItems: [URLQueryItem] {
    return switch self {
    case .currentDay(let latitude, let longtitude, let units, let apiKey):
      [
        URLQueryItem(name: "APPID", value: apiKey),
        URLQueryItem(name: "lon", value: longtitude),
        URLQueryItem(name: "lat", value: latitude),
        URLQueryItem(name: "units", value: units)
      ]
    case .currentPollution(let latitude, let longtitude, let apiKey):
      [
        URLQueryItem(name: "APPID", value: apiKey),
        URLQueryItem(name: "lon", value: longtitude),
        URLQueryItem(name: "lat", value: latitude)
      ]
    }
  }
  
  var body: [String: Any]? {
    nil
  }
}
