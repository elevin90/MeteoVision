//
//  CitiesListViewModel.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import Foundation
import Combine
import MVLocalCountriesProvider

final class CitiesListViewModel: ObservableObject {
  @Published private(set) var searchResults: [String] = []
  @Published var searchQuery = ""
  private let countriesProvider: MVLocalCountriesProviding
  private var cancellables: Set<AnyCancellable> = []
  
  init(countriesProvider: MVLocalCountriesProviding = MVLocalCountriesProvider.shared) {
    self.countriesProvider = countriesProvider

    $searchQuery
      .debounce(for: .seconds(0.2), scheduler: RunLoop.current)
      .sink {[weak self] username in
        guard let self = self else {
          return
        }
        self.searchResults = self.countriesProvider.fetchCities(with: self.searchQuery)
      }
      .store(in: &cancellables)
  }
}
