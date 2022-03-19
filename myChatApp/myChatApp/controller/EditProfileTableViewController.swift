//
//  EditProfileTableViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 09/03/2022.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var profilepictureImageView: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var statusField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        //circle image
        profilepictureImageView.layer.cornerRadius = profilepictureImageView.frame.width / 2 
        
        getUserInfo()
        hideKeyboardWhenEndEditing ()
        
        //        customize image picker controller
        //        imagePicker.allowsEditing =  true
        //        imagePicker.sourceType = .photoLibrary
        //        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        
        // set navigation controller save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton))
        
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //to hide the tabPar form this controller View
        self.tabBarController?.tabBar.isHidden = true
        // to hide Empty cells in the tableview
        tableView.tableFooterView = UIView()
        
    }
    
    // MARK: - Table Functions
    // hide section titles
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView ()
        headerView.backgroundColor = UIColor(named: "colorTabelView")
        return headerView
    }
    // height for section
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 20
    }
    
    //MARK:- Did tap Edit Profile Button
    @IBAction func editProfileButton(_ sender: Any) {
        
        // open camera
        let actionAlert =  UIAlertController(title: "change Profile Picture", message: "", preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (handler) in
            
            self.photoFromCamera()
            
            
        }))
        
        // open camera roll
        actionAlert.addAction(UIAlertAction(title: "Choose From Camera Roll", style: .default, handler: { (handler) in
            
            
            self.photoFromLibrary()
            
            
        }))
        // to cancel
        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (handler) in
            return
        }))
        
        
        
        self.present(actionAlert, animated: true, completion: nil)
        
        
        
        
        //        let galleryController =  GalleryController()
        //        galleryController.delegate = self
        //        Config.tabsToShow = [.imageTab, .cameraTab]
        //        Config.Camera.imageLimit = 1
        //        Config.initialTab = .imageTab
        //        self.present(galleryController, animated: true, completion: nil)
    }
    
    
    //MARK:- choose photo form libraby and camera
    // photo from Libraray
    func photoFromLibrary() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //photo form Camera
    func  photoFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        
        alertVC.addAction(okAction)
        present( alertVC, animated: true, completion: nil)
    }
    
    
    //MARK:- Did tap Save Button
    @objc func saveButton () {
        if let username = usernameField.text , !username.isEmpty,
           let status = statusField.text, !status.isEmpty{
            guard var user =  User.currentUser else {
                return
            }
            
                user.username = username
                user.status = status
                saveUserLocally(user)
                UserManager.shared.saveUserToFirestore(user: user)
                navigationController?.popViewController(animated: true)
                
            
        }
    }
    

    
    //MARK:- Get user information form object (current user)
    private func getUserInfo(){
       
        guard let user = User.currentUser else {
            return
        }
        
            usernameField.text = user.username
            statusField.text = user.status
            if user.avatarLink != "" {
                // get the image form firebase
                StorageManager.shared.downloadImage(imageUrl: user.avatarLink) { (image) in
                    self.profilepictureImageView.image = image
                
                
            }
        }
    }
    
  
    
    //MARK:- to hide the keyboard when end Editing
    private  func hideKeyboardWhenEndEditing (){
        let gesture =  UITapGestureRecognizer(target: self, action: #selector(hidekeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func hidekeyboard (){
        view.endEditing(false)
        
    }
}

//MARK:- Extension for Image Picker Controller
extension EditProfileTableViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let  pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            profilepictureImageView.image = pickedImage
            // upload image to firestore and get the link
            self.uploadImage(image: pickedImage)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // upload image function
    func uploadImage (image : UIImage){
        let directory = "Avatars/" + "_\(User.currentID)" + ".jpg"
        
        StorageManager.shared.uploadImgage(image: image, directory: directory) { (downloadUrl) in
            guard let downloadUrl = downloadUrl else  {
                print("cant get the link")
                return
            }
            guard var user =  User.currentUser else {return}
       
                user.avatarLink = downloadUrl
                saveUserLocally(user)
                UserManager.shared.saveUserToFirestore(user: user)
                
            
            // Save Image locally
            let imageData = image.jpegData(compressionQuality: 0.5)! as NSData
            StorageManager.shared.saveFileLocally(fileData: imageData, fileName: User.currentID)
        }
        
        
    }
    
    
    
}


//extension EditProfileTableViewController : GalleryControllerDelegate {
//    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
//
//        if images.count == 1 {
//            images.first?.resolve(completion: { (avatarImage) in
//                if avatarImage != nil {
//
//                    self.profilepictureImageView.image = avatarImage
//                    // upload to firestore and user defulats
//                }else  {
//                    ProgressHUD.showError("Could not select Image  ")
//                }
//            })
//        }
//
//
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func galleryControllerDidCancel(_ controller: GalleryController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//
//}
