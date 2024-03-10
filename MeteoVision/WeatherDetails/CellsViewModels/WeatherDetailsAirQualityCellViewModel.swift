//
//  WeatherDetailsAirQualityCellViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 9.03.24.
//

import UIKit

final class WeatherDetailsAirQualityCellViewModel: WeatherDetailViewModeling {
  let cellId = WeatherDetailsAirQualityCell.defaultReuseIdentifier
  let state: WeatherDetailsCellViewModelState
  let aqiViewModel: AirQualityIndexViewModel?
  let aqiDescription: String
  
  init(state: WeatherDetailsCellViewModelState = .loading, index: Int = 0) {
    self.aqiViewModel = .init(index: index)
    self.state = state
    aqiDescription = switch index {
    case 1: "Good Air Quality"
    case 2, 3: "Moderate Air Quality"
    case 4: "Poor Air Quality"
    default: "Very Poor Air Quality"
    }
  }
}
