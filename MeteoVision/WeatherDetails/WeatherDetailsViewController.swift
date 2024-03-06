//
//  WeatherDetailsViewController.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 6.03.24.
//

import UIKit
import CoreLocation
import SwiftUI

final class WeatherDetailsViewController: UIViewController {
  private let locationCoordinates: CLLocationCoordinate2D
  
  init(locationCoordinates: CLLocationCoordinate2D) {
    self.locationCoordinates = locationCoordinates
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCountriesList()
  }
  
  private func setupCountriesList() {
    let rootView = WeatherForecastListView(viewModel: WeatherForecastListViewModel(locationCoordinates: locationCoordinates))
    
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
