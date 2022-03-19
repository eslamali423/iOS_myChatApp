//
//  Incoming.swift
//  myChatApp
//
//  Created by Eslam Ali  on 14/03/2022.
//

import Foundation
import MessageKit
import CoreLocation

class Incoming {
    
    var messageViewController : MessagesViewController
    
    init(messageViewController : MessagesViewController) {
        self.messageViewController = messageViewController
    }
    
    //MARK:- create MKMessage
    
    func createMKMessage(localMessage : LocalMessage) -> MKMessage {
        
        var mkMessage = MKMessage(message: localMessage)
       // check if the message is photo
         if localMessage.type == KPHOTO {
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            mkMessage.photoItem =  photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            StorageManager.shared.downloadImage(imageUrl: localMessage.pictureUrl) { (image) in
                mkMessage.photoItem?.image = image
                self.messageViewController.messagesCollectionView.reloadData() 
            }
        }
        // check if message is video
        if localMessage.type == KVIDEO {
            StorageManager.shared.downloadImage(imageUrl: localMessage.pictureUrl) { (tumbnailImage) in
             
                StorageManager.shared.downloadVideo(videoUrl: localMessage.videoUrl) { (readyToPlay, fileName) in
                    let videoLink = URL(fileURLWithPath: fileInDocumentDirectory(fileName: fileName))
                    let videoItem = VideoMessage(url: videoLink)
                    
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    mkMessage.videoItem?.image = tumbnailImage
                    self.messageViewController.messagesCollectionView.reloadData()
 
                    
                }
                
            }
        }
        
        // check if the message is location
        if localMessage.type == KLOCATION {
            let locatioItem  = LocationMessage(location: CLLocation(latitude: localMessage.locationLatitude, longitude: localMessage.locationLongitude))
            
            mkMessage.kind = MessageKind.location(locatioItem)
            mkMessage.locationItem = locatioItem
        }
        
        if localMessage.type == KAUDIO {
            let audioMessage = AudioMessage(duration: Float(localMessage.audioDuration))
            mkMessage.audioItem = audioMessage
            mkMessage.kind = MessageKind.audio(audioMessage)
            
            StorageManager.shared.downloadAudio(audioUrl: localMessage.audioUrl) { (fileName) in
                let audioUrl = URL(fileURLWithPath: fileInDocumentDirectory(fileName: fileName))
                mkMessage.audioItem?.url = audioUrl
            }
            self.messageViewController.messagesCollectionView.reloadData()
            
        }
        
        
        
   return mkMessage
    }
    
    
}

