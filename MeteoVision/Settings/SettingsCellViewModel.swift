//
//  SettingsCellViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import Foundation

final class SettingsCellViewModel: WeatherDetailViewModeling {
  let title: String
  var isSelected: Bool
  let cellId = ""
  
  init(title: String, isSelected: Bool) {
    self.title = title
    self.isSelected = isSelected
  }
}
