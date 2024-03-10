//
//  WeatherUnitsProviderTests.swift
//  MeteoVisionTests
//
//  Created by YAUHENI LEVIN on 10.03.24.
//

import XCTest
@testable import MeteoVision


final class MockUserDefaults: UserDefaults {
  var storedValue: Int?
  
  override func setValue(_ value: Any?, forKey key: String) {
    storedValue = value as? Int
  }
  
  override func integer(forKey defaultName: String) -> Int {
    return storedValue ?? super.integer(forKey: defaultName)
  }
}

final class WeatherUnitsProviderTests: XCTestCase {
  func testGetWeatherUnits() {
    let provider = WeatherUnitsProvider()
    let units = provider.getWeatherUnits()
    
    XCTAssertEqual(units, WeatherUnits.allCases)
  }
  
  func testSelectWeatherUnit() {
    let userDefaults = MockUserDefaults()
    let provider = WeatherUnitsProvider(userDefaults: userDefaults)
    let selectedUnit = WeatherUnits.standard
    provider.select(weatherUnit: selectedUnit)
    XCTAssertEqual(provider.getSelectedWeatherUnit().rawValue, selectedUnit.rawValue)
  }
  
  func testNewUnitUpdateHandler() {
    let provider = WeatherUnitsProvider()
    let expectation = XCTestExpectation(description: "New unit update handler called")
    
    provider.newUnitUpdateHandler = { newUnit in
      expectation.fulfill()
    }
    // Trigger a unit selection to invoke the handler
    provider.select(
      weatherUnit: provider.getSelectedWeatherUnit() == .metric ? .standard : .metric
    )
    
    wait(for: [expectation], timeout: 1.0)
  }
}
