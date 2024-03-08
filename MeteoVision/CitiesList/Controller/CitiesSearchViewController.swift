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
import CoreLocation

enum CitiesSearchShowType {
  case firstLaunch
  case citySearch
}

final class CitiesSearchViewController: UIViewController {
  private let citiesListViewModel: CitiesListViewModel
  private var cancellables: Set<AnyCancellable> = []
  private let showType: CitiesSearchShowType
  var coordinatesUpdateHandler: ((CLLocationCoordinate2D) -> Void)?
  
  init(showType: CitiesSearchShowType) {
    self.showType = showType
    self.citiesListViewModel = CitiesListViewModel(showType: showType)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    citiesListViewModel.$locationCoordinates
      .receive(on: DispatchQueue.main)
      .sink { [weak self] coordinates in
        guard let self, let coordinates else {
          return
        }
        switch self.showType {
        case .firstLaunch:
          Task {
            await UIApplication.shared.windows.first?
              .setRootViewController(TabBarController(locationCoordinates: coordinates),
                                     animated: true
              )
          }
        case .citySearch:
          self.coordinatesUpdateHandler?(coordinates)
          self.dismiss(animated: true)
        }
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

extension UIWindow {
    @MainActor
    func setRootViewController(_ newRootViewController: UIViewController, animated: Bool = true) async {
        guard animated else {
            rootViewController = newRootViewController
            return
        }

        await withCheckedContinuation({ (continuation: CheckedContinuation<Void, Never>) in
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.rootViewController = newRootViewController
                UIView.setAnimationsEnabled(oldState)
            } completion: { _ in
                continuation.resume()
            }
        })
    }

}
