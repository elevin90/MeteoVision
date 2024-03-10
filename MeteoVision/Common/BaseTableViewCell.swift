//
//  BaseTableViewCell.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupView()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  func makeClearBackground() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    backgroundView?.backgroundColor = .clear
  }
  
  open func setupView() {}
}
