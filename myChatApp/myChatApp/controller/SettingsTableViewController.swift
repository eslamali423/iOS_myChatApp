//
//  SettingsTableViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 09/03/2022.
//

import UIKit
import SafariServices

class SettingsTableViewController: UITableViewController {
    
    //MARK:- outlets
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to set navigartion controller item without set title for the tabBar item
      //  navigationController?.navigationBar.topItem?.title = "Settings"
        // to hide Empty cells in the tableview
        tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = false
        getUserInfo()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        //circle image
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        
        
       // getUserInfo()
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        // get user data form userdefults
//        self.tabBarController?.tabBar.isHidden = false
//
//        getUserInfo()
//        
//        
//    }
    
    // MARK: - Table view Functions
    
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
        if indexPath.row == 0 , indexPath.section == 0 {
            let EditProfile = storyboard?.instantiateViewController(identifier: "EditProfileTableViewController") as! EditProfileTableViewController
            navigationController?.pushViewController(EditProfile, animated: true)
        }
    }
    
    // MARK: - Did Tap Tell A Friends Button
    @IBAction func tellFriendButton(_ sender: Any) {
    }
    
    
    //MARK:- Did Tap Terms And Conddition Button
    @IBAction func termsConditionButton(_ sender: Any) {
        // https://www.whatsapp.com/legal/terms-of-service
        guard let url = URL(string: "https://www.whatsapp.com/legal/terms-of-service") else {
            return
        }
        let safaryVC = SFSafariViewController(url: url)
        present(safaryVC, animated: true, completion: nil)
        
    }
    
    // MARK:-  Did Tap SignOut Button
    @IBAction func signOutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to Sign Out", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.destructive, handler: { (action) in
            print("logedout")
            UserManager.shared.signOut { (error) in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                    self.goToLoginViewController()
                }else {
                    print(error?.localizedDescription)
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- Get User Information from User Defults
    func getUserInfo()  {
        guard let user = User.currentUser else {
            print ("no data found")
            return
        }
        usernameLabel.text = user.username
        statusLabel.text = user.status
        
            if user.avatarLink != "" {
         // download user profile image locally
            StorageManager.shared.downloadImage(imageUrl: user.avatarLink) { (image) in
                self.profilePictureImageView.image = image
            }
     
        }
 
    }

    //MARK:- Present Login View Controller Fucntion
    func goToLoginViewController()  {
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(loginVC, animated: false, completion: nil)
        }
    }
    
    
    
    
    
    
}
