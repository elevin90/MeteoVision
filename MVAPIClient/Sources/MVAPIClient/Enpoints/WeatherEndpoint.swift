//
//  WeatherEndpoint.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

enum WeatherEndpoint {
  case currentDay(latitude: String, longtitude: String, units: String)
  case currentPollution(latitude: String, longtitude: String)
}

extension WeatherEndpoint: MVEndpoint {
  var host: String {
    "api.openweathermap.org"
  }
  var path: String {
    return switch self {
    case .currentDay(_, _, _):
      "/data/2.5/weather"
    case .currentPollution(_, _):
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
    case .currentDay(let latitude, let longtitude, let units):
      [
        URLQueryItem(name: "APPID", value: "dfb922ad45c3a804ffd35ac0a5c94587"),
        URLQueryItem(name: "lon", value: longtitude),
        URLQueryItem(name: "lat", value: latitude),
        URLQueryItem(name: "units", value: units)
      ]
    case .currentPollution(let latitude, let longtitude):
      [
        URLQueryItem(name: "APPID", value: "dfb922ad45c3a804ffd35ac0a5c94587"),
        URLQueryItem(name: "lon", value: longtitude),
        URLQueryItem(name: "lat", value: latitude)
      ]
    }
  }
  
  var body: [String: Any]? {
    nil
  }
}
