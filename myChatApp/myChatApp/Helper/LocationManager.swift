//
//  LocationManager.swift
//  myChatApp
//
//  Created by Eslam Ali  on 16/03/2022.
//

import Foundation
import CoreLocation

class LocationManager : NSObject , CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var locationManager  : CLLocationManager?
    var currentLocation : CLLocationCoordinate2D?
    
    
    private override init () {
        super.init()
        self.requestLocationAccess()
    }
    
    func requestLocationAccess() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        } else  {
            print("we already have the access to location")
        }
    }
    
    func startUpdating()  {
        locationManager!.startUpdatingLocation()
    }
    
    
    func stopUpdating (){
        if locationManager != nil {
            locationManager!.stopUpdatingLocation()
        }
    }
    
    //MARK:- Delagate Functoins
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!.coordinate
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO:- ProcessHUD
        print("can't get location", error.localizedDescription)
   
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationManager!.requestWhenInUseAuthorization()
    }
    
    
}
