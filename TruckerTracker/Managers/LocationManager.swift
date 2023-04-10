//
//  LocationManager.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/29/23.
//

import Foundation
import CoreLocation

//MARK: - LocationRequestState
enum LocationRequestState {
    case notStarted
    case requestingLocation
    case locationFound
    case canceled
    case timedOut
    case error
}

// MARK: - LocationManager
class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    var locationRequestState: LocationRequestState = .notStarted
    
    var didReceiveLocationInfo: ((String) -> Void)?
    var didFailToReceiveLocation: ((TRError) -> Void)?
    
    var locationTimeout: Double = 15
    private var locationTimeoutTimer: Timer?
    
    
    // Init
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Location Status
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationRequestState = .notStarted
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationRequestState = .requestingLocation
            locationManager.requestLocation()
            checkForLocationTimeout()
            
        case .denied:
            locationRequestState = .error
            didFailToReceiveLocation?(TRError.permissionLocationError)
            
        default:
            locationRequestState = .error
            didFailToReceiveLocation?(TRError.defaultLocationError)
        }
    }
    
    // Request Location
    func requestUserLocation() {
        if locationManager.delegate == nil {
            locationManager.delegate = self
            checkLocationAuthorization()
        } else {
            locationRequestState = .requestingLocation
            locationManager.requestLocation()
            checkForLocationTimeout()
        }
    }
    
    // Location Info
    private func getLocationInfo(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first else {
            throw TRError.defaultLocationError
        }
        
        let city = placemark.locality ?? "Nowhereville"
        let state = placemark.administrativeArea ?? "NA"
        
        return "\(city), \(state)"
    }
    
    // Timeout
    private func checkForLocationTimeout() {
        locationTimeoutTimer?.invalidate()
        locationTimeoutTimer = Timer.scheduledTimer(withTimeInterval: locationTimeout, repeats: false) { _ in
            if self.locationRequestState == .requestingLocation {
                self.locationRequestState = .timedOut
                self.didFailToReceiveLocation?(TRError.timeoutError)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    // Status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    // Location info
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("received raw location")
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let clLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        Task {
            do {
                let locationInfo = try await getLocationInfo(from: clLocation)
                
                print("received location info")
                guard locationRequestState != .timedOut else { return }
                locationRequestState = .locationFound
                didReceiveLocationInfo?(locationInfo)
                
            } catch {
                print("received error")
                guard locationRequestState != .timedOut else { return }
                locationRequestState = .error
                
                if let error = error as? TRError {
                    didFailToReceiveLocation?(error)
                } else if let error = error as? CLError, error.code == .network {
                    didFailToReceiveLocation?(TRError.networkError)
                } else {
                    didFailToReceiveLocation?(TRError.defaultLocationError)
                }
            }
        }
    }
    
    // Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError")
        guard locationRequestState != .timedOut else { return }
        
        locationRequestState = .error
        
        if let error = error as? CLError {
            switch error.code {
            case .network:
                didFailToReceiveLocation?(TRError.networkError)
            case .denied:
                didFailToReceiveLocation?(TRError.permissionLocationError)
            default:
                didFailToReceiveLocation?(TRError.defaultLocationError)
            }
        }
    }
}
