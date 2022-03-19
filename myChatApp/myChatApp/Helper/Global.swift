//
//  GlobalFucntions.swift
//  myChatApp
//
//  Created by Eslam Ali  on 10/03/2022.
//

import Foundation
import UIKit
import AVFoundation
import Firebase


//MARK:- Firebase Referance

enum FirebaseReferanceKey :String {
    case Users
    case Messages
    case Chats
}


func firestoreReferance(_ ref : FirebaseReferanceKey) -> CollectionReference {
    return Firestore.firestore().collection(ref.rawValue)
}


func fileNameFromUrl(fileUrl : String) -> String {
    let name = fileUrl.components(separatedBy: "_").last
    let name1 =  name?.components(separatedBy: "?").first
    let name2 = name1?.components(separatedBy: ".").first
    return name2!
}

//MARK:- Video Thubnail
// this function create Thumbnail Image for Videos
func videoThumbnail (videoUrl : URL) ->  UIImage{
    do {
        let asset =  AVURLAsset(url: videoUrl, options: nil)
        let imageGenerator = AVAssetImageGenerator(asset : asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let cgImage  = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail =  UIImage(cgImage: cgImage)
        return thumbnail
    }catch let error {
        print("Error Generating Thumpnail" , error.localizedDescription)
    }

return UIImage(named: "avatar")!
}

//MARK:- Calculate Date For Message
func timeElapsed (date : Date) ->  String {
    let seconds =  Date().timeIntervalSince(date)
    var elapsed = ""
    if seconds < 60 {
        elapsed = "Just Now"
    } else if seconds < 60 * 60 {
        let minutes  =  Int(seconds/60)
        let minText = minutes > 1 ? "minutes" : "minute"
        elapsed = "\(minutes) \(minText)"
    } else if seconds < 24 * 60 * 60 {
        let hour  =  Int(seconds/(60 * 60))
        let hourText = hour > 1 ? "hours" : "hour"
        elapsed = "\(hour) \(hourText)"
    } else  {
        elapsed = "\(date.longDate())"
    }
    return elapsed 
}


//MARK:- Date Extension
extension Date {
    
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func interval(comp : Calendar.Component, date : Date) -> Float {
        let currentCalendar =  Calendar.current
        
        guard let end =  currentCalendar.ordinality(of: comp, in: .era, for: date) else {return 0}
        guard let start =  currentCalendar.ordinality(of: comp, in: .era, for: self) else {return 0}

        return Float(end - start)
        
    }
    
    
}




