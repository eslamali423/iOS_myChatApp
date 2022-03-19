//
//  LocationMessage.swift
//  myChatApp
//
//  Created by Eslam Ali  on 16/03/2022.
//

import Foundation
import CoreLocation
import MessageKit


class LocationMessage : NSObject , LocationItem {

    var location: CLLocation
    var size: CGSize

    init(location : CLLocation){
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}
