//
//  AirQualityIndexView.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 9.03.24.
//

import UIKit

final class AirQualityIndexView: UIView {
  private lazy var aqiLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 18 : 14, weight: .semibold)
    label.text = "AQI"
    label.textAlignment = .center
    label.textColor = .defaultText
    label.numberOfLines = 1
    return label
  }()
  
  private lazy var valueLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 20 : 16, weight: .bold)
    label.textColor = .defaultText
    label.textAlignment = .center
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [aqiLabel, valueLabel])
    stackView.spacing = UIDevice.isIPad ? 8 : 4
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
    ])
    layer.cornerRadius = 6
  }
  
  func update(with viewModel: AirQualityIndexViewModel) {
    valueLabel.text = viewModel.index
    backgroundColor = viewModel.color
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
