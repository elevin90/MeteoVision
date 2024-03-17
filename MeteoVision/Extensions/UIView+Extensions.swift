//
//  UIView+Extensions.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import UIKit

extension UIView {
  func addShadow(
    with opacity: Float = 0.15,
    radius: CGFloat = 2
  ) {
    layer.cornerRadius = 8
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = radius
  }
}
