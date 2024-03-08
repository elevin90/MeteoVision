//
//  WeatherDetailsCityCellViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import MVAPIClient

struct WeatherDetailsCityCellViewModel: WeatherDetailViewModeling {
  let cellId = "WeatherDetailsCityCell"
  let location: String?
  let weatherDescription: String?
  let temperature: String?
  let maxTemperature: String?
  let minimalTemperature: String?
  let statusCode: Int?
  
  var weatherIconName: String? {
    guard let statusCode else {
      return nil
    }
    switch statusCode {
    case 200...299: return "cloud.bolt"
    case 300...599: return "cloud.rain"
    case 600...699: return "cloud.snow"
    case 700...799: return "cloud.fog"
    case 800: return "sun.max"
    case 801: return "cloud.sun"
    default: return "cloud"
    }
  }
  
  init(
    location: String? = nil,
    weatherConditions: WeatherConditions? = nil,
    temperature: Double? = nil,
    maxTemperature: Double? = nil,
    minimalTemperature: Double? = nil
  ) {
    self.location = location
    self.temperature =  temperature.map { "\(Int($0.rounded()))°" }
    self.maxTemperature = maxTemperature.map { "\(Int($0.rounded()))°" }
    self.minimalTemperature = minimalTemperature.map { "\(Int($0.rounded()))°" }
    self.statusCode = weatherConditions?.id ?? 0
    guard let weatherConditions else {
      self.weatherDescription = nil
      return
    }
    self.weatherDescription = "\(weatherConditions.condition), \(weatherConditions.description)"
  }
}
