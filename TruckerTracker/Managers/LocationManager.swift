//
//  LocationManager.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/29/23.
//

import Foundation
import CoreLocation

//MARK: - LocationRequestState
private enum LocationRequestState {
    case notStarted
    case requestingLocation
    case locationFound
    case canceled
    case timedOut
    case error
}

// MARK: - LocationManager
class LocationManager: NSObject {
    
    var locationTimeout: Double = 15
    private var locationTimeoutTimer: Timer?
    
    private let locationManager = CLLocationManager()
    private var locationRequestState: LocationRequestState = .notStarted
    
    var didReceiveLocationInfo: ((String) -> Void)?
    var didFailToReceiveLocation: ((LocationError) -> Void)?
    
    
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
            didFailToReceiveLocation?(LocationError.permissionLocationError)
            
        default:
            locationRequestState = .error
            didFailToReceiveLocation?(LocationError.defaultLocationError)
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
    
    func stopLocationUpdates() {
        guard locationRequestState == .requestingLocation else { return }
        
        locationManager.stopUpdatingLocation()
        locationRequestState = .canceled
        didFailToReceiveLocation = nil
        didReceiveLocationInfo = nil
    }
    
    // Location Info
    private func getLocationInfo(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first else {
            throw LocationError.defaultLocationError
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
                self.didFailToReceiveLocation?(LocationError.timeoutError)
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
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let clLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        Task {
            do {
                let locationInfo = try await getLocationInfo(from: clLocation)
                guard locationRequestState != .timedOut else { return }
                
                locationRequestState = .locationFound
                didReceiveLocationInfo?(locationInfo)
            } catch {
                guard locationRequestState != .timedOut else { return }
                locationRequestState = .error
                
                if let error = error as? LocationError {
                    didFailToReceiveLocation?(error)
                } else if let error = error as? CLError, error.code == .network {
                    didFailToReceiveLocation?(LocationError.networkError)
                } else {
                    didFailToReceiveLocation?(LocationError.defaultLocationError)
                }
            }
        }
    }
    
    // Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard locationRequestState != .timedOut else { return }
        locationRequestState = .error
        
        if let error = error as? CLError {
            switch error.code {
            case .network:
                didFailToReceiveLocation?(LocationError.networkError)
            case .denied:
                didFailToReceiveLocation?(LocationError.permissionLocationError)
            default:
                didFailToReceiveLocation?(LocationError.defaultLocationError)
            }
        }
    }
}
