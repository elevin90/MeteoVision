//
//  MVLocalCountriesProvider.swift
//  Created by YAUHENI LEVIN on 4.03.24.
//

import Foundation

public protocol MVLocalCountriesProviding {
  func fetchCities(with query: String) -> [String]
}

public final class MVLocalCountriesProvider: MVLocalCountriesProviding {
  private var countries: [MVLocalCountry] = []
  
  public init() {
    loadCountriesFromJSON()
  }
  
  private func loadCountriesFromJSON() {
    guard let path = Bundle.module.path(forResource: "Cities", ofType: "json"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
      return
    }
    do {
      let decodedCountries = try JSONDecoder().decode([MVLocalCountry].self, from: data)
      self.countries = decodedCountries
    } catch {
      print(String(describing: error))
    }
  }
  
  public func fetchCities(with query: String) -> [String] {
    return Array(
      countries
        .flatMap { country in
          country.cities
            .filter { $0.lowercased().contains(query.lowercased()) }
            .map { "\($0), \(country.title)" }
        }
        .prefix(20)
    )
  }
}


