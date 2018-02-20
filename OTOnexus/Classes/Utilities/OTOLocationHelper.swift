//
//  LocationHelper.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation
import CoreLocation

class OTOLocationHelper: NSObject {
    static let shared = OTOLocationHelper()
    fileprivate let locationManager = CLLocationManager()
    
    var currentLocation:CLLocation? {
        return locationManager.location
    }
    
    var userDeniedLocation:Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func start() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

extension OTOLocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        OTOnexus.shared.userLocationAccessChanged(denied: status == .denied)
    }
}
