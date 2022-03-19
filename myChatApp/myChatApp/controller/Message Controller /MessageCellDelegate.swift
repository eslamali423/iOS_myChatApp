//
//  MessageCellDelegate.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//

import Foundation
import MessageKit
import AVFoundation
import AVKit
import SKPhotoBrowser


extension MSGViewController : MessageCellDelegate {
    
    
    func didTapImage(in cell: MessageCollectionViewCell) {
    
        if let indextPath = messagesCollectionView.indexPath(for: cell) {
      
            let mkMessage =  mkMessages[indextPath.section]
            // check if the message is photo
            if mkMessage.photoItem != nil && mkMessage.photoItem?.image != nil {
               var images = [SKPhoto]()
                let photo = SKPhoto.photoWithImage(mkMessage.photoItem!.image!)
                images.append(photo)
                
                let photoBrowser = SKPhotoBrowser(photos: images)
                
                self.present(photoBrowser, animated: true, completion: nil)
                
            }
            // check if the message is video
            if mkMessage.videoItem != nil && mkMessage.videoItem?.url != nil {
              
                let playerController = AVPlayerViewController()
                let player = AVPlayer(url: mkMessage.videoItem!.url!)
                playerController.player = player
                
                let session  =  AVAudioSession.sharedInstance()
                try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                
                self.present(playerController, animated: true) {
                    playerController.player!.play()
                }
          
            }
  
        }
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
        let mkMessage = mkMessages[indexPath.section]
 
            if mkMessage.locationItem != nil {
                let mapVC = MapViewController()
                mapVC.location = mkMessage.locationItem?.location
                navigationController?.pushViewController(mapVC, animated: true)
            }
        
        }
    }
    
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
    
}

