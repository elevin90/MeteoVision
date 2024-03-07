//
//  WeatherEndpoint.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

enum WeatherEndpoint {
  case currentDay(latitude: String, longtitude: String)
}

extension WeatherEndpoint: MVEndpoint {
  var host: String {
    "api.openweathermap.org"
  }
  var path: String {
    return switch self {
    case .currentDay(_, _):
      "/data/2.5/weather"
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
    case .currentDay(let latitude, let longtitude):
      [
        URLQueryItem(name: "APPID", value: APIKeys.key),
        URLQueryItem(name: "lon", value: longtitude),
        URLQueryItem(name: "lat", value: latitude)
      ]
    }
  }
  
  var body: [String: Any]? {
    nil
  }
}
