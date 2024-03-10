//
//  LoadingDataView.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 9.03.24.
//

import UIKit

final class LoadingDataView: UIView {
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.hidesWhenStopped = true
    return activityIndicator
  }()
  
  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 16 : 14, weight: .thin)
    label.textColor = .defaultText
    label.textAlignment = .center
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [activityIndicator, label])
    stackView.spacing = UIDevice.isIPad ? 16 : 8
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func update(with state: WeatherDetailsCellViewModelState) {
    switch state {
    case .loading:
      activityIndicator.startAnimating()
      label.isHidden = false
      label.text = "Loading data"
    case .success:
      activityIndicator.stopAnimating()
      label.isHidden = true
    case .failure:
      activityIndicator.stopAnimating()
      label.text = "Error loading data"
      label.isHidden = false
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
