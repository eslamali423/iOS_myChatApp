//
//  InputBarAccessoryViewDelegate.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//

import Foundation
import InputBarAccessoryView

extension MSGViewController : InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
       print("typing")
      // this for mic or send buttom
        // if true -> no text mic shows up, if false -> textView has text send button shows up
        updateMicButtonStatus(show : text == "" )

    }
    // Did Tap Send Button
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        send(text: text, photo: nil, video: nil, audio: nil, location: nil)
        
        
        inputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
        
    }
    
    
}
