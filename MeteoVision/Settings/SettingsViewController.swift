//
//  SettingsViewController.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 8.03.24.
//

import UIKit

final class SettingsViewController: UIViewController {
  private let viewModel: SettingsViewModel
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.showsVerticalScrollIndicator = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    return tableView
  }()
  
  init(viewModel: SettingsViewModel) {
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
    self.title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    setupTableView()
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
}

extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.viewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellViewModel = viewModel.viewModels[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
    cell?.textLabel?.text = cellViewModel.title
    cell?.imageView?.image = cellViewModel.isSelected ? UIImage(systemName: "checkmark") : nil
    return cell ?? UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    "TEMPERATURE UNITS"
  }
}

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.selectUnit(at: indexPath.row)
    tableView.reloadData()
  }
}
