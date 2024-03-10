//
//  CitiesListViewModelTests.swift
//  MeteoVisionTests
//
//  Created by YAUHENI LEVIN on 10.03.24.
//

import XCTest
import CoreLocation
import Combine
import MVLocalCountriesProvider
import MVLocationProvider
@testable import MeteoVision

final class CitiesListViewModelTests: XCTestCase {
  
  var cancellables: Set<AnyCancellable> = []
  
  // Mock implementation for MVLocalCountriesProviding
  private final class MockCountriesProvider: MVLocalCountriesProviding {
    func fetchCities(with query: String) -> [String] {
      // Implement mock behavior for fetching cities
      return ["City1", "City2", "City3"]
    }
  }
  
  // Mock implementation for MVLocationProviding
  class MockLocationProvider: MVLocationProviding {
    var didUpdateLocationCoordinatesHandler: ((CLLocationCoordinate2D) -> Void)?
    
    func geocode(adress: String) async throws -> CLLocationCoordinate2D {
      .init(latitude: 11.0, longitude: 12.0)
    }
    
    var didChangeAuthorisationStatusHandler: ((CLAuthorizationStatus) -> Void)?
    
    func requestLocation() {
      didUpdateLocationCoordinatesHandler?(.init(latitude: 11.0, longitude: 12.0))
    }
    
    func geocode(adress: String) async throws -> CLLocationCoordinate2D? {
      // Simulate geocoding coordinates
      return CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    }
  }
  
  func testSearchQueryUpdate() {
    let viewModel = CitiesListViewModel(
      countriesProvider: MockCountriesProvider(),
      locationProvider: MockLocationProvider()
    )
    
    let expectation = expectation(description: "Search results updated")
    
    viewModel.$searchResults
      .dropFirst()
      .sink { searchResults in
        // Check if search results are updated after changing the search query
        XCTAssertEqual(searchResults, ["City1", "City2", "City3"])
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    viewModel.searchQuery = "City"
    
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testLocationUpdate() {
    let viewModel = CitiesListViewModel(
      countriesProvider: MockCountriesProvider(),
      locationProvider: MockLocationProvider()
    )
    
    let expectation = expectation(description: "Location coordinates updated")
    
    viewModel.$locationCoordinates
      .dropFirst()
      .sink { locationCoordinates in
        // Check if location coordinates are updated after requesting location
        XCTAssertNotNil(locationCoordinates)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    viewModel.requestLocation()
    
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testGeocodeCoordinatesForCity() {
    let viewModel = CitiesListViewModel(
      countriesProvider: MockCountriesProvider(),
      locationProvider: MockLocationProvider()
    )
    
    let expectation = XCTestExpectation(description: "Location coordinates updated")
    
    viewModel.$locationCoordinates
      .dropFirst()
      .sink { locationCoordinates in
        // Check if location coordinates are updated after geocoding
        XCTAssertNotNil(locationCoordinates)
        XCTAssertEqual(locationCoordinates?.latitude, 11.0)
        XCTAssertEqual(locationCoordinates?.longitude, 12)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    Task {
      await viewModel.geocodeCoordinatesFor("Warsaw, Poland")
    }
    
    wait(for: [expectation], timeout: 1.0)
  }
}
