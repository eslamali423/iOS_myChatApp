//
//  MessageDisplayDelegate.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//

import Foundation
import MessageKit

extension MSGViewController : MessagesDisplayDelegate {


    // this fucntion to set color label
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .label
    }
    
    
    // this function to set the collor for message
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let incomingBubble = UIColor(named: "colorIncomingBubble")
        let outgoingBubble = UIColor(named: "colorOutGoingBubble")
        
      
      
        
        return isFromCurrentSender(message: message) ? outgoingBubble as! UIColor : incomingBubble as! UIColor
        
    }
    
   // this message set the tail style for every message
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft

        return .bubbleTail(tail, .curved)
    }
    
    
    
    
}
