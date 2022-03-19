//
//  StorageManager.swift
//  myChatApp
//
//  Created by Eslam Ali  on 10/03/2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import ProgressHUD

class StorageManager  {
    
    
    static let shared =  StorageManager()
    let storageRefDirectory = "gs://mychatapp-40cf2.appspot.com/"
    
    //MARK:- Upload Images to Firestore
    func uploadImgage(image : UIImage, directory : String, completion : @escaping ( _ downloadedLink : String?)-> Void)  {
        // create folder in firestore
        let storageRef = Storage.storage().reference(forURL: storageRefDirectory).child(directory)
        
        // convert image to data
        guard let imageData =  image.jpegData(compressionQuality: 5.0) else {return}
        
        // put data into firestore and return the downloaded link
        var task : StorageUploadTask!
        task = storageRef.putData(imageData, metadata: nil, completion: { (data, error) in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("Error Uploading Image .....")
                print (error?.localizedDescription)
                
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadUrl =  url , error == nil else  {
                    print (error?.localizedDescription)
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
                
            }
        })
        
        //observe upload persantage
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            // to get the persantage % for uploading progress
            let progress =  snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }// func uploadImage
    
    //MARK:-  Save File (avatar) locally
    func  saveFileLocally(fileData : NSData , fileName : String)  {
        let docUrl = getDocumentURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
        
    }
    
    //MARK:- Download Image
    func downloadImage(imageUrl :  String, completion : @escaping ( _ image : UIImage? )->Void)  {
        let imageFileName = fileNameFromUrl(fileUrl: imageUrl)
        
        if fileExistsInPath(path: imageFileName){
            // ture -> get the image locally
            print("get the image loccallyyyyy")
            if let imageContent = UIImage(contentsOfFile: fileInDocumentDirectory(fileName: imageFileName)){
                completion(imageContent)
            }else{
                print("cant get the image locallyyy")
                completion(UIImage(named: "avatar")!)
            }
        }else  {
            //  get the image form firebase
            if imageUrl != "" {
                let downloadUrl = URL(string: imageUrl)
                let downloadQueue = DispatchQueue (label: "imageDownloadQueue")
                
                downloadQueue.async {
                    let data =  NSData(contentsOf: downloadUrl!)
                    if data != nil {
                        // save the file locally 
                        StorageManager.shared.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    }
                }
            }
            
        }
    }
    
    
    
    //MARK:- Upload Videos to Firestore
    func uploadVideo(video  : NSData, directory : String, completion : @escaping ( _ videoLink : String?)-> Void)  {
      
        // create folder in firestore
        let storageRef = Storage.storage().reference(forURL: storageRefDirectory).child(directory)
        
        // put data into firestore and return the downloaded link
        var task : StorageUploadTask!
        task = storageRef.putData(video as Data, metadata: nil, completion: { (data, error) in
            task.removeAllObservers()
            ProgressHUD.dismiss()
   
            if error != nil {
                print("Error Uploading Video .....")
                print (error?.localizedDescription)
                
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadUrl =  url , error == nil else  {
                    print (error?.localizedDescription)
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
                
            }
        })
        
        //observe upload persantage
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            // to get the persantage % for uploading progress
            let progress =  snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }// func uploadVideo
    
    //MARK:- Download Videw
    func downloadVideo(videoUrl :  String, completion : @escaping ( _ isReadyToPlay : Bool, _ videoFileName : String )->Void)  {
        let videoFileName = fileNameFromUrl(fileUrl: videoUrl) + ".mov"
        
        if fileExistsInPath(path: videoFileName){
           
            completion(true, videoFileName)
            
                
        }else  {
            //  get the image form firebase
            if videoUrl != "" {
                let downloadUrl = URL(string: videoUrl )
                let downloadQueue = DispatchQueue (label: "videoDownloadQueue")
                
                downloadQueue.async {
                    let data =  NSData(contentsOf: downloadUrl!)
                    if data != nil {
                        // save the file locally
                        StorageManager.shared.saveFileLocally(fileData: data!, fileName: videoFileName)
                        DispatchQueue.main.async {
                            completion(true, videoFileName)
                        }
                    }else {
                        print(" no document Found in database ")
                    }
                }
            }
            
        }
    }
    
    //MARK:- Upload Audio to Firestore
    func uploadAudio(AudioFileName  : String, directory : String, completion : @escaping ( _ audioLink : String?)-> Void)  {
      
        // create Audio File Name
        let fileName = AudioFileName + ".m4a"
        
        
        // create folder in firestore
        let storageRef = Storage.storage().reference(forURL: storageRefDirectory).child(directory)
        
        // put data into firestore and return the downloaded link
        if fileExistsInPath(path: fileName) {
            
            if let audioData = NSData(contentsOfFile: fileInDocumentDirectory(fileName: fileName)) {
                
                
                var task : StorageUploadTask!
                task = storageRef.putData(audioData as Data, metadata: nil, completion: { (data, error) in
                    task.removeAllObservers()
                    ProgressHUD.dismiss()
           
                    if error != nil {
                        print("Error Uploading Audio .....")
                        print (error?.localizedDescription)
                        
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        guard let downloadUrl =  url , error == nil else  {
                            print (error?.localizedDescription)
                            completion(nil)
                            return
                        }
                        completion(downloadUrl.absoluteString)
                        
                    }
                })
                
                //observe upload persantage
                task.observe(StorageTaskStatus.progress) { (snapshot) in
                    // to get the persantage % for uploading progress
                    let progress =  snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                    ProgressHUD.showProgress(CGFloat(progress))
                }
            }else  {
                print("Audio Data Not Uploaded Successfully")
            }
            
        }
    }// func uploadAudio
    
    //MARK:- Download Videw
    func downloadAudio(audioUrl :  String, completion : @escaping ( _ audioFileName : String )->Void)  {
        let audioFileName = fileNameFromUrl(fileUrl: audioUrl) + ".m4a"
        
        if fileExistsInPath(path: audioFileName){
           
            completion( audioFileName)
            
                
        }else  {
            //  get the image form firebase
            if audioUrl != "" {
                let downloadUrl = URL(string: audioUrl )
                let downloadQueue = DispatchQueue (label: "audioDownloadQueue")
                
                downloadQueue.async {
                    let data =  NSData(contentsOf: downloadUrl!)
                    if data != nil {
                        // save the file locally
                        StorageManager.shared.saveFileLocally(fileData: data!, fileName: audioFileName)
                        DispatchQueue.main.async {
                            completion(audioFileName)
                        }
                    }else {
                        print(" no document Found in database ")
                    }
                }
            }
            
        }
    }
    
    
    
} // class storageManager


//MARK:- Helper Fucntions
// this fucntion to get file pass (local directory (File Manager))
func getDocumentURL () -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}
// this function to get the file path after add the file name
func fileInDocumentDirectory(fileName : String) -> String {
    return getDocumentURL().appendingPathComponent(fileName).path
}

func fileExistsInPath(path : String) -> Bool {
    return FileManager.default.fileExists(atPath: fileInDocumentDirectory(fileName: path))
}

