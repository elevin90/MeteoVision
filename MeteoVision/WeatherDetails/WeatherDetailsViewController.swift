//
//  WeatherDetailsViewController.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 6.03.24.
//

import UIKit
import Combine

final class WeatherDetailsViewController: UIViewController {
  private let viewModel: WeatherDetailsViewModel
  private let router: Routing
  private var cancellables: Set<AnyCancellable> = []
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.showsVerticalScrollIndicator = false
    tableView.register(WeatherDetailsCityCell.self)
    tableView.register(WeatherDetailsWindCell.self)
    tableView.register(WeatherDetailsAirQualityCell.self)
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshData), for: .primaryActionTriggered)
    tableView.refreshControl = refreshControl
    return tableView
  }()
  
  init(viewModel: WeatherDetailsViewModel, router: Routing) {
    self.viewModel = viewModel
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .secondarySystemBackground
    setupNavigationController()
    setupTableView()
    setNeedsUpdateContentUnavailableConfiguration()
    
    viewModel.$networkStatus
      .receive(on: DispatchQueue.main)
      .sink { [weak self] status in
        guard let status else {
          return
        }
        switch status {
        case .satisfied:
          break
        case .unsatisfied, .requiresConnection:
          self?.router.showAlert(title: "Lost connection", message: "Please check the internet connection", buttonTitle: "OK", on: self, completion: nil)
        @unknown default:
          assertionFailure()
          break
        }
      }.store(in: &cancellables)
    
    viewModel.$viewModels
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.setNeedsUpdateContentUnavailableConfiguration()
        self?.tableView.reloadData()
        self?.tableView.refreshControl?.endRefreshing()
      }.store(in: &cancellables)
    Task {
      await viewModel.fetchWeatherDetails()
    }
  }
  
  private func setupNavigationController() {
    self.navigationItem.title = "Weather details"
    navigationController?.navigationBar.prefersLargeTitles = true
    let searchItem = UIBarButtonItem(
      barButtonSystemItem: .search,
      target: self,
      action: #selector(showCitySearchViewController)
    )
    navigationItem.rightBarButtonItems = [searchItem]
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    tableView.reloadData()
  }
  
  override func updateContentUnavailableConfiguration(
    using state: UIContentUnavailableConfigurationState
  ) {
    var config: UIContentUnavailableConfiguration?
    if viewModel.viewModels.isEmpty {
      var empty = UIContentUnavailableConfiguration.empty()
      empty.background.backgroundColor = .systemBackground
      empty.image = UIImage(systemName: "map.circle.fill")
      empty.text = "No city selected"
      empty.secondaryText = "Search for a city or use your current location to see the weather here"
      config = empty
    }
    contentUnavailableConfiguration = config
  }
  
  @objc private func showCitySearchViewController() {
    let viewModel = CitiesListViewModel()
    viewModel.$locationCoordinates
      .receive(on: DispatchQueue.main)
      .sink { [weak self] coordinates in
        guard let coordinates else {
          return
        }
        Task {
          await self?.viewModel.update(locationCoordinates: coordinates)
        }
      }
      .store(in: &cancellables)

    let viewController = CitiesSearchViewController(viewModel: viewModel)
    navigationController?.present(viewController, animated: true)
  }
  
  @objc private func refreshData() {
    viewModel.fetchToRefresh()
    tableView.refreshControl?.endRefreshing()
  }
}

extension WeatherDetailsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.viewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellViewModel = viewModel.viewModels[indexPath.row]
    let cell = tableView.dequeueReusableCell(
      withIdentifier: cellViewModel.cellId,
      for: indexPath
    )
    (cell as? WeatherDetailCellUpdating)?.update(with: cellViewModel)
    return cell
  }
}
