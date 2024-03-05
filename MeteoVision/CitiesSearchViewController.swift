//
//  ViewController.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import UIKit
import SwiftUI
import TipKit
import Combine

final class CitiesSearchViewController: UIViewController {
  let citiesListViewModel = CitiesListViewModel()
  private var cancellables: Set<AnyCancellable> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    citiesListViewModel.$locationCoordinates
      .sink { [weak self] coordinates in
        // Handle the updated coordinates here
        print("Updated coordinates: \(coordinates?.latitude), \(coordinates?.longitude)")
        
        // Update your UI or perform any other actions
      }
      .store(in: &cancellables)
    setupCountriesList()
  }

  private func setupCountriesList() {
    let rootView = CitiesListView(viewModel: citiesListViewModel).task {
      try? Tips.configure([
        .displayFrequency(.immediate),
        .datastoreLocation(.applicationDefault)
      ])
    }
    let countriesListViewController = UIHostingController(rootView: rootView)
    let countriesListView = countriesListViewController.view
    guard let countriesListView else {
      return
    }
    countriesListView.translatesAutoresizingMaskIntoConstraints = false

    addChild(countriesListViewController)
    view.addSubview(countriesListView)

    NSLayoutConstraint.activate([
      countriesListView.topAnchor.constraint(equalTo: view.topAnchor),
      countriesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      countriesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      countriesListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    countriesListViewController.didMove(toParent: self)
  }
}
