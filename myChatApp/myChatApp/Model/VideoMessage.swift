//
//  VideoMessage.swift
//  myChatApp
//
//  Created by Eslam Ali  on 16/03/2022.
//

import Foundation
import MessageKit

class VideoMessage : NSObject , MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(url : URL?) {
        self.url = url
        self.placeholderImage = UIImage(named: "VideoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
    
    
    
}
