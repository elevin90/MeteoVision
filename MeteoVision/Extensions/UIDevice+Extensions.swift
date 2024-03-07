//
//  UIDevice+Extensions.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import UIKit

extension UIDevice {
  static var isIPad: Bool { 
    UIDevice.current.userInterfaceIdiom == .pad
  }
}
