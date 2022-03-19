//
//  MessageLayoutDelegate.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//

import Foundation
import MessageKit

extension MSGViewController : MessagesLayoutDelegate {
    
    // this function to set the height for lables (section) [date, pull for more messages]
    // cell top label
    public func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section % 3 == 0 {
            // set height for pull for new messages label
            if indexPath.section == 0 && allLocalMessages.count > displayingMessageCount{
                return 40
            }
        }
   return 10
    }
    
    
    
    // this function to set the height for lables (section) [date, pull for more messages]
    // cell top label
    public func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
     
        return isFromCurrentSender(message: message) && indexPath.section == mkMessages.count - 1 ? 17 : 0
        
    }
    // this function to set height for time and status for every message
    public func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
  
        return indexPath.section != mkMessages.count - 1 ? 15 : 0
   
    }
    
    // this fucntion to set the first letter from username in the avatar
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.set(avatar: Avatar(image: nil, initials: mkMessages[indexPath.section].senderInitials))
    }
    
    
    
    // i write this function here because isFormCurrentSender doesn't exist here
// this function from the internet
//    func isFromCurrentSender(message: MessageType) -> Bool {
//       
//        return message.sender.senderId == User.currentID
//    }
//

   
  
 
   
    
    
    
    
}
