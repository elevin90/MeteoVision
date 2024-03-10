import XCTest
@testable import MVLocalCountriesProvider

final class MVLocalCountriesProviderTests: XCTestCase {
  func testFetchCities() {
    let countriesProvider = MVLocalCountriesProvider()
    let cities = countriesProvider.fetchCities(with: "New York")
  
    XCTAssertTrue(cities.contains("New York, United States"), "Expected city 'New York, United States'")
  }
  
  func testFetchCitiesCaseInsensitive() {
    let countriesProvider = MVLocalCountriesProvider()
    let cities = countriesProvider.fetchCities(with: "loS anGeLeS")
    // Assert
    XCTAssertTrue(cities.contains("Los Angeles, United States"))
  }
}
