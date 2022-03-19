//
//  LoginViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 07/03/2022.
//

import UIKit
import ProgressHUD



class LoginViewController: UIViewController {
    //MARK:- outlets

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Login"
        
        emailLabel.text = ""
        passwordLabel.text = ""
        
        emailField.delegate = self
        passwordField.delegate = self
        
        hideKeyboardWhenEndEditing()
        
    
    }
 
    @IBAction func forgetPasswordButton(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty else {
          
            return
        }
        UserManager.shared.resetPassword(email: email) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Reset password email has been sent, please check your email")
            }else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    //MARK:- Did tap Login Button

    @IBAction func loginButton(_ sender: Any) {
        // validation
        if let email = emailField.text, !email.isEmpty,
           let password =  passwordField.text, !password.isEmpty {
            // go to login function
            UserManager.shared.login(email: email, password: password) { (error, isEmailVerified) in
               
                if error == nil {
                    if isEmailVerified {
                        print("go to app")
                        self.dismiss(animated: true, completion: nil)
                        self.goToApp()
                        
                    }else {
                        ProgressHUD.showError("Please check your Emial and varify your account to confirm Registration")
                    }
                }else {
                    ProgressHUD.showError(error?.localizedDescription)

                }
                
            }


        }else {
            ProgressHUD.showError("Please fill the Email and password correctly")
        }
    }
   
    

 //MARK:- Did tap in create new account button
    @IBAction func registrationButton(_ sender: Any) {
        let registrationVC = storyboard?.instantiateViewController(identifier: "RegistrationViewController") as! RegistrationViewController
       // registrationVC.modalPresentationStyle = .fullScreen
      //  navigationController?.pushViewController(registrationVC, animated: true)
        present(registrationVC, animated: true, completion: nil)
        
    }
    
    //MARK:- to hide the keyboard when end Editing
  private  func hideKeyboardWhenEndEditing (){
    let gesture =  UITapGestureRecognizer(target: self, action: #selector(hidekeyboard))
    view.addGestureRecognizer(gesture)
   }
    
    @objc func hidekeyboard (){
        view.endEditing(false)
    }
   
    //MARK:- Navigation To App
    func goToApp()  {
        let mainView = storyboard?.instantiateViewController(identifier: "ContainerViewController") as! ContainerViewController
        mainView.modalPresentationStyle = .fullScreen
        present(mainView, animated: true, completion: nil)
    }
    
    
    
}//  loginViewController




//MARK:- textField Delegation
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLabel.text = emailField.hasText ? "Email" : ""
        passwordLabel.text = passwordField.hasText ? "Password" : ""
    }
}
