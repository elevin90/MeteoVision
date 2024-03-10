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

public struct CurrentWeatherClouds: Codable {
  public let all: Double
  
  enum CodingKeys: String, CodingKey {
    case all
  }
}


public struct CurrentWeatherDetails: Codable {
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
  
  public static var preview: Self {
    .init(temperature: 11, feelsLike: 12, temperatureMin: 10, temperatureMax: 13, pressure: 1, humidity: 1)
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
  
  public static var preview: Self {
    .init(id: 1, condition: "Sunny", description: "Sunny", iconPath: "")
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
  public let details: CurrentWeatherDetails
  public let sunDetails: WeatherSunDetails
  public let city: String
  public let clouds: CurrentWeatherClouds
  
  enum CodingKeys: String, CodingKey {
    case coordinates = "coord"
    case conditions = "weather"
    case details = "main"
    case sunDetails = "sys"
    case city = "name"
    case wind = "wind"
    case clouds
  }
  
  public static var preview: Self {
    .init(coordinates: Coordinates(longtitude: 10, latitude: 11), conditions: [WeatherConditions.preview], wind: CurrentWeatherWind(speed: 11, degree: 2.0), details: CurrentWeatherDetails.preview, sunDetails: WeatherSunDetails(sunrise: 11, sunset: 12), city: "Baranovichi", clouds: .init(all: 12))
  }
}

