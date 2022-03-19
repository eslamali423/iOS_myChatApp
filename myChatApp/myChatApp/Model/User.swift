//
//  User.swift
//  myChatApp
//
//  Created by Eslam Ali  on 08/03/2022.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase


struct User : Codable, Equatable {
    var id = ""
    var username : String
    var email : String
    var pushID = ""
    var avatarLink = ""
    var status : String
    
    static var currentID :String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser : User? {
        if Auth.auth().currentUser != nil {  
            if let data =  UserDefaults.standard.data(forKey: KCURRENTUSER)  {
                do {
                    let userObject = try JSONDecoder().decode(User.self, from: data)
                    return userObject
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    
}

func == (lhs : User, rhs : User) -> Bool{
    lhs.id == rhs.id
}


func saveUserLocally(_ user : User) {
    do{
        let data = try  JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: KCURRENTUSER)
        
    }catch {
        print(error.localizedDescription)
    }
}
