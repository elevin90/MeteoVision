//
//  WeatherUnits.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import Foundation

enum WeatherUnits: Int, CaseIterable {
  case system
  case standard
  case metric
  
  var title: String {
    switch self {
    case .system:
      "Default sustem units"
    case .standard:
      "Fahrenheit"
    case .metric:
      "Celsisus"
    }
  }
  
  var apiValue: String {
    switch self {
    case .system:
      let locale = NSLocale.current as NSLocale
      let unitValue = locale.object(forKey: NSLocale.Key(rawValue: "kCFLocaleTemperatureUnitKey")) as? String
      return unitValue ?? "standard"
    case .standard:
      return "standard"
    case .metric:
      return "metric"
    }
  }
}
