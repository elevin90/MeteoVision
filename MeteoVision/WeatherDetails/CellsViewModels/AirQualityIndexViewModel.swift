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
    let alpha = 0.3
    color = switch index {
    case 1: UIColor.green.withAlphaComponent(alpha)
    case 2, 3: UIColor.yellow.withAlphaComponent(alpha)
    case 4: UIColor.orange.withAlphaComponent(alpha)
    case 5: UIColor.red.withAlphaComponent(alpha)
    default: UIColor.clear
    }
  }
}
