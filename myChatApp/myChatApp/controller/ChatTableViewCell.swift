//
//  ChatTableViewCell.swift
//  myChatApp
//
//  Created by Eslam Ali  on 12/03/2022.
//

import UIKit
import MessageKit

class ChatTableViewCell: UITableViewCell {

    //MARK:- Outlets


    @IBOutlet weak var unReadLabel: UILabel!
    @IBOutlet weak var unReadView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var chatPictureImageView: UIImageView!
   

    //MARK:- <> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //circle image and the unread message view
        chatPictureImageView.layer.cornerRadius = chatPictureImageView.frame.width / 2
        unReadView.layer.cornerRadius = unReadView.frame.width / 2

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK:- Configure ChatRoom
    func configure(chatRoom : ChatRoom)  {
        self.lastMessageLabel.text =  chatRoom.lastMessage
        self.usernameLabel.text =  chatRoom.receiverName
        self.dateLabel.text = timeElapsed(date: chatRoom.date ?? Date())
            //"\(MessageKitDateFormatter.shared.string(from: chatRoom.date!))"
      
        if chatRoom.unReadCounter != 0 {
            self.unReadView.isHidden = false
            self.unReadLabel.text = "\(chatRoom.unReadCounter)"
        }else {
            self.unReadView.isHidden = true
        }
        
        if chatRoom.avatarLink != "" {
            StorageManager.shared.downloadImage(imageUrl: chatRoom.avatarLink) { (image) in
                self.chatPictureImageView.image = image
            }
            }else {
                self.chatPictureImageView.image =  UIImage(named: "avatar")
                
        }
   
    }
}


