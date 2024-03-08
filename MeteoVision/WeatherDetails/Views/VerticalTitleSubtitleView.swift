//
//  VerticalTitleSubtitleCell.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import UIKit

final class VerticalTitleSubtitleView: UIView {
  let type: VerticalTitleSubtitleViewType
  
  private lazy var valueLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 16 : 14, weight: .semibold)
    label.textColor = .defaultText
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 14 : 12, weight: .regular)
    label.textColor = UIColor.systemGray2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var titleStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [valueLabel, descriptionleLabel])
    stackView.spacing = 4
    stackView.alignment = .fill
    stackView.axis = .vertical
    return stackView
  }()
  
  private lazy var horisontalStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [imageView, titleStackView, UIView()])
    stackView.spacing = 8
    stackView.alignment = .fill
    stackView.axis = .horizontal
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  init(type: VerticalTitleSubtitleViewType) {
    self.type = type
    super.init(frame: .zero)
    backgroundColor = .systemBackground
    let offset: CGFloat = 12.0
    addSubview(horisontalStackView)
    NSLayoutConstraint.activate([
      horisontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: offset),
      horisontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
      horisontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset),
      horisontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -offset)
    ])
    addShadow()
    titleStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
  }
  
  func update(with viewModel: VerticalTitleSubtitleViewModel) {
    imageView.image = UIImage.init(systemName: viewModel.iconName)
    valueLabel.text = viewModel.value
    descriptionleLabel.text = viewModel.description
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
