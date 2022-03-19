//
//  Outgoing.swift
//  myChatApp
//
//  Created by Eslam Ali  on 14/03/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import UIKit
import Gallery


class Outgoing {
    
    static let shared = Outgoing()
    
    func sendMessage(chatId : String, text : String? , photo : UIImage? , video : Video? , audio: String?, audioDuration : Float = 0.0 , location :String?, memberIds : [String])  {
        
        let currentUser = User.currentUser!
        
        // 1- create local message
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName =  currentUser.username
        message.senderInitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = KSENT
        
        // 2- check message type [text, picture, video, location, audio]
        
        if text != nil{
            sendText(message: message, text: text!, memberIds: memberIds)
            
        }
        if photo != nil {
            sendPhoto(message: message, photo: photo!, memberIds: memberIds)
        }
        if video != nil{
            sendVideo(message: message, video: video!, memberIds: memberIds)
            
            
        }
        if audio != nil {
            sendAudio(message: message, audioFileName: audio!, AudioDuration: audioDuration, memberIds: memberIds)
        }
        if location != nil{
            
            sendLocation(message: message, memberIds: memberIds)
        }
        
        // TODO:- Send Push Notification
        
        //  Update  chatroom
        ChatRoomManager.shared.updateChatRooms(chatRoomId: chatId, lastMessage: message.message)
        
    }
    // save message to fire store
    func saveMessage(message : LocalMessage , memberIds : [String]){
        
        RealmManager.shared.save(message)
        
        for memberId in memberIds {
            MessageManager.shared.addMessage(message: message, memberId: memberId)
        }
    }
    
    
}

//MARK:-  TEXT
// this function if the message type (Text)
func sendText(message :LocalMessage , text : String , memberIds  : [String] )  {
    message.message =  text
    message.type = KTEXT
    
    Outgoing.shared.saveMessage(message: message, memberIds: memberIds)
    
}



//MARK:- Photo
// this function if the message type (photo)
func sendPhoto(message :LocalMessage , photo : UIImage , memberIds  : [String] )  {
    message.message =  "Photo Message"
    message.type = KPHOTO
    
    
    let fileName = UUID().uuidString
    let fileDirectory = "MediaStorage/photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".jpg"
    
    StorageManager.shared.saveFileLocally(fileData: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
    StorageManager.shared.uploadImgage(image: photo, directory: fileDirectory) { (imageUrl) in
        guard imageUrl != nil else {return}
        message.pictureUrl = imageUrl!
        Outgoing.shared.saveMessage(message: message, memberIds: memberIds)
        
    }
    
    
}



//MARK:- Video
func sendVideo (message: LocalMessage , video : Video, memberIds : [String])  {
    message.message =  "Video Message"
    message.type = KVIDEO
    
    let fileName = UUID().uuidString
    
    
    let thumbnailDirectory = "MediaStorage/photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".jpg"
    let videoDirectory = "MediaStorage/video/" + "\(message.chatRoomId)" + "_\(fileName)" + ".mov"
    
    
    let editor =  VideoEditor()
    editor.process(video: video) { (prossedVideo, videoURL) in
        
        guard let tempPath = videoURL else  {return }
        // create video Thumbnail
        let thumbnail = videoThumbnail(videoUrl: tempPath)
        
        // save the thumbnail image Locally
        StorageManager.shared.saveFileLocally(fileData: thumbnail.jpegData(compressionQuality: 0.7) as! NSData, fileName: fileName)
        // save the thumbnail image on firestore
        StorageManager.shared.uploadImgage(image: thumbnail, directory: thumbnailDirectory) { (imageLink) in
            guard imageLink != nil else  {return}
            let videoData =  NSData(contentsOfFile: tempPath.path)
            
            //save the video locally
            StorageManager.shared.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
            // save the video on firestore
            StorageManager.shared.uploadVideo(video: videoData!, directory: videoDirectory) { (videoLink) in
                
                guard videoLink != nil else {return}
                
                message.videoUrl = videoLink  ?? ""
                message.pictureUrl = imageLink ?? ""
                
                Outgoing.shared.saveMessage(message: message, memberIds: memberIds)
                
            }
            
        }
        
    }
    
}



//MARK:- Location
func sendLocation(message :LocalMessage, memberIds : [String]) {
    
    let currentLocation  =  LocationManager.shared.currentLocation
    
    message.message = "Location Message"
    message.type = KLOCATION
    message.locationLatitude = currentLocation?.latitude ?? 0.0
    message.locationLongitude = currentLocation?.longitude ?? 0.0
    
    Outgoing.shared.saveMessage(message: message, memberIds: memberIds)
  
}

//MARK:- Audio Record

func sendAudio(message : LocalMessage, audioFileName:String, AudioDuration: Float, memberIds: [String])  {
    message.message = "Audio Message"
    message.type = KAUDIO
    
    let fileDirectory = "MediaStorage/Audio/" + "\(message.chatRoomId)" + "_\(audioFileName)" + ".m4a"
    
    StorageManager.shared.uploadAudio(AudioFileName: audioFileName, directory: fileDirectory) { (audioLink) in
        guard  audioLink != nil  else { return }
            message.audioUrl = audioLink ?? ""
            message.audioDuration = Double(AudioDuration)
            
            Outgoing.shared.saveMessage(message: message, memberIds: memberIds)

            
        }
    }




