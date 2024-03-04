//
//  ViewController.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import UIKit
import SwiftUI
import TipKit

final class CountriesSearchViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCountriesList()
  }

  private func setupCountriesList() {
    let countriesListViewController = UIHostingController(rootView: CitiesListView().task {
      try? Tips.configure([
        .displayFrequency(.immediate),
        .datastoreLocation(.applicationDefault)
      ])
    })
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
