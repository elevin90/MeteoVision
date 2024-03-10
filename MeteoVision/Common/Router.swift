//
//  Router.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 10.03.24.
//

import UIKit

protocol Routing {
  func showAlert(
    title: String,
    message: String,
    buttonTitle: String?,
    on parentController: UIViewController?,
    completion: (() -> Void)?
  )
}

final class Router: Routing {
  func showAlert(
    title: String = "Error",
    message: String,
    buttonTitle: String?,
    on parentController: UIViewController?,
    completion: (() -> Void)?
  ) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if let buttonTitle {
      alertController.addAction(UIAlertAction(title: buttonTitle, style: .default))
    }
    parentController?.present(alertController, animated: true, completion: {
      completion?()
    })
  }
}
