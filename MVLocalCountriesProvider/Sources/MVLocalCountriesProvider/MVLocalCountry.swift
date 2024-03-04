//
//  MVLocalCountry.swift
//  Created by YAUHENI LEVIN on 4.03.24.
//

import Foundation

public struct MVLocalCountry: Codable {
  let title: String
  let cities: [String]
  
  enum CodingKeys: String, CodingKey {
    case title = "country"
    case cities
  }
}
