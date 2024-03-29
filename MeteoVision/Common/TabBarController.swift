//
//  TabBarController.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import UIKit
import CoreLocation

final class TabBarController: UITabBarController {
  private struct ScreenInfo {
    let title: String
    let image: UIImage?
  }
  
  private let router: Routing
  private var unitsProvider: WeatherUnitsProviding
  
  private lazy var weatherScreen: UINavigationController = {
    let screenInfo = ScreenInfo(
      title: "Weather",
      image: UIImage(systemName: "cloud.sun")
    )
    let viewModel = WeatherDetailsViewModel(unitsProvider: unitsProvider)
    return customise(
      viewController: WeatherDetailsViewController(viewModel: viewModel, router: router),
      screenInfo: screenInfo
    )
  }()
  
  private lazy var settingsScreen: UINavigationController = {
    let screenInfo = ScreenInfo(
      title: "Settings",
      image: UIImage(systemName: "gear")
    )
    let viewModel = SettingsViewModel(weatherUnitsProvider: unitsProvider)
    return customise(
      viewController: SettingsViewController(viewModel: viewModel),
      screenInfo: screenInfo
    )
  }()
  
  init(
    router: Routing = Router(),
    unitsProvider: WeatherUnitsProviding = WeatherUnitsProvider()
  ) {
    self.router = router
    self.unitsProvider = unitsProvider
    super.init(nibName: nil, bundle: nil)
    configure()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    viewControllers = [weatherScreen, settingsScreen] as [UIViewController]
    tabBar.scrollEdgeAppearance = tabBar.standardAppearance
  }
  
  private func customise(viewController: UIViewController, screenInfo: ScreenInfo) -> UINavigationController {
    viewController.tabBarItem.image = screenInfo.image
    viewController.title = screenInfo.title
    let selectedImage = screenInfo.image?.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)
    viewController.tabBarItem.selectedImage = selectedImage
    return UINavigationController(rootViewController: viewController)
  }
}
