//
//  PhotoMessage.swift
//  myChatApp
//
//  Created by Eslam Ali  on 16/03/2022.
//

import Foundation
import MessageKit

class PhotoMessage : NSObject , MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(path : String) {
        self.url =  URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(named: "imagePlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
    
    
    
}
