//
//  WeatherDetailsWindCell.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import UIKit

final class WeatherDetailsWindViewModel: WeatherDetailViewModeling {
  let cellId = WeatherDetailsWindCell.defaultReuseIdentifier
  let windDetailsViewModels:  [VerticalTitleSubtitleViewModel]
  let state: WeatherDetailsCellViewModelState
  
  init(
    state: WeatherDetailsCellViewModelState = .loading,
    windDetailsViewModels: [VerticalTitleSubtitleViewModel] = []
  ) {
    self.state = state
    self.windDetailsViewModels = windDetailsViewModels
  }
}

final class WeatherDetailsWindCell: BaseTableViewCell, WeatherDetailCellUpdating {
  enum Constants {
    static let sideOffset: CGFloat = 12.0
    static let innerOffset: CGFloat = 8.0
  }
  
  private lazy var windDetailsViews: [VerticalTitleSubtitleView] = {
    [VerticalTitleSubtitleView(type: .windDegree), VerticalTitleSubtitleView(type: .windSpeed)]
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: windDetailsViews)
    stackView.spacing = 14
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.axis = .horizontal
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupView() {
    super.setupView()
    makeClearBackground()
    addSubview(stackView)
    let offset = Constants.sideOffset
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: offset),
      stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
      stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -offset)
    ])
  }
  
  func update(with viewModel: WeatherDetailViewModeling) {
    guard let detailsViewModel = viewModel as? WeatherDetailsWindViewModel else {
      return
    }
    for (view, viewModel) in zip(windDetailsViews, detailsViewModel.windDetailsViewModels) {
      view.update(with: viewModel)
    }
  }
}
