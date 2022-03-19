//
//  MKMessage.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//

import Foundation
import MessageKit
import CoreLocation

struct MKMessage :  MessageType {
   
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var mkSender : MKSender
    var sender: SenderType {
        return mkSender
    }
    
    var senderInitials : String //  if user does'nt have avatar put fist letter form his name
   
    var photoItem  : PhotoMessage?
    var videoItem  : VideoMessage?
    var locationItem :LocationMessage?
    var audioItem  : AudioMessage?
    
    var status : String
    var readDate : Date
    var incoming : Bool
    
    
    
    
    init( message : LocalMessage){
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status =  message.status
        self.kind = MessageKind.text(message.message)
        
        switch message.type {
        case KTEXT:
            self.kind = MessageKind.text(message.message)
        case KPHOTO:
            let photoItem = PhotoMessage  (path: message.pictureUrl)
            self.kind = MessageKind.photo(photoItem)
            self.photoItem = photoItem
      
        case KVIDEO:
            let videoItem = VideoMessage  (url: nil)
            self.kind = MessageKind.video(videoItem)
            self.videoItem  = videoItem
     
        case KLOCATION:
            let locationItem = LocationMessage(location: CLLocation(latitude: message.locationLatitude, longitude: message.locationLongitude))
            self.kind = MessageKind.location(locationItem)
            self.locationItem    = locationItem
        case KAUDIO:
            let audioItem = AudioMessage(duration: 0.2)
            self.kind = MessageKind.audio(audioItem)
            self.audioItem = audioItem
        default:
            self.kind = MessageKind.text(message.message)
            print("Unkonwn Error ")
        }
        
        
        self.senderInitials = message.senderInitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = User.currentID != mkSender.senderId
        
        
    }
    
    
    
    
    
    
    
    
}
