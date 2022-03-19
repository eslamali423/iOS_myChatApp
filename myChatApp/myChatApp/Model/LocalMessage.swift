//
//  LocalMessage.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//


import Foundation
import RealmSwift


class LocalMessage : Object, Codable {
    
 @objc dynamic var id = ""
 @objc dynamic var chatRoomId = ""
 @objc dynamic var date = Date()
 @objc dynamic var senderName = ""
 @objc dynamic var senderId = ""
 @objc dynamic var senderInitials = ""
 @objc dynamic var readDate = Date()
 @objc dynamic var type  = ""
 @objc dynamic var status = ""
 @objc dynamic var message = ""
 @objc dynamic var audioUrl = ""
 @objc dynamic var audioDuration = 0.0
 @objc dynamic var videoUrl = ""
 @objc dynamic var pictureUrl = ""
 @objc dynamic var locationLatitude = 0.0
 @objc dynamic var locationLongitude = 0.0

    override class func primaryKey() -> String{
        return "id"
    }
    
}


