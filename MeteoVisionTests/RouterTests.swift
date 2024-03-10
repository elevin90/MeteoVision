//
//  RouterTests.swift
//  MeteoVisionTests
//
//  Created by YAUHENI LEVIN on 10.03.24.
//

import XCTest
import UIKit
@testable import MeteoVision

final class RouterTests: XCTestCase {
  private let mockViewController = MockViewController()
  private let router = Router()
  
  private final  class MockViewController: UIViewController {
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
      super.present(viewControllerToPresent, animated: flag)
      completion?()
    }
  }
  
  func testShowAlert() {
    let expectation = XCTestExpectation(description: "Alert presented")

    // Act
    router.showAlert(title:  "Test Title", message: "Test Message", buttonTitle:  "OK", on: mockViewController) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
  }
}
