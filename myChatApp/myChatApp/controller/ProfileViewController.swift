//
//  ProfileViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 09/03/2022.
//

import UIKit

class ProfileViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red    }
    
    @IBAction func signoutbutton(_ sender: Any) {
        UserManager.shared.signOut { (isSucceed) in
            if isSucceed {
                print("success to signout ")
                self.dismiss(animated: true, completion: nil)
                
            }else {
                print("error to sign out")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
