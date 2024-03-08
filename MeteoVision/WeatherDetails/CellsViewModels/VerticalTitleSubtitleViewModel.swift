//
//  VerticalTitleSubtitleViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import Foundation

enum VerticalTitleSubtitleViewType {
  case windSpeed
  case windDegree
}

struct VerticalTitleSubtitleViewModel {
  let iconName: String
  let value: String
  let description: String
}

extension VerticalTitleSubtitleViewModel {
  init(type: VerticalTitleSubtitleViewType, value: String) {
    switch type {
    case .windSpeed:
      self.description = "Wind speed"
      self.iconName = "wind"
      self.value = value
    case .windDegree:
      self.description = "Wind temperature"
      self.iconName = "thermometer.sun"
      self.value = value
    }
  }
}
