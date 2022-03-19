//
//  StartChat.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//

import Foundation
import Firebase


//MARK:- Restart Chat this function to chack if both users has the chatroom already or not
func restartChat(chatRoomId : String, memberIds : [String]) {
    //download users using member ids
    UserManager.shared.downloadAllUsersFromFirestireUsingIds(memberIds) { (allUsers) in
        
        if allUsers.count > 0 {
            createChatRoom(chatRoomID: chatRoomId, users: allUsers)
        }
    }
}


//MARK:-  Start Chat
// Did Tap StartChat
// this function creates Chatroom ID, comparing between sender id and receiver id and always put the smallest id in first, to handel who is start chat first
func startChat(sender : User, receiver : User) -> String {
    
    var chatRoomID = ""
    let value =  sender.id.compare(receiver.id).rawValue
    chatRoomID = value < 0 ? (sender.id + receiver.id) : (receiver.id + sender.id)
    
    createChatRoom(chatRoomID: chatRoomID, users: [sender, receiver])
    
    return chatRoomID
}

func createChatRoom(chatRoomID : String, users : [User])  {
    // check if users (sender, receiver) already have the chatRomm in firestore
    
    // add users (sender , receicer ) id in the array
    var usersToCreateChatRoom : [String] = []
    for user in users {
        usersToCreateChatRoom.append(user.id)
        
        firestoreReferance(.Chats).whereField("chatRoomId", isEqualTo: chatRoomID).getDocuments { (QuerySnapshot, error) in
            guard let snapshot =  QuerySnapshot else  {
                // this means no document in return  = sender and receiver don't have the chatroom for this id
                return}
            if !snapshot.isEmpty {
                // to remove id if user has already chatRoom
                // got every Document in snapshot
                for chatData in snapshot.documents {
                    // convert every doc to a dictnary
                    let currentChat = chatData.data() as Dictionary
                    if let currentUserId = currentChat["senderId"] {
                        if usersToCreateChatRoom.contains(currentUserId as! String) {
                            usersToCreateChatRoom.remove(at: usersToCreateChatRoom.firstIndex(of: currentUserId as! String)!)
                        }
                    }
                }
            }
            
            for userId in usersToCreateChatRoom {
               
                let senderUser = userId == User.currentID ? User.currentUser! : getReceiverID(users: users)
                let receiverUser = userId == User.currentID ? getReceiverID(users: users) : User.currentUser!
                
                let id = "\(senderUser.id)" + "\(receiverUser.id)"
                // UUID().uuidString
                let chatRoomObject = ChatRoom(id: id, chatRoomId: chatRoomID, senderId: senderUser.id, receiverId: receiverUser.id, receiverName: receiverUser.username, lastMessage: "", date: Date(), unReadCounter: 0, avatarLink: receiverUser.avatarLink, memberIds: [senderUser.id, receiverUser.id])
                
                
                // TODO Save chat Room in firestore
                ChatRoomManager.shared.saveChatRoomToFirestore(chatRoom: chatRoomObject)
            }
            
            
            
            // lUnKFE1B5jXCb20FkmmnpeKh8Vv1tivMsrcqVKdmPwQHVT4syWm1uEQ2
            // lUnKFE1B5jXCb20FkmmnpeKh8Vv1tivMsrcqVKdmPwQHVT4syWm1uEQ2
            // lUnKFE1B5jXCb20FkmmnpeKh8Vv1tivMsrcqVKdmPwQHVT4syWm1uEQ2
            // lUnKFE1B5jXCb20FkmmnpeKh8Vv1tivMsrcqVKdmPwQHVT4syWm1uEQ2
            // lUnKFE1B5jXCb20FkmmnpeKh8Vv1tivMsrcqVKdmPwQHVT4syWm1uEQ2
            
            
            
        }
        
    }
    
    
    
}
// this fucntion to get the receiver id
func getReceiverID(users : [User]) -> User {
    var allUsers = users
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)
    return allUsers.first!
    
}
