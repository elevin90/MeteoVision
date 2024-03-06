//
//  WeatherDetailsListViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 6.03.24.
//

import SwiftUI
import MVAPIClient
import CoreLocation

@Observable
final class WeatherForecastListViewModel {
  private let locationCoordinates: CLLocationCoordinate2D
  private let weatherProvider: WeatherProviding
  private(set) var currentWeatcher: CurrentWeather?
  
  init(
    locationCoordinates: CLLocationCoordinate2D,
    weatherSerivce: WeatherProviding = WeatherProvider()
  ) {
    self.locationCoordinates = locationCoordinates
    self.weatherProvider = weatherSerivce
  }
  
  func fetchWeatherDetails() async {
    do {
      currentWeatcher = try await weatherProvider.getCurrentWeather(
        latitude: "\(locationCoordinates.latitude)",
        longtitude: "\(locationCoordinates.longitude)"
      )
    } catch {
      
    }
  }
}
