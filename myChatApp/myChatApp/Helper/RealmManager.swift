//
//  RealmManager.swift
//  myChatApp
//
//  Created by Eslam Ali  on 14/03/2022.
//

import Foundation
import RealmSwift

// this class used for save the message locally

class RealmManager {
    static let shared = RealmManager()
    // we can read and write through realm var
    let realm =  try! Realm()
    
   private init () {}

    func save <T : Object> (_ object : T){
        do {
           try! realm.write {
            realm.add(object, update: .all)
            }
        } catch {
            print("Error Saving Data", error.localizedDescription )
        }
    }
    
       
        
    }


