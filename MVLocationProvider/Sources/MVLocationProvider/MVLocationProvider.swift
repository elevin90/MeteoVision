//
//  MVLocationProvider.swift
//  Created by YAUHENI LEVIN on 4.03.24.
//
import Foundation
import CoreLocation

public protocol MVLocationProviding {
  var didUpdateLocationCoordinatesHandler: ((CLLocationCoordinate2D) -> Void)? { get set }
  var didChangeAuthorisationStatusHandler: ((CLAuthorizationStatus) -> Void)? { get set }
  func requestLocation()
  func geocode(adress: String) async throws -> CLLocationCoordinate2D
}

public final class MVLocationProvider: NSObject, MVLocationProviding {
  private let locationManager = CLLocationManager()
  private let geocoder = CLGeocoder()
  public var didUpdateLocationCoordinatesHandler: ((CLLocationCoordinate2D) -> Void)?
  public var didChangeAuthorisationStatusHandler: ((CLAuthorizationStatus) -> Void)?
  private var authStatus = CLAuthorizationStatus.notDetermined
  
  public override init() {
    super.init()
    setupLocationManager()
  }
  
  private func setupLocationManager() {
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    locationManager.distanceFilter = 500
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.delegate = self
  }
}

extension MVLocationProvider: CLLocationManagerDelegate {
  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard authStatus != manager.authorizationStatus else {
      return
    }
    didChangeAuthorisationStatusHandler?(manager.authorizationStatus)
    self.authStatus = manager.authorizationStatus
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    didUpdateLocationCoordinatesHandler?(location.coordinate)
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}

extension MVLocationProvider {
  public func requestLocation() {
     locationManager.requestLocation()
   }
   
  public func geocode(adress: String) async throws -> CLLocationCoordinate2D {
     do {
       guard let placemark = try await geocoder.geocodeAddressString(adress).first,
             let coordinates =  placemark.location?.coordinate else {
         throw CLError(.geocodeFoundNoResult)
       }
       return coordinates
     } catch {
       throw CLError(.geocodeFoundNoResult)
     }
   }
}
