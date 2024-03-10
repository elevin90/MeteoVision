//
//  WeatherDetailsViewModel.swift
//  MeteoVisionTests
//
//  Created by YAUHENI LEVIN on 10.03.24.
//

import XCTest
import MVAPIClient
import Combine
import CoreLocation
@testable import MeteoVision

final class WeatherDetailsViewModelTests: XCTestCase {
  final class WeatherProviderMock: WeatherProviding {
    private let isSuccess: Bool
    
    init(isSuccess: Bool) {
      self.isSuccess = isSuccess
    }
    
    func getCurrentAirPollution(latitude: String, longtitude: String) async throws -> AirPolution {
      if isSuccess {
        return AirPolution.preview
      } else {
        throw WeatherProviderError.airQuality
      }
    }
    
    func getCurrentWeather(latitude: String, longtitude: String, units: String) async throws -> CurrentWeather {
      if isSuccess {
        return CurrentWeather.preview
      } else {
        throw WeatherProviderError.weather
      }
    }
  }
  
  var cancellables: Set<AnyCancellable> = []
  let locationCoordinates = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
  
  func testInitialState() {
    let viewModel = WeatherDetailsViewModel(
      weatherSerivce: WeatherProviderMock(isSuccess: true),
      unitsProvider: WeatherUnitsProvider(userDefaults: MockUserDefaults())
    )
    XCTAssertEqual(viewModel.viewModels.count, 0)
  }
  
  func testSuccesfulResponse() {
    let viewModel = WeatherDetailsViewModel(
      weatherSerivce: WeatherProviderMock(isSuccess: true),
      unitsProvider: WeatherUnitsProvider(userDefaults: MockUserDefaults())
    )
    viewModel.$viewModels
      .receive(on: DispatchQueue.main)
      .sink { _ in
        XCTAssertNil(viewModel.viewModels.first(where: { $0.state == .loading }))
        XCTAssertEqual(viewModel.viewModels.filter {$0.state == .success}.count, 3)
      }.store(in: &cancellables)
    Task {
      await viewModel.fetchWeatherDetails()
    }
  }
  
  func testFailureResponse() {
    let viewModel = WeatherDetailsViewModel(
      weatherSerivce: WeatherProviderMock(isSuccess: false),
      unitsProvider: WeatherUnitsProvider(userDefaults: MockUserDefaults())
    )
    viewModel.$viewModels
      .receive(on: DispatchQueue.main)
      .sink { _ in
        XCTAssertNil(viewModel.viewModels.first(where: { $0.state == .loading }))
        XCTAssertEqual(viewModel.viewModels.filter {$0.state == .failure}.count, 3)
      }.store(in: &cancellables)
    Task {
      await viewModel.fetchWeatherDetails()
    }
  }
}
