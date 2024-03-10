//
//  AirQualityIndexViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 9.03.24.
//

import UIKit

struct AirQualityIndexViewModel {
  let index: String
  let color: UIColor
  
  init?(index: Int) {
    self.index = "\(index)"
    color = switch index {
    case 1: UIColor.green
    case 2, 3: UIColor.yellow
    case 4: UIColor.orange
    case 5: UIColor.red
    default: UIColor.clear
    }
  }
}
