//
//  CitiesListViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import Foundation
import Combine
import MVLocalCountriesProvider
import MVLocationProvider
import CoreLocation

final class CitiesListViewModel: ObservableObject {
  @Published private(set) var searchResults: [String] = []
  @MainActor @Published private(set) var locationCoordinates: CLLocationCoordinate2D?
  @Published var searchQuery = ""
  
  private let countriesProvider: MVLocalCountriesProviding
  private var locationProvider: MVLocationProviding
  private var cancellables: Set<AnyCancellable> = []
  
  init(
    countriesProvider: MVLocalCountriesProviding = MVLocalCountriesProvider(),
    locationProvider: MVLocationProviding = MVLocationProvider()
  ) {
    self.countriesProvider = countriesProvider
    self.locationProvider = locationProvider
    
    $searchQuery
      .dropFirst()
      .debounce(for: .seconds(0.2), scheduler: RunLoop.current)
      .sink {[weak self] username in
        guard let self = self else {
          return
        }
        self.searchResults = self.countriesProvider.fetchCities(with: self.searchQuery)
      }
      .store(in: &cancellables)
    
    self.locationProvider.didUpdateLocationCoordinatesHandler = { [weak self] coordinates in
      guard let self else {
        return
      }
      Task {
        await self.updateLocationCoordinates(from: coordinates)
      }
    }
  }
  
  func requestLocation() {
    locationProvider.requestLocation()
  }
  
  func geocodeCoordinatesFor(_ cityString: String) async {
    let coordinates = try? await locationProvider.geocode(adress: cityString)
    await updateLocationCoordinates(from: coordinates)
  }
  
  @MainActor
  private func updateLocationCoordinates(from coordinates: CLLocationCoordinate2D?) {
    locationCoordinates = coordinates
  }
}
