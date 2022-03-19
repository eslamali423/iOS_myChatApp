//
//  SceneDelegate.swift
//  myChatApp
//
//  Created by Eslam Ali  on 07/03/2022.
//

import UIKit
import Firebase


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var authListner : AuthStateDidChangeListenerHandle?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        handelAuthentcation_2()
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        LocationManager.shared.startUpdating()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        LocationManager.shared.stopUpdating()
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        LocationManager.shared.stopUpdating()
    }
    
    
    //MARK:- Handel Auto Login
    private func handelAuthentcation(){
        
        if Auth.auth().currentUser == nil {
            //   self.tabBarController?.tabBar.isHidden = true
            // set it on a main Queue
            DispatchQueue.main.async {
                self.goToLoginViewController()
            }
            
        }
    }
    
    private func handelAuthentcation_2(){
        authListner = Auth.auth().addStateDidChangeListener({ (auth, user) in
            Auth.auth().removeStateDidChangeListener(self.authListner!)
            if user == nil && UserDefaults.standard.object(forKey: KCURRENTUSER) == nil {
                DispatchQueue.main.async {
                    self.goToLoginViewController()
                    
                }
            }
        })
    }
    
    private func goToApp () {
        let tapBarVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(identifier: "ContainerViewController") as! ContainerViewController
        tapBarVC.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = tapBarVC
        self.window?.makeKeyAndVisible()
        
        
        
        
    }
    
    
    
    
    //MARK:- Navigation To Login View Controller
    func goToLoginViewController()  {
        let loginVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
        
        
        
        //  present(loginVC, animated: false, completion: nil)
        
        
        
        
    }
    
    
}

