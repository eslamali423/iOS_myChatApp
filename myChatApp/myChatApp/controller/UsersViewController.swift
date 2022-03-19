//
//  UsersViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 11/03/2022.
//

import UIKit

class UsersViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:- outlets
    @IBOutlet weak var tabelView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var users = [User]()
    var filterdUser = [User]()
    let refreshControl =  UIRefreshControl()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.refreshControl = self.refreshControl
        // to hide Empty cells in the tableview
        tabelView.tableFooterView = UIView()
    
        //configure searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        //download users call
        downloadUsers()
              
    }
    
    //MARK:- Table Fucntions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filterdUser.count : users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabelView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UsersTableViewCell
        let userData =  searchController.isActive ? filterdUser[indexPath.row] : users[indexPath.row]
        cell.configureCell(user: userData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    // to hide the section title
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(named: "colorTabelView")
        return view
    }
    // Did tap on user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = searchController.isActive ? filterdUser[indexPath.row] : users[indexPath.row]
        goToUserProfile(user: user)
    }
    

    // refresh controll function
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl.isRefreshing {
            self.downloadUsers()
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK:- send user data to profile View controller
    func goToUserProfile( user : User) {
        let profileViewController =   storyboard?.instantiateViewController(identifier: "ProfileTableViewController") as! ProfileTableViewController
        profileViewController.user = user
        profileViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(profileViewController, animated: true)
        
        
    }
    
    
    //MARK:- donwload users form firestore
    private func downloadUsers () {
        UserManager.shared.downloadAllUsersFormFirestore { firestoreaAllUsers in
            self.users = firestoreaAllUsers
            DispatchQueue.main.async {
                self.tabelView.reloadData()
            }
            
        }
    }
}

//MARK:- Extension for customize searchbar Delegate
extension UsersViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterdUser = users.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        self.tabelView.reloadData()
        
    }
    
    
}
