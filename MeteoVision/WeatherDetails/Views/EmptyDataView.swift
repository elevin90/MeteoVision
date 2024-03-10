//
//  EmptyDataView.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 10.03.24.
//

import UIKit

final class EmptyDataView: UIView {
  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: UIDevice.isIPad ? 32 : 28, weight: .bold)
    label.textColor = .defaultText
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
}
