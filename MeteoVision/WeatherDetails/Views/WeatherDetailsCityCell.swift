//
//  WeatherDetailsCityCell.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import UIKit

enum WeatherDetailsCellViewModelState: Equatable {
  case loading
  case success
  case failure
}

protocol WeatherDetailViewModeling {
  var cellId: String { get }
  var state: WeatherDetailsCellViewModelState { get }
}

protocol WeatherDetailCellUpdating {
  func update(with viewModel: WeatherDetailViewModeling)
}

final class WeatherDetailsCityCell: BaseTableViewCell, WeatherDetailCellUpdating {
  enum Constants {
    static let sideOffset: CGFloat = 12.0
    static let innerOffset: CGFloat = 8.0
  }
  private lazy var locationLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 32 : 28, weight: .bold)
    label.textColor = .defaultText
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var locationImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "location.fill"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 22 : 16, weight: .medium)
    label.textColor = .defaultText
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var degreesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 32 : 28, weight: .bold)
    label.textColor = .defaultText
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var weatherImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  private lazy var upArrowImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    imageView.image = UIImage(systemName: "arrow.up")
    return imageView
  }()
  
  private lazy var downArrowImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    imageView.image = UIImage(systemName: "arrow.down")
    return imageView
  }()
  
  private lazy var maxDegreesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 16 : 14, weight: .thin)
    label.textColor = .defaultText
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var minDegreesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 16 : 14, weight: .thin)
    label.textColor = .defaultText
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var titleStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [locationImageView, locationLabel, UIView()])
    stackView.spacing = Constants.innerOffset
    stackView.alignment = .fill
    stackView.axis = .horizontal
    return stackView
  }()
  
  private lazy var degreesDetailsStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [degreesLabel, weatherImageView, UIView(), upArrowImageView, maxDegreesLabel, downArrowImageView, minDegreesLabel])
    stackView.spacing = 8
    stackView.alignment = .fill
    stackView.axis = .horizontal
    return stackView
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [titleStackView, descriptionLabel, degreesDetailsStackView])
    stackView.spacing = UIDevice.isIPad ? 62 : 42
    stackView.setCustomSpacing(28, after: titleStackView)
    stackView.alignment = .fill
    stackView.axis = .vertical
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
  }
  
  func update(with viewModel: WeatherDetailViewModeling) {
    guard let viewModel = viewModel as? WeatherDetailsCityCellViewModel else {
      return
    }
    [locationImageView, weatherImageView, upArrowImageView, downArrowImageView].forEach {
      $0.isHidden = viewModel.state != .success
    }
    loadingDataView.update(with: viewModel.state)
    locationLabel.text = viewModel.location ?? ""
    descriptionLabel.text = viewModel.weatherDescription ?? ""
    degreesLabel.text = viewModel.temperature
    if let weatherIconName = viewModel.weatherIconName {
      weatherImageView.image = UIImage(systemName: weatherIconName)
    }
    maxDegreesLabel.text = viewModel.maxTemperature ?? ""
    minDegreesLabel.text = viewModel.minimalTemperature  ?? ""
    loadingDataView.isHidden = viewModel.state == .success
  }
}

// MARK: Initial UI Setup
private extension WeatherDetailsCityCell {
  private func setupRoundedContentView() {
    addSubview(roundedContentView)
    NSLayoutConstraint.activate([
      roundedContentView.topAnchor.constraint(equalTo: self.topAnchor,
                                              constant: offset),
      roundedContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
      roundedContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset),
      roundedContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -offset)
    ])
  }
  
  private func setupStackView() {
    roundedContentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: roundedContentView.topAnchor, constant: offset),
      stackView.leadingAnchor.constraint(equalTo: roundedContentView.leadingAnchor, constant: offset),
      stackView.trailingAnchor.constraint(equalTo: roundedContentView.trailingAnchor, constant: -offset),
      stackView.bottomAnchor.constraint(equalTo: roundedContentView.bottomAnchor, constant: -offset)
    ])
    
    NSLayoutConstraint.activate([
      locationImageView.widthAnchor.constraint(equalToConstant: 30),
      locationImageView.heightAnchor.constraint(equalToConstant: 30)
    ])
    
    NSLayoutConstraint.activate([
      weatherImageView.widthAnchor.constraint(equalToConstant: 22),
      weatherImageView.heightAnchor.constraint(equalToConstant: 22)
    ])
    
    NSLayoutConstraint.activate([
      upArrowImageView.widthAnchor.constraint(equalToConstant: 12),
      upArrowImageView.heightAnchor.constraint(equalToConstant: 22)
    ])
    
    NSLayoutConstraint.activate([
      downArrowImageView.widthAnchor.constraint(equalToConstant: 12),
      downArrowImageView.heightAnchor.constraint(equalToConstant: 22)
    ])
  }
  
  private func setupLoadingDataView() {
    roundedContentView.addSubview(loadingDataView)
    NSLayoutConstraint.activate([
      loadingDataView.leadingAnchor.constraint(equalTo: roundedContentView.leadingAnchor),
      loadingDataView.trailingAnchor.constraint(equalTo: roundedContentView.trailingAnchor),
      loadingDataView.centerYAnchor.constraint(equalTo: roundedContentView.centerYAnchor)
    ])
    loadingDataView.isHidden = true
  }
}
