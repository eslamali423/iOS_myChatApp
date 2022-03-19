//
//  UsersTableViewCell.swift
//  myChatApp
//
//  Created by Eslam Ali  on 11/03/2022.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    
    //MARK:- outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        // Configure the view for the selected state
    }
    
    //MARK:- configure and set data to cell
    func configureCell(user : User )  {
        self.usernameLabel.text = user.username
        self.statusLabel.text = user.status
        StorageManager.shared.downloadImage(imageUrl: user.avatarLink) { (image) in
            if user.avatarLink != "" {
                self.profilePictureImageView.image = image
            }else  {
                self.profilePictureImageView.image = UIImage(named: "avatar")!
            }
        }
    }

}
