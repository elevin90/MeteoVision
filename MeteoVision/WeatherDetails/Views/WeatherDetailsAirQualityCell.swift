//
//  WeatherDetailsAirQualityCell.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 9.03.24.
//

import UIKit

final class WeatherDetailsAirQualityCell: BaseTableViewCell, WeatherDetailCellUpdating {
  enum Constants {
    static let sideOffset: CGFloat = 12.0
  }
  
  private lazy var airQuialityIndexView = AirQualityIndexView()
  
  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 20 : 16, weight: .regular)
    label.textColor = .defaultText
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [airQuialityIndexView, label])
    stackView.spacing = Constants.sideOffset
    stackView.alignment = .fill
    stackView.axis = .horizontal
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var roundedContentView: UIView = {
    let contentVew = UIView()
    contentVew.translatesAutoresizingMaskIntoConstraints = false
    contentVew.backgroundColor = .systemBackground
    contentVew.addShadow()
    return contentVew
  }()
  
  private lazy var loadingDataView = LoadingDataView()
  
  private let offset = Constants.sideOffset
  
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
    setupRoundedContentView()
    setupStackView()
    setupLoadingDataView()
    airQuialityIndexView.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }
  
  func update(with viewModel: WeatherDetailViewModeling) {
    guard let detailsViewModel = viewModel as? WeatherDetailsAirQualityCellViewModel else {
      return
    }

    airQuialityIndexView.isHidden = viewModel.state != .success
    label.isHidden = viewModel.state != .success
    loadingDataView.isHidden = viewModel.state == .success
    loadingDataView.update(with: viewModel.state)
    
    if let aqiViewModel = detailsViewModel.aqiViewModel {
      label.text = detailsViewModel.aqiDescription
      airQuialityIndexView.update(with: aqiViewModel)
    }
  }
}


// MARK: Initial UI Setup
private extension WeatherDetailsAirQualityCell {
  func setupRoundedContentView() {
    addSubview(roundedContentView)
    NSLayoutConstraint.activate([
      roundedContentView.topAnchor.constraint(equalTo: self.topAnchor,
                                              constant: offset),
      roundedContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
      roundedContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset),
      roundedContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -offset)
    ])
  }
  
  func setupStackView() {
    roundedContentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: roundedContentView.topAnchor, constant: offset),
      stackView.leadingAnchor.constraint(equalTo: roundedContentView.leadingAnchor, constant: offset),
      stackView.trailingAnchor.constraint(equalTo: roundedContentView.trailingAnchor, constant: -offset),
      stackView.bottomAnchor.constraint(equalTo: roundedContentView.bottomAnchor, constant: -offset)
    ])
  }
  
  func setupLoadingDataView() {
    roundedContentView.addSubview(loadingDataView)
    NSLayoutConstraint.activate([
      loadingDataView.leadingAnchor.constraint(equalTo: roundedContentView.leadingAnchor, constant: offset),
      loadingDataView.trailingAnchor.constraint(equalTo: roundedContentView.trailingAnchor, constant: -offset),
      loadingDataView.topAnchor.constraint(equalTo: roundedContentView.topAnchor, constant: offset),
      loadingDataView.bottomAnchor.constraint(equalTo: roundedContentView.bottomAnchor, constant: -offset)
    ])
  }
}
