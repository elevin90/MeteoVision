//
//  File.swift
//  
//
//  Created by YAUHENI LEVIN on 10.03.24.
//

import Foundation

public struct AirPolution: Codable {
  public let airQualityIndex: Int
  
  enum CodingKeys: String, CodingKey {
    case airQualityIndex = "aqi"
  }
}

struct AirQualityList: Codable {
  let airPolution: AirPolution
  
  enum CodingKeys: String, CodingKey {
    case airPolution = "main"
  }
}

struct AirQualityResponse: Codable {
  let airQualityList: [AirQualityList]
  
  enum CodingKeys: String, CodingKey {
    case airQualityList = "list"
  }
}
