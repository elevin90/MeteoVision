//
//  CurrentWeather.swift
//
//  Created by YAUHENI LEVIN on 06.03.24.
//

import Foundation

public struct Coordinates: Codable {
  public let longtitude: Double
  public let latitude: Double
  
  enum CodingKeys: String, CodingKey {
    case longtitude = "lon"
    case latitude = "lat"
  }
}

public struct CurrentWeatherWind: Codable {
  public let speed: Double
  public let degree: Double
  
  enum CodingKeys: String, CodingKey {
    case speed = "speed"
    case degree = "deg"
  }
}

public struct CurrentWeatherDetaisls: Codable {
  public let temperature: Double
  public let feelsLike: Double
  public let temperatureMin: Double
  public let temperatureMax: Double
  public let pressure: Int
  public let humidity: Int
  
  enum CodingKeys: String, CodingKey {
    case temperature = "temp"
    case feelsLike = "feels_like"
    case temperatureMin = "temp_min"
    case temperatureMax = "temp_max"
    case pressure
    case humidity
  }
}

public struct WeatherConditions: Codable {
  public let id: Int
  public let condition: String
  public let description: String
  public let iconPath: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case condition = "main"
    case description
    case iconPath = "icon"
  }
}

public struct WeatherSunDetails: Codable {
  public let sunrise: Int
  public let sunset: Int
  
  enum CodingKeys: String, CodingKey {
    case sunrise
    case sunset
  }
}

public struct CurrentWeather: Codable {
  public let coordinates: Coordinates
  public let conditions: [WeatherConditions]
  public let wind: CurrentWeatherWind
  public let details: CurrentWeatherDetaisls
  public let sunDetails: WeatherSunDetails
  public let city: String
  
  enum CodingKeys: String, CodingKey {
    case coordinates = "coord"
    case conditions = "weather"
    case details = "main"
    case sunDetails = "sys"
    case city = "name"
    case wind = "wind"
  }
}

