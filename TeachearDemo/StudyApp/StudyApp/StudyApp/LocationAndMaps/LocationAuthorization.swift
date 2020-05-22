//
//  LocationAuthorization.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/31.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import Foundation
import CoreLocation

class LocationAuthorization: NSObject {
    var manager: CLLocationManager!
    
    override init() {
        super.init()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 300
    }
    
    func isServiceEnable() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func getCurrentStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
        case .restricted:
            print("restricted")
        default:
            print("unknown status")
        }
    }
    
    func requestForAuthorization() {
        manager.requestAlwaysAuthorization()
//        manager.requestWhenInUseAuthorization()
    }
    
    func startLocation() {
        if isServiceEnable() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            manager.startUpdatingLocation()
        } else {
            print("denied")
        }
    }
    
    func geo(location: CLLocation) {
        let gecoder = CLGeocoder()
        gecoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            let placeMark = placeMarks?.first
            if let placeMark = placeMark{
                print("\(placeMark.country!) -- \(placeMark.name!) -- \(placeMark.locality!)")
            }
        }
    }
}

extension LocationAuthorization: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getCurrentStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("location: lat = \(location.coordinate.latitude), long = \(location.coordinate.longitude)")
            geo(location: location)
            manager.stopUpdatingLocation()
        }
    }
}


