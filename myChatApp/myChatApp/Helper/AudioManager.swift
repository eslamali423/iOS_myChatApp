//
//  AudioManager.swift
//  myChatApp
//
//  Created by Eslam Ali  on 17/03/2022.
//

import Foundation
import AVFoundation

class AudioManager: NSObject, AVAudioRecorderDelegate {
    
    
    static let shared = AudioManager()
    
    var recordingSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    var isAudioRecordingGranted : Bool!
    
   private override init() {
        super.init()
    checkForRecordPermission()
    }
    
    func checkForRecordPermission()  {
        
        switch AVAudioSession.sharedInstance().recordPermission {
        
        case .granted :
            isAudioRecordingGranted = true
        case .denied :
            isAudioRecordingGranted = false
        case .undetermined :
            AVAudioSession.sharedInstance().requestRecordPermission { (isAllawed) in
                self.isAudioRecordingGranted = isAllawed
            }
        default :
            break
        
        }
    }
    
    func setupRecorder()  {
        if isAudioRecordingGranted {
            recordingSession = AVAudioSession.sharedInstance()
            do {
                try recordingSession.setCategory(.playAndRecord, mode : .default)
                try recordingSession.setActive(true)
            }catch{
                print("Error Setting up Auido recording session", error.localizedDescription)
            }
        }
    }
    
    func startRecording(fileName : String)   {
        let audioFileName = getDocumentURL().appendingPathComponent(fileName + ".m4a", isDirectory: false)
        // this settings dic form the internet
        let settings = [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey : 1,
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
        
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings )
            audioRecorder.delegate = self
            audioRecorder.record()
        }catch{
            print("error Recording", error.localizedDescription)
            finishRecording()
        }
    }
    
    func finishRecording()  {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder =  nil
        }
    }
    
    
    
}
