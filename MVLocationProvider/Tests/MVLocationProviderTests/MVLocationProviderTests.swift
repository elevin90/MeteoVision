import XCTest
import CoreLocation
@testable import MVLocationProvider

final class MVLocationProviderTests: XCTestCase {
  private final class LocationMager: LocationManaging {
    var delegate: CLLocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy = 0.0
    var distanceFilter: CLLocationDistance = 0.0
    var allowsBackgroundLocationUpdates: Bool = false
    
    func requestLocation() {
      delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [CLLocation(latitude: 12, longitude: 12)])
    }
  }
  
  func testDelegateMethods() {
    let locationManager = LocationMager()
    let provider = MVLocationProvider(locationManager: locationManager)
    provider.didUpdateLocationCoordinatesHandler = { locationCoordinates in
      XCTAssertEqual(locationCoordinates.latitude, 12)
      XCTAssertEqual(locationCoordinates.longitude, 12)
    }
    provider.didUpdateLocationCoordinatesHandler = { locationCoordinates in
      XCTAssertEqual(locationCoordinates.latitude, 12)
    }
    provider.requestLocation()
  }
  
  func testGeocode() async throws {
    let locationProvider = MVLocationProvider(locationManager: LocationMager())
    let address = "San Francisco"
    let expectedCoordinates = CLLocationCoordinate2D(latitude: 37.7, longitude: -122.4)
    
    // Act
    let coordinates = try await locationProvider.geocode(adress: address)
    
    // Assert
    XCTAssertEqual(coordinates.latitude, expectedCoordinates.latitude, accuracy: 0.1, "Latitude should match")
    XCTAssertEqual(coordinates.longitude, expectedCoordinates.longitude, accuracy: 0.1, "Longitude should match")
  }
}
