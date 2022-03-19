//
//  ChatRoom.swift
//  myChatApp
//
//  Created by Eslam Ali  on 12/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatRoom : Codable {
    
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var receiverId = ""
    var receiverName = ""
    var lastMessage = ""
    @ServerTimestamp var date = Date()
    var unReadCounter = 0
    var avatarLink = ""
    var  memberIds : [String] = []
}
