//
//  WeatherDetailsViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import MVAPIClient
import CoreLocation
import Combine
import Network

protocol NetworkMonitoring {
  func start(queue: DispatchQueue)
  var currentPath: NWPath { get }
  var pathUpdateHandler: (@Sendable(_ newPath: NWPath) -> Void)? { get set }
}

extension NWPathMonitor: NetworkMonitoring {}

final class WeatherDetailsViewModel {
  @Published private(set) var viewModels: [WeatherDetailViewModeling] = []
  @Published private(set) var networkStatus: NWPath.Status?

  // Providers and services
  private var locationCoordinates: CLLocationCoordinate2D?
  private var unitsProvider: WeatherUnitsProviding
  private var networkMonitor: NetworkMonitoring
  
  // Cells viewmodels with initial state .loading
  private var weatherDetailsCityViewModel = WeatherDetailsCityCellViewModel()
  private var weatherDetailsWindViewModel = WeatherDetailsWindViewModel(
    windDetailsViewModels: [.init(type: .cloudness), .init(type: .windSpeed)]
  )
  private var weatherDetailsAQIViewModel = WeatherDetailsAirQualityCellViewModel()
  
  private let weatherProvider: WeatherProviding
  private let refreshDataInterva: TimeInterval = 10.0
  private(set) var lastFetchTimestamp = Date()

  init(
    weatherSerivce: WeatherProviding = WeatherProvider(),
    unitsProvider: WeatherUnitsProviding,
    networkMonitor: NetworkMonitoring = NWPathMonitor()
  ) {
    self.weatherProvider = weatherSerivce
    self.unitsProvider = unitsProvider
    self.networkMonitor = networkMonitor

    self.unitsProvider.newUnitUpdateHandler = { [weak self] selectedUnit in
      guard let self else {
        return
      }
      Task {
        await self.fetchWeatherDetails()
      }
    }
    
    viewModels = []

    setupNetworkMonitoring()
  }
  
  // Setup and observe network connection
  func setupNetworkMonitoring() {
    self.networkMonitor.pathUpdateHandler = { [weak self] path in
      guard self?.networkStatus != path.status else {
        return
      }
      self?.networkStatus = path.status
    }
    networkMonitor.start(queue: DispatchQueue(label: "NetworkMonitor queue"))
  }

  /// Fetch data and update cell view models with it
  /// If there are no response, set error state in cell viewmodels
  func fetchWeatherDetails() async {
    guard let locationCoordinates else {
      return
    }
    let latitude = "\(locationCoordinates.latitude)"
    let longtitude = "\(locationCoordinates.longitude)"
    
    self.updateViewModelBeforeDataFetch()
   
    do {
      async let fetchCurrentWeather = weatherProvider.getCurrentWeather(
        latitude: latitude,
        longtitude: longtitude,
        units: WeatherUnitTitles.apiTitle(for: unitsProvider.getSelectedWeatherUnit()), apiKey: APIKeys.key
      )
      async let fetchCurrentAirPollution = weatherProvider.getCurrentAirPollution(
        latitude: latitude,
        longtitude: longtitude,
        apiKey: APIKeys.key
      )
      do {
        let (weather, airPollution) = await (try? fetchCurrentWeather, try? fetchCurrentAirPollution)
        updateWeatherViewModels(from: weather)
        updateAirQualityViewModel(from: airPollution)
        
        viewModels = [
          weatherDetailsCityViewModel,
          weatherDetailsWindViewModel,
          weatherDetailsAQIViewModel
        ]
      }
    }
  }
  
  // Fetch new data for pull to refresh action at least once in 10 seconds
  func fetchToRefresh() {
    guard Date().timeIntervalSince(lastFetchTimestamp) >= refreshDataInterva else {
      return
    }
    Task {
      await fetchWeatherDetails()
      lastFetchTimestamp = Date()
    }
  }
  
  private func updateViewModelBeforeDataFetch() {
    weatherDetailsCityViewModel = WeatherDetailsCityCellViewModel(state: .loading)
    weatherDetailsWindViewModel = WeatherDetailsWindViewModel(state: .loading)
    weatherDetailsAQIViewModel = WeatherDetailsAirQualityCellViewModel(state: .loading)
    viewModels = [
      weatherDetailsCityViewModel,
      weatherDetailsWindViewModel,
      weatherDetailsAQIViewModel
    ]
  }
  
  private func updateWeatherViewModels(from weather: CurrentWeather?) {
    if let weather {
      weatherDetailsCityViewModel = WeatherDetailsCityCellViewModel(
        state: .success,
        location: weather.city,
        weatherConditions: weather.conditions.first,
        temperature: weather.details.temperature,
        maxTemperature: weather.details.temperatureMax,
        minimalTemperature: weather.details.temperatureMin
      )
      weatherDetailsWindViewModel = WeatherDetailsWindViewModel(windDetailsViewModels: [
        .init(state: .success, type: .cloudness, value: "\(Int(weather.clouds.all.rounded()))%"),
        .init(state: .success, type: .windSpeed, value: "\(Int(weather.wind.speed.rounded()))m/s")
      ])
    } else {
      weatherDetailsCityViewModel = WeatherDetailsCityCellViewModel(state: .failure)
      weatherDetailsWindViewModel = WeatherDetailsWindViewModel(windDetailsViewModels: [
        .init(state: .failure, type: .cloudness),
        .init(state: .failure, type: .windSpeed),
      ])
    }
  }
  
  private func updateAirQualityViewModel(from airPollution: AirPolution?) {
    if let airPollution{
      weatherDetailsAQIViewModel = WeatherDetailsAirQualityCellViewModel(state: .success, index: airPollution.airQualityIndex)
    } else {
      weatherDetailsAQIViewModel = WeatherDetailsAirQualityCellViewModel(state: .failure)
    }
  }
  
  func update(locationCoordinates: CLLocationCoordinate2D) async {
    self.locationCoordinates = locationCoordinates
    await fetchWeatherDetails()
  }
}
