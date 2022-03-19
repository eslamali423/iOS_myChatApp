//
//  ChatsTableViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 12/03/2022.
//

import UIKit
import Firebase

class ChatsTableViewController: UITableViewController {
    
    //MARK:- vars
  
    // requested chatrooms to all chat Rooms 
    
    
    var allChatRooms : [ChatRoom] = []
    var filterdChatRooms : [ChatRoom] = []
    let searchController = UISearchController(searchResultsController: nil)
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        title = "Chats"
       //  handelAuthentcation()
        
        
        //configure searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Chats"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        downloadAllChatRooms()
    }
    
    // MARK: - Table Function
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filterdChatRooms.count : allChatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        /*   let chatRoom =  ChatRoom(id: "12", chatRoomId: "111", senderId: "11", receiverId: "11", receiverName: "Ahmed Ashraf", lastMessage: "this is a vaery long message has a lot of words", date: Date(), unReadCounter: 7, avatarLink: "")
         cell.configure(chatRoom: chatRoom)
         */
        
        let data = searchController.isActive ?  filterdChatRooms[indexPath.row] : allChatRooms[indexPath.row]
        cell.configure(chatRoom: data)
        return cell
    }
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // This 2 Fucntions for Deleting Chat Room Form The TabelView
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatRoom = searchController.isActive ? filterdChatRooms[indexPath.row] : allChatRooms[indexPath.row]
            ChatRoomManager.shared.deleteChatRoom(chatRoom)
            
            searchController.isActive ? self.filterdChatRooms.remove(at: indexPath.row) : allChatRooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
  
        }
    }
    // Did Tap On a Chat Room
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomObject = searchController.isActive ? filterdChatRooms[indexPath.row] : allChatRooms[indexPath.row]
        goToMessageController(chatRoom: chatRoomObject)
        
    }
    
    //MARK:- Navigation To Message Controller
    func goToMessageController(chatRoom : ChatRoom) {
       // check if all  both     users has the chatroom in his app
        
        restartChat(chatRoomId: chatRoom.chatRoomId, memberIds: chatRoom.memberIds)
        
        
        let MessageController = MSGViewController(chatId: chatRoom.chatRoomId, receiverId: chatRoom.receiverId, receiverName: chatRoom.receiverName)
        navigationController?.pushViewController(MessageController, animated: true)
        
    }
    
    //MARK:- Did Tap Add Chat Bar Button
    @IBAction func AddChatButton(_ sender: UIBarButtonItem) {
//        let usersVC =  storyboard?.instantiateViewController(identifier: "UsersViewController") as! UsersViewController
//        navigationController?.pushViewController(usersVC, animated: true)
        
        tabBarController?.selectedIndex = 1

    }
    
    
//    //MARK:- Handel Auto Login
//    private func handelAuthentcation(){
//        
//        
//        if Auth.auth().currentUser == nil && UserDefaults.standard.object(forKey: KCURRENTUSER) == nil {
//            goToLoginViewController()
//        }
//    }
//    func goToLoginViewController()  {
//        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
//        loginVC.modalPresentationStyle = .fullScreen
//        present(loginVC, animated: false, completion: nil)
//    }
    
    
    //MARK:- Download All ChatRooms
    func downloadAllChatRooms()  {
        ChatRoomManager.shared.donwloadChatRooms { (allChatRooms) in
            self.allChatRooms = allChatRooms
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
 

}


//MARK:- Extension for customize searchbar Delegate
extension ChatsTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterdChatRooms = allChatRooms.filter({ (chatRoom) -> Bool in
            return chatRoom.receiverName.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        self.tableView.reloadData()
        
    }
    
    
}
