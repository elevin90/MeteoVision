//
//  MeteoVisionTests.swift
//  MeteoVisionTests
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import XCTest
@testable import MeteoVision

final class WeatherUnitsTests: XCTestCase {
  final private class MockLocale: NSLocale {
      var temperatureUnitValue: String?

      override func object(forKey key: NSLocale.Key) -> Any? {
          if key.rawValue == "kCFLocaleTemperatureUnitKey" {
              return temperatureUnitValue
          }
          return super.object(forKey: key)
      }
  }
    func testAppTitle() {
        XCTAssertEqual(WeatherUnitTitles.appTitle(for: .system), "Default sustem units")
        XCTAssertEqual(WeatherUnitTitles.appTitle(for: .standard), "Fahrenheit")
        XCTAssertEqual(WeatherUnitTitles.appTitle(for: .metric), "Celsisus")
    }

    func testAPITitleSystem() {
        let mockLocale = MockLocale()
        mockLocale.temperatureUnitValue = "Fahrenheit"
        XCTAssertEqual(WeatherUnitTitles.apiTitle(for: .system, locale: mockLocale), "Fahrenheit")
    }

    func testAPITitleStandard() {
        XCTAssertEqual(WeatherUnitTitles.apiTitle(for: .standard), "standard")
    }

    func testAPITitleMetric() {
        XCTAssertEqual(WeatherUnitTitles.apiTitle(for: .metric), "metric")
    }
}
