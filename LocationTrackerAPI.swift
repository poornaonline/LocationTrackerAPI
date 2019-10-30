//
//  LocationTracker
//  Tester
//
//  Created by Poorna Jayasinghe on 10/30/19.
//  Copyright © 2019 Poorna Jayasinghe. All rights reserved.
//

import Foundation
import MapKit

/*
 Add - NSLocationAlwaysAndWhenInUseUsageDescription
 Add - NSLocationWhenInUseUsageDescription

 Turn on - Capabilities -> Background modes -> Location updates
 */
class LocationTracker: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var userHeading: CLLocationDirection?


    func getUserCurrentLocation() -> CLLocationCoordinate2D? {
        return self.userLocation
    }

    func getUserCurrentHeading() -> CLLocationDirection? {
        return self.userHeading
    }

    func stopLocationTracking() {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
    }

    func startLocationTracking() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.showsBackgroundLocationIndicator = true
            self.locationManager.headingFilter = 1
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        } else {
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                UIApplication.shared.openURL(url)
            }
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.userLocation = currentLocation
        print("User Location = \(userLocation!.latitude) \(userLocation!.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.userHeading = newHeading.trueHeading
        print("User Heading = \(newHeading.trueHeading)")
    }


}

class JayLocationTracker {

    static var internalLocationTracker: LocationTracker?

    static func startTracking() {
        if internalLocationTracker == nil {
            internalLocationTracker = LocationTracker()
        }
        internalLocationTracker!.startLocationTracking()
        print("Location tracking started")
    }

    static func stopTracking() {
        if internalLocationTracker != nil {
            internalLocationTracker!.stopLocationTracking()
            print("Location tracking stopped")
        }
    }

}
