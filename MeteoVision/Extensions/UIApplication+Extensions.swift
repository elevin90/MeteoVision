//
//  UIApplication+Extensions.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import UIKit

extension UIApplication {
  func endEditing(_ force: Bool) {
    self.windows
      .filter{$0.isKeyWindow}
      .first?
      .endEditing(force)
  }
}
