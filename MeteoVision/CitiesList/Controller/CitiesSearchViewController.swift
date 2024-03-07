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
  private let citiesListViewModel = CitiesListViewModel()
  private var cancellables: Set<AnyCancellable> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    citiesListViewModel.$locationCoordinates
      .receive(on: DispatchQueue.main)
      .sink { [weak self] coordinates in
        guard let self, let coordinates else {
          return
        }
        let viewModel = WeatherDetailsViewModel(locationCoordinates: coordinates)
        let destinationViewController = WeatherDetailsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        Task {
          await UIApplication.shared.windows.first?.setRootViewController(navigationController, animated: true)
        }
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true)
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
