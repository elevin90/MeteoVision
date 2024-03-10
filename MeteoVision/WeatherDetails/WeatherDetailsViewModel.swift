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
  private var weatherDetailsAQIViewModel = WeatherDetailsAirQualityCellViewModel()
  
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
      weatherDetailsCityViewModel =
          WeatherDetailsCityCellViewModel(
            state: .success,
            location: currentWeatcher.city,
            weatherConditions: currentWeatcher.conditions.first,
            temperature: currentWeatcher.details.temperature,
            maxTemperature: currentWeatcher.details.temperatureMax,
            minimalTemperature: currentWeatcher.details.temperatureMin
          )
      weatherDetailsWindViewModel = WeatherDetailsWindViewModel(windDetailsViewModels: [
            .init(state: .success, type: .windDegree, value: "\(Int(currentWeatcher.wind.degree.rounded()))°"),
            .init(state: .success, type: .windSpeed, value: "\(Int( currentWeatcher.wind.speed.rounded()))°")
          ])
      viewModels = [weatherDetailsCityViewModel, weatherDetailsWindViewModel, weatherDetailsAQIViewModel]
    } catch {
      viewModels = [
        WeatherDetailsCityCellViewModel(state: .failure),
        WeatherDetailsWindViewModel(windDetailsViewModels: [
          .init(state: .failure, type: .windDegree),
          .init(state: .failure, type: .windSpeed),
        ]),
        WeatherDetailsAirQualityCellViewModel(state: .failure)
      ]
    }
    do {
      let currentAirPollution = try await weatherProvider.getCurrentAirPollution(latitude: "\(locationCoordinates.latitude)", longtitude: "\(locationCoordinates.longitude)")
      weatherDetailsAQIViewModel = WeatherDetailsAirQualityCellViewModel(index: currentAirPollution.airQualityIndex)
      viewModels = [weatherDetailsCityViewModel, weatherDetailsWindViewModel, weatherDetailsAQIViewModel]
    } catch {
      print(String(describing: error))
    }
  }
  
  func update(locationCoordinates: CLLocationCoordinate2D) async {
    self.locationCoordinates = locationCoordinates
    await fetchWeatherDetails()
  }
}
