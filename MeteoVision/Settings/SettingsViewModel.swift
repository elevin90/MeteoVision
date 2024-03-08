//
//  SettingsViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import Foundation

final class SettingsViewModel {
  private(set) var viewModels: [SettingsCellViewModel] = []
  private let weatherUnitsProvider: WeatherUnitsProviding
  
  init(weatherUnitsProvider: WeatherUnitsProviding) {
    self.weatherUnitsProvider = weatherUnitsProvider
    let selectedUnit = weatherUnitsProvider.getSelectedWeatherUnit()
    for unit in weatherUnitsProvider.getWeatherUnits() {
      viewModels.append(SettingsCellViewModel(title: unit.title, isSelected: selectedUnit.rawValue == unit.rawValue))
    }
  }
  
  func selectUnit(at index: Int) {
    guard viewModels[index].isSelected == false else {
      return
    }
    viewModels.forEach {
      $0.isSelected = false
    }
    viewModels[index].isSelected = true
    weatherUnitsProvider.select(weatherUnit: WeatherUnits(rawValue: index) ?? .system)
  }
}
