//
//  MessageManager.swift
//  myChatApp
//
//  Created by Eslam Ali  on 14/03/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class MessageManager{
    static let shared  = MessageManager()
    var newMessageListner : ListenerRegistration!
    var updateMessageListner : ListenerRegistration!
    
    
    private init () {}
    
    
    //MARK:- Add Message To FireStore
    func addMessage( message : LocalMessage , memberId : String)  {
        do {
            try firestoreReferance(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from : message)
        } catch{
            print("error saveing data to firestore")
        }
    }
    
    //MARK:- Chack For Old Messages and download it form Firebase
    
    func checkForOldMessages(documentId : String , collectionId : String)  {
        firestoreReferance(.Messages).document(documentId).collection(collectionId).getDocuments { (querySnapshot, error) in
            guard let documents  =  querySnapshot?.documents else  {return}
            
            var oldMessages =  documents.compactMap { (querySnapshot) -> LocalMessage? in
                return try? querySnapshot.data(as: LocalMessage.self)
            }
            oldMessages.sort(by: {$0.date < $1.date})
            
            for message in oldMessages {
                RealmManager.shared.save(message)
            }
            
            
        }
    }
    
    //MARK:-  Listen To New Message and Save It Into Realm Database
    func  listenForNewMessage(documentId : String, collectionId : String, lastMesageDate : Date)  {
        newMessageListner = firestoreReferance(.Messages).document(documentId).collection(collectionId).whereField( KDATE, isGreaterThan: lastMesageDate).addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            for change in snapshot.documentChanges {
                if change.type == .added {
                    let result = Result{
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject {
                            if message.senderId != User.currentID {  // because we don't need to listen sent messages
                                RealmManager.shared.save(message)
                            }
                        }
                        
                    case .failure(let error) :
                        print("Error" , error.localizedDescription)
                        
                    }
                }
            }
        })
        
    }
    
    //MARK:- Update Message Status [Sent, Read] in Firestore
    func updataMessageStatus(message: LocalMessage, userId : String) {
        let values =  [KSTATUS: KREAD, KREADDATE : Date()] as [String : Any]
        firestoreReferance(.Messages).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
        
    }
    
    //MARK:- Listen For Any Changes For Message Status  [Sent, Read]
    func listenForReadStatus(documentId : String, collectionId : String, completion: @escaping (_ updatedMessage : LocalMessage)->Void)  {
        updateMessageListner =    firestoreReferance(.Messages).document(documentId).collection(collectionId).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            for change in snapshot.documentChanges {
                if change.type == .modified {
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject {
                            completion(message)
                        }
                        
                        
                    case .failure(let error):
                        print("Something went Wrong : " , error.localizedDescription)
                        
                    }
                    
                }
            }
        }
        
    }
    
    
    
    
    func removeListner()  {
        self.newMessageListner.remove()
        self.updateMessageListner.remove()
    }
    
    
}
