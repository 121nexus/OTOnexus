//
//  LocationHelper.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 1/10/18.
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
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
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
