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
  private var cancellables: Set<AnyCancellable> = []
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.showsVerticalScrollIndicator = false
    tableView.register(WeatherDetailsCityCell.self)
    tableView.register(WeatherDetailsWindCell.self)
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    return tableView
  }()
  
  init(viewModel: WeatherDetailsViewModel) {
    self.viewModel = viewModel
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
    
    viewModel.$viewModels
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.tableView.reloadData()
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
  
  @objc private func showCitySearchViewController() {
    let viewController = CitiesSearchViewController(showType: .citySearch)
    viewController.coordinatesUpdateHandler = { [weak self] coordinates in
      Task {
        await self?.viewModel.update(locationCoordinates: coordinates)
      }
    }
    navigationController?.present(viewController, animated: true)
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
