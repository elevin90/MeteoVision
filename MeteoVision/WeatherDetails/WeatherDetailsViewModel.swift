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
  private var locationCoordinates: CLLocationCoordinate2D
  private let weatherProvider: WeatherProviding
  private var unitsProvider: WeatherUnitsProviding
  
  @Published var viewModels: [WeatherDetailViewModeling] = []
  private var weatherDetailsCityViewModel = WeatherDetailsCityCellViewModel()
  private var weatherDetailsWindViewModel = WeatherDetailsWindViewModel()
  
  init(
    locationCoordinates: CLLocationCoordinate2D,
    weatherSerivce: WeatherProviding = WeatherProvider(),
    unitsProvider: WeatherUnitsProviding
  ) {
    self.locationCoordinates = locationCoordinates
    self.weatherProvider = weatherSerivce
    self.unitsProvider = unitsProvider

    self.viewModels = [
      weatherDetailsCityViewModel,
      weatherDetailsWindViewModel
    ]
    
    self.unitsProvider.newUnitUpdateHandler = { [weak self] selectedUnit in
      guard let self else {
        return
      }
      Task {
        await self.fetchWeatherDetails()
      }
    }
  }
  
  func fetchWeatherDetails() async {
    do {
      let currentWeatcher = try await weatherProvider.getCurrentWeather(
        latitude: "\(locationCoordinates.latitude)",
        longtitude: "\(locationCoordinates.longitude)", 
        units: unitsProvider.getSelectedWeatherUnit().apiValue
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
            .init(type: .windDegree, value: "\(Int(currentWeatcher.wind.degree.rounded()))°"),
            .init(type: .windSpeed, value: "\(Int( currentWeatcher.wind.speed.rounded()))°")
          ])
        ]
    } catch {
      //TODO: Add erro handling here
    }
  }
  
  func update(locationCoordinates: CLLocationCoordinate2D) async {
    self.locationCoordinates = locationCoordinates
    await fetchWeatherDetails()
  }
}
