//
//  ProfileTableViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 12/03/2022.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
  
    var user : User?
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        tableView.tableFooterView = UIView()
        configureUserProfile()
      
    }
    
    func configureUserProfile() {
        if user != nil {
        usernameLabel.text = user?.username
        statusLabel.text = user?.status
            if user?.avatarLink != "" {
                StorageManager.shared.downloadImage(imageUrl: user!.avatarLink) { (image) in
                    guard let image = image else {return}
                    self.profilePictureImageView.image = image
                }
            }
       
        }
        }


// MARK: - TabelView Functions
   
    //this function to hide title for tabelview Section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "colorTabelView")
        return headerView
    }
    // this function to customize the height for section
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            print("start chating")
            guard let currentUser =  User.currentUser else {return}
            let chatId =  startChat(sender: currentUser, receiver: user! )
            
            let MessageController = MSGViewController(chatId: chatId, receiverId: user!.username, receiverName: user!.id)
            navigationController?.pushViewController(MessageController, animated: true )
            
        }
    }
    
    
    
}

    

    

    

