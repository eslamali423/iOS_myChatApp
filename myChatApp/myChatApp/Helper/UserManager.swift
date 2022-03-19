//
//  UserManager.swift
//  myChatApp
//
//  Created by Eslam Ali  on 08/03/2022.
//

import Foundation
import Firebase

class UserManager {
    static let shared =  UserManager()
    
    private init () {}
    
//MARK:- Registration Function
    
    public func canCreateNewUser ( email: String, password:String ,complition: (Bool) -> Void){
        
        complition(true)
    }
    //MARK:- registration function with email and password
    func registration(email : String, password :  String, completion: @escaping (_ error : Error?)-> Void )  {
        Auth.auth().createUser(withEmail: email, password: password) { (results, error) in
         
            completion(error)
            
            if error == nil {
            results?.user.sendEmailVerification(completion: { (error) in
                print(error?.localizedDescription)
            
            })
            
            if results?.user != nil {
                let user =  User(id: results!.user.uid, username: email, email: email, pushID: "", avatarLink: "", status: "hey i'm using this chat App ")
                self.saveUserToFirestore(user: user)
                saveUserLocally(user)
            }
            
             
        }
    }
    }

    
    //MARK:- login function with email and password
    func login(email:String, password:String, completion: @escaping (_ error: Error?, _ isEmailVerified : Bool )->Void ) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error == nil && authResult!.user.isEmailVerified  {
            completion(error,true)
                self.downloadUserFormFirestore(userID: authResult!.user.uid)

            }else {
                print("something went worng by login ")
                   print(error?.localizedDescription)
            completion(error,false)
            }
        }
    }
    
    //MARK:- uploade user data to firestore database after registration statment
    func saveUserToFirestore(user: User)  {
        do {
            try  firestoreReferance(.Users).document(user.id).setData(from: user)

        }catch {
            print("Error Login" , error.localizedDescription)
        }
    }
    
    
    //MARK:- download user data form firestore database after login statment
    func downloadUserFormFirestore(userID : String)  {
        firestoreReferance(.Users).document(userID).getDocument { (documentResult, error) in
            guard let document = documentResult else {
                print("no data Found")
                print(error?.localizedDescription)
                return
            }
            
            let result = Result {
                try document.data(as: User.self)
            }
            
            switch result {
            
            case .success(let userObject):
                if let user =  userObject {
                    saveUserLocally(user)
                }else  {
                    print("User data not found")
                }
            case .failure(let error):
                print(error)
            }
        
           
        }
    }
    
    //MARK:- Reset password
    func resetPassword(email : String, completion : @escaping (_ error : Error?)->Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    //MARK:- Did Tap Logout Button

    public func signOut (completion : @escaping (_ error : Error?) -> Void){
            do{
                try Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: KCURRENTUSER)
                UserDefaults.standard.synchronize()
                

                completion(nil)
                print("data remove form userdefualts ")
            }
            catch let error as NSError {
                    completion(error)
                print("Error SignOut" , error.localizedDescription)
                }
            }
            
 
    
    
    //MARK:- Download Users Using Ids
    func downloadAllUsersFromFirestireUsingIds( _ memberIds : [String], completion : @escaping (_ allUsers : [User])->Void)  {
        var count = 0
        var usersArray : [User] = []
        
        for userId in memberIds {
            firestoreReferance(.Users).document(userId).getDocument { (allUsersSnapshot, error) in
                guard let document = allUsersSnapshot else {
                    return
                }
                let user = try? document.data(as: User.self)
                usersArray.append(user!)
                count += 1
                
                if count == memberIds.count {
                    completion(usersArray)
                }
                
            }
        }
    }
    
    //MARK:- Download All Users form Firestore to explore viewController
    func downloadAllUsersFormFirestore(completion : @escaping ( _ allUsers : [User]) -> Void ) {
        var users : [User] = []
        firestoreReferance(.Users).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents , error == nil else {
                print ("no data found in download all users function")
                return
            }
            // to convert the data form firestore to any codable structure (User)
            let allUsers = documents.compactMap { (snapshot) -> User? in
                return try? snapshot.data(as: User.self)
            }
            for user in allUsers {
               
                if User.currentID != user.id {
                    users.append(user)
                    
                }
            }
        completion(users)
        }
    }
    
    
    
}
