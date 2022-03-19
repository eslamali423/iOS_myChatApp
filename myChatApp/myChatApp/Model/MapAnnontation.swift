//
//  MapAnnontation.swift
//  myChatApp
//
//  Created by Eslam Ali  on 16/03/2022.
//

import Foundation
import MapKit

class MapAnnotation : NSObject , MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    
    init(title : String? , coordinate : CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
    
}
