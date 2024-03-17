//
//  WeatherUnits.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import Foundation

struct WeatherUnitTitles {
  // Used for application's units
  static func appTitle(for unit: WeatherUnits) -> String {
    switch unit {
    case .system:
      "Default sustem units"
    case .standard:
      "Fahrenheit"
    case .metric:
      "Celsisus"
    }
  }
  
  // Used for open weather units
  static func apiTitle(for unit: WeatherUnits, locale: NSLocale = NSLocale.current as NSLocale) -> String {
    switch unit {
    case .system:
      let unitValue = locale.object(forKey: NSLocale.Key(rawValue: "kCFLocaleTemperatureUnitKey")) as? String
      return unitValue?.lowercased() == "celsius" ? "metric" : "imperial"
    case .standard:
      return "imperial"
    case .metric:
      return "metric"
    }
  }
}

enum WeatherUnits: Int, CaseIterable {
  case system
  case standard
  case metric
}
