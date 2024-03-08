//
//  WeatherUnitsProvider.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import Foundation

protocol WeatherUnitsProviding {
  func getWeatherUnits() -> [WeatherUnits]
  func select(weatherUnit: WeatherUnits)
  func getSelectedWeatherUnit() -> WeatherUnits
  var newUnitUpdateHandler: ((WeatherUnits) -> Void)? { get set }
}

final class WeatherUnitsProvider: WeatherUnitsProviding {
  var newUnitUpdateHandler: ((WeatherUnits) -> Void)?
  
  func getWeatherUnits() -> [WeatherUnits] {
    WeatherUnits.allCases
  }
  
  func select(weatherUnit: WeatherUnits) {
    guard getSelectedWeatherUnit().rawValue != weatherUnit.rawValue else {
      return
    }
    UserDefaults.standard.setValue(weatherUnit.rawValue, forKey: "WeatherUnits")
    newUnitUpdateHandler?(weatherUnit)
  }
  
  func getSelectedWeatherUnit() -> WeatherUnits {
    let selectedUnit = UserDefaults.standard.integer(forKey: "WeatherUnits")
    return WeatherUnits(rawValue: selectedUnit) ?? .system
  }
}
