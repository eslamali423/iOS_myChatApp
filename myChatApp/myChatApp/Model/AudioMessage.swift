//
//  AudioMessage.swift
//  myChatApp
//
//  Created by Eslam Ali  on 17/03/2022.
//

import Foundation
import MessageKit

class AudioMessage : NSObject, AudioItem {
    
    var url: URL
    var duration: Float
    var size: CGSize
    
    init(duration : Float) {
        self.url = URL(fileURLWithPath: "")
        self.duration = duration
        self.size =  CGSize(width: 180, height: 35)
    }
    
    
    
}
