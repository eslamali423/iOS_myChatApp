//
//  ChatsViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 07/03/2022.
//

import UIKit
import FirebaseAuth

class ChatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // to set navigartion controller item without set title for the tabBar item
                navigationController?.navigationBar.topItem?.title = "Chats"

        title = "Chats"
        handelAuthentcation()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func signoutButton(_ sender: Any) {
        UserManager.shared.signOut { (isSuccess) in
            if isSuccess == nil{
                print("done")
                self.dismiss(animated: true, completion: nil)
                goToLoginViewController()
            } else  {
                print("error sign out")
            }
        }
    }
    
    
    private func handelAuthentcation(){
    
  //      let loggedIn = UserDefaults.standard.bool(forKey: "currentUser")
        if Auth.auth().currentUser == nil {
         //   self.tabBarController?.tabBar.isHidden = true

           goToLoginViewController()
       //     navigationController?.pushViewController(loginVC, animated: false)
        }
    }
    func goToLoginViewController()  {
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: false, completion: nil)
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
