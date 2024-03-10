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

public protocol LocationManaging {
  var delegate: CLLocationManagerDelegate? { get set }
  var desiredAccuracy: CLLocationAccuracy { get set }
  var distanceFilter: CLLocationDistance { get set }
  var allowsBackgroundLocationUpdates: Bool { get set }
  func requestLocation()
}

extension CLLocationManager: LocationManaging { }

public final class MVLocationProvider: NSObject, MVLocationProviding {
  private var locationManager: LocationManaging
  private let geocoder = CLGeocoder()
  public var didUpdateLocationCoordinatesHandler: ((CLLocationCoordinate2D) -> Void)?
  public var didChangeAuthorisationStatusHandler: ((CLAuthorizationStatus) -> Void)?
  private var failHandler: ((Error) -> Void)?
  private var authStatus = CLAuthorizationStatus.notDetermined
  
  public init(locationManager: LocationManaging = CLLocationManager()) {
    self.locationManager = locationManager
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
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    failHandler?(error)
  }
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
