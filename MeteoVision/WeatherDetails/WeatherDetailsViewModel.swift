//
//  WeatherDetailsViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import Foundation
import MVAPIClient
import CoreLocation
import Combine

final class WeatherDetailsViewModel {
  private let locationCoordinates: CLLocationCoordinate2D
  private let weatherProvider: WeatherProviding
//  private(set) var currentWeatcher: CurrentWeather?
  
  @Published var viewModels: [WeatherDetailViewModeling] = []
  private var weatherDetailsCityViewModel = WeatherDetailsCityCellViewModel()
  private var weatherDetailsWindViewModel = WeatherDetailsWindViewModel()
  
  init(
    locationCoordinates: CLLocationCoordinate2D,
    weatherSerivce: WeatherProviding = WeatherProvider()
  ) {
    self.locationCoordinates = locationCoordinates
    self.weatherProvider = weatherSerivce
    self.viewModels = [
      weatherDetailsCityViewModel,
      weatherDetailsWindViewModel
    ]
  }
  
  func fetchWeatherDetails() async {
    do {
      let currentWeatcher = try await weatherProvider.getCurrentWeather(
        latitude: "\(locationCoordinates.latitude)",
        longtitude: "\(locationCoordinates.longitude)"
      )
        viewModels = [
          WeatherDetailsCityCellViewModel(
            location: currentWeatcher.city,
            weatherConditions: currentWeatcher.conditions.first,
            temperature: currentWeatcher.details.temperature,
            maxTemperature: currentWeatcher.details.temperatureMax,
            minimalTemperature: currentWeatcher.details.temperatureMin
          ),
          WeatherDetailsWindViewModel(windDetailsViewModels: [
            .init(type: .windDegree, value: "\(Int(currentWeatcher.wind.degree.rounded()))"),
            .init(type: .windSpeed, value: "\(Int( currentWeatcher.wind.speed.rounded()))")
          ])
        ]
    } catch {
      
    }
  }
}
