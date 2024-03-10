//
//  WeatherUnitsProvider.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import Foundation

protocol WeatherUnitsProviding {
  var newUnitUpdateHandler: ((WeatherUnits) -> Void)? { get set }
  func getWeatherUnits() -> [WeatherUnits]
  func select(weatherUnit: WeatherUnits)
  func getSelectedWeatherUnit() -> WeatherUnits
}

final class WeatherUnitsProvider: WeatherUnitsProviding {
  private let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  var newUnitUpdateHandler: ((WeatherUnits) -> Void)?
  
  func getWeatherUnits() -> [WeatherUnits] {
    WeatherUnits.allCases
  }
  
  func select(weatherUnit: WeatherUnits) {
    guard getSelectedWeatherUnit().rawValue != weatherUnit.rawValue else {
      return
    }
    userDefaults.setValue(weatherUnit.rawValue, forKey: "WeatherUnits")
    newUnitUpdateHandler?(weatherUnit)
  }
  
  func getSelectedWeatherUnit() -> WeatherUnits {
    let selectedUnit = userDefaults.integer(forKey: "WeatherUnits")
    return WeatherUnits(rawValue: selectedUnit) ?? .system
  }
}
