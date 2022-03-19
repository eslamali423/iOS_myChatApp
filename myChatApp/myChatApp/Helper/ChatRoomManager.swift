//
//  ChatRoomManager.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//

import Foundation
import Firebase

class ChatRoomManager {
    
    static let shared = ChatRoomManager()
    
    private init () {}
    
    
    //MARK:- Save chat room to firestore
    func saveChatRoomToFirestore(chatRoom : ChatRoom) {
       
        do  {
            try firestoreReferance(.Chats).document(chatRoom.id).setData(from: chatRoom)

        }catch {
            print("Error in Saving data in Firestore " , error.localizedDescription)
        }
        
    }
    
    //MARK:- Download All Chat Rooms Form Firestore
    // there is a problem here when you sign out because userid not found
    func donwloadChatRooms(completion : @escaping (_ allChatRooms : [ChatRoom])->Void) {
        
        firestoreReferance(.Chats).whereField("senderId", isEqualTo: User.currentID).addSnapshotListener { (snapshot, error) in
            var chatRooms : [ChatRoom] = []

            guard let document = snapshot?.documents else  {
                print("No documents found")
                return
            }
            let allChatRooms = document.compactMap { ( snapshot) -> ChatRoom? in
                return try? snapshot.data(as: ChatRoom.self)
            }
            
            for chatRoom in allChatRooms {
                if chatRoom.lastMessage != "" {
                    chatRooms.append(chatRoom)
                }
            }
            
            chatRooms.sort(by: {$0.date! > $1.date!})
            completion(chatRooms)
            

        }
    }
    
    //MARK:- Delete Chat Room Form The Table
    func deleteChatRoom( _ chatRoom : ChatRoom) {
        firestoreReferance(.Chats).document(chatRoom.id).delete()
    }
    
    
    //MARK:- Reset Unread Counter
    
    func clearUnreadCounter(chatRoom : ChatRoom) {
        var newChatRoom = chatRoom
        newChatRoom.unReadCounter = 0
        self.saveChatRoomToFirestore(chatRoom: newChatRoom)
    }
    
    // Reset Unread Counter using Chatroom ID
    func clearUnreadCounterWithId(chatRoomId : String) {
        
        firestoreReferance(.Chats).whereField(KCHATROOMID, isEqualTo: chatRoomId).whereField(KSENDERID, isEqualTo: User.currentID).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            let allChatRooms =  documents.compactMap { (querySnapshot) -> ChatRoom? in
                return try? querySnapshot.data(as: ChatRoom.self )
            }
            if allChatRooms.count > 0 {
                self.clearUnreadCounter(chatRoom: allChatRooms.first!)
            }
        }
    }
    
    // update Chatroom with new message
    func updateChatRoomWithNewMessage(chatRoom : ChatRoom, lastMessage : String) {
        var tempChatRoom = chatRoom
      
        if tempChatRoom.senderId != User.currentID {
            tempChatRoom.unReadCounter += 1
        }
            tempChatRoom.lastMessage = lastMessage
            tempChatRoom.date = Date()
            self.saveChatRoomToFirestore(chatRoom: tempChatRoom)
        
    }
    
    
    // update Chatrooms  for sender and receiver
    func updateChatRooms(chatRoomId : String, lastMessage : String)  {
        firestoreReferance(.Chats).whereField(KCHATROOMID, isEqualTo: chatRoomId).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else  {return}
            
            let allChatRooms = documents.compactMap { (querySnapshot) -> ChatRoom? in
                return try? querySnapshot.data(as: ChatRoom.self)
            }
            
            for chatRoom in allChatRooms {
                self.updateChatRoomWithNewMessage(chatRoom: chatRoom, lastMessage: lastMessage)
            }
            
        }
    }
    
    
}
