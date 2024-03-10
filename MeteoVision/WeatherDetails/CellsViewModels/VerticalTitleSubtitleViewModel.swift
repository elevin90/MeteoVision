//
//  VerticalTitleSubtitleViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import Foundation

enum VerticalTitleSubtitleViewType {
  case windSpeed
  case cloudness
}

struct VerticalTitleSubtitleViewModel {
  let iconName: String
  let value: String
  let description: String
  let state: WeatherDetailsCellViewModelState
}

extension VerticalTitleSubtitleViewModel {
  init(
    state: WeatherDetailsCellViewModelState = .loading,
    type: VerticalTitleSubtitleViewType,
    value: String = ""
  ) {
    self.state = state
    switch type {
    case .windSpeed:
      self.description = "Wind speed"
      self.iconName = "wind"
      self.value = value
    case .cloudness:
      self.description = "Cloudiness"
      self.iconName = "cloud"
      self.value = value
    }
  }
}
