//
//  MSGViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 13/03/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import RealmSwift
import Gallery


class MSGViewController: MessagesViewController {
    
    //MARK:- vars
    
    
    var chatId = ""
    var receiverId = ""
    var receiverName = ""
    let refreshController = UIRefreshControl()
   
    let micButton  = InputBarButtonItem()
    
    let currentUser = MKSender(senderId : User.currentID , displayName : User.currentUser!.username)
    var mkMessages : [MKMessage] = []
    var allLocalMessages : Results<LocalMessage>!
    let realm = try! Realm()
    
    var notificationToken : NotificationToken?
    
    var displayingMessageCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    
    var gallery : GalleryController!
    
    var longPressGesture : UILongPressGestureRecognizer!
    
    var  audioFileName :String = ""
    var  audioStartTime : Date = Date()

    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    
    //MARK:- Initializer
    
    init(chatId: String, receiverId : String , receiverName:String) {
        super.init(nibName: nil, bundle: nil)
        
        self.chatId = chatId
        self.receiverId = receiverId
        self.receiverName = receiverName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGestureRecognizer()
        configureMessageCollectionView()
        configureMessageInputBar()
        loadMessages()
        listenForNewMessages()
        listenForReadStatusUpdate()
        self.title = receiverName
       // self.title = "Anonymous"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        configureBackButton()
  
        // Do any additional setup after loading the view.
        
    }
    //MARK:- Configure Back Button in Messages View Controller
    // to do remove Listner
    func configureBackButton(){
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle(" Chats", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        //(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    @objc func didTapBackButton(){
        MessageManager.shared.removeListner()
        ChatRoomManager.shared.clearUnreadCounterWithId(chatRoomId: chatId)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:- Did Tap Attacth Message Button
    
    func didTapAttatchButton()  {
        // to hide the keyboard
        messageInputBar.inputTextView.resignFirstResponder()
        
        let ActionSheet =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Open Camera", style: .default) { (action) in

            self.configureGalleryController(camera: true)        }
        
        let cameraRoll =  UIAlertAction(title: "Share From Camera Roll", style: .default) { (action) in
            self.configureGalleryController(camera: false
            )        }
        
        let location = UIAlertAction(title: "Share Location", style: .default) { (action) in
            
            if let _ = LocationManager.shared.currentLocation {
                self.send(text: nil, photo: nil, video: nil, audio: nil, location: KLOCATION)

            }
        }
        location.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        camera.setValue(UIImage(systemName: "camera"), forKey: "image")
        cameraRoll.setValue(UIImage(systemName: "photo.fill.on.rectangle.fill"), forKey: "image")
        location.setValue(UIImage(systemName: "location"), forKey: "image")

        
        
        ActionSheet.addAction(camera)
        ActionSheet.addAction(cameraRoll)
        ActionSheet.addAction(location)
        ActionSheet.addAction(cancel)
        
        self.present(ActionSheet, animated: true, completion: nil)
        
    }
    

    
    

    
    
    
    
    //MARK:- Conficration for Message Collection View Function
    private func configureMessageCollectionView () {
                messagesCollectionView.messagesDataSource = self
                messagesCollectionView.messageCellDelegate = self
                messagesCollectionView.messagesDisplayDelegate = self
                messagesCollectionView.messagesLayoutDelegate = self
        
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
        
    }
    
    
    //MARK:- configure Input Bar buttons
    private func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.isImagePasteEnabled =  false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
    
        
        
        //        messageInputBar.delegate = self
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "paperclip", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { (item) in
            print("attach button pressed")
            self.didTapAttatchButton()
            
        }
        
        // add items to messageInputBar stalkView
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        
        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
    
        // add gesture recognizer
        micButton.addGestureRecognizer(longPressGesture)
       
        // update mic status
        // true at first because textView doesn't has text (mic shows up)
        updateMicButtonStatus(show : true)

    }
    // Update Mic Button status Function
     func updateMicButtonStatus (show : Bool) {
        if show  /* mic  */{
            
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
            
        } else /* send Button */ {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
        
        
    }
    
    //MARK:- Configure Long Press Gesture For Mic Button
    func configureGestureRecognizer()  {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordAndSend))
    }
    
    @objc func recordAndSend () {
        switch longPressGesture.state {
        case .began:
            // start Recording
            audioFileName  = Date().stringDate()
            audioStartTime = Date()
            AudioManager.shared.startRecording(fileName: audioFileName)
        
        
        
        
        case .ended :
            // stop Recording
            AudioManager.shared.finishRecording()
            if fileExistsInPath(path: audioFileName + ".m4a") {
                let audioDuration = audioStartTime.interval(comp: .second, date: Date())
                
                send(text: nil, photo: nil, video: nil, audio: audioFileName, location: nil, audioDuration: audioDuration)
            }
             
            
            
            // send the audio Message
            print("end and send ")

            
         default:
            print("unknown")
        }
        
    }
    
    //MARK:- Send Message Function
    func send(text : String?, photo : UIImage?, video : Video?, audio : String? , location : String?, audioDuration: Float = 0.0)  {
        
        Outgoing.shared.sendMessage(chatId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentID, receiverId])
        
    }
    
    //MARK:- Load Messages
    func loadMessages()  {
        let pridecate = NSPredicate(format: "chatRoomId = %@", chatId)
        allLocalMessages = realm.objects(LocalMessage.self).filter(pridecate).sorted(byKeyPath: KDATE, ascending: true)
        
        // get old messages first
        if allLocalMessages.isEmpty {
            checkForOldMessages()
        }
        

        // OBserve(Listenr) To Firebase using Notification Token
        notificationToken = allLocalMessages.observe({ (change  : RealmCollectionChange ) in
            switch change {
            case .initial:
                self.insertMKMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
                self.messagesCollectionView.scrollToBottom(animated: false)
  
            case .update(_, _, insertions: let insertions, _):
                for index in insertions {
                    self.insertMKMessage(localMessage: self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: true)
                    self.messagesCollectionView.scrollToBottom(animated: false)
                }
            case .error(let error):
                print("error", error.localizedDescription)
            }
        })
        
        
    }
    
    //MARK:- Set Message Status As Read To The Receiver (Firestore)
    func markMessageAsRead(localMessage : LocalMessage)  {
        if localMessage.senderId != User.currentID {
            MessageManager.shared.updataMessageStatus(message: localMessage, userId: receiverId)
        }
    }
    
    //MARK:- Update Read Status In Messages View Controller
    func updateReadStatus(updatedLocalMessage : LocalMessage)  {
        for index in 0 ..< mkMessages.count {
            let tempMessage = mkMessages[index]
            if updatedLocalMessage.id == tempMessage.messageId {
                mkMessages[index].status = updatedLocalMessage.status
                mkMessages[index].readDate = updatedLocalMessage.readDate
            // save the updated Message locally
                RealmManager.shared.save(updatedLocalMessage)
            }
            if mkMessages[index].status == KREAD {
                self.messagesCollectionView.reloadData()
            }
            
        }
    }
    
    func listenForReadStatusUpdate()  {
        MessageManager.shared.listenForReadStatus(documentId: User.currentID, collectionId: chatId) { (updatedLocalMessage) in
            self.updateReadStatus(updatedLocalMessage: updatedLocalMessage)
        }
    }
    
    
    // insert one Message
    private func insertMKMessage(localMessage : LocalMessage){
        self.markMessageAsRead(localMessage: localMessage)
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage: localMessage)
        mkMessages.append(mkMessage)
        displayingMessageCount += 1
    }
    
    // this for insert message at the index 0 everytime
    private func insertOlderMKMessage(localMessage : LocalMessage){
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage: localMessage)
        mkMessages.insert(mkMessage, at: 0)
        displayingMessageCount += 1
    }
    
    
    // insert All Message
    private func insertMKMessages(){
        // this for pull more messages refresh controller
        maxMessageNumber = allLocalMessages.count - displayingMessageCount
        minMessageNumber = maxMessageNumber - KMESSAGENUMBER
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in minMessageNumber ..< maxMessageNumber {
            insertMKMessage(localMessage: allLocalMessages[i])
        }

    }
    
    private func insertMoreMKMessages(){
        // this for pull more messages refresh controller
        maxMessageNumber = minMessageNumber - 1
        minMessageNumber = maxMessageNumber - KMESSAGENUMBER
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in (minMessageNumber ... maxMessageNumber).reversed() {
            insertOlderMKMessage(localMessage: allLocalMessages[i])
        }
    }
    
    // Scroll Delegate Function (Refresh Controll) for Pull To Load More Messages
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing {
            if displayingMessageCount < allLocalMessages.count {
                self.insertMoreMKMessages()
                messagesCollectionView.reloadDataAndKeepOffset()
            }
        }
        refreshController.endRefreshing()
    }
    
    
    //check for Old Messages if locall messages is empty
    func checkForOldMessages() {
        MessageManager.shared.checkForOldMessages(documentId: User.currentID, collectionId: chatId)
    }
    
    // listen to new message
    private func listenForNewMessages () {
        MessageManager.shared.listenForNewMessage(documentId: User.currentID, collectionId: chatId, lastMesageDate: lastMessageDate())
    }
    
    // get last message Data function to use it in ListenForNewMessages()
    private func lastMessageDate()->Date {
        let lastMessageDate = allLocalMessages.last?.date ?? Date()
        
        return Calendar.current.date(byAdding: .second, value: 1 ,to: lastMessageDate) ?? lastMessageDate
    }
    
    //MARK:- Callery Function
    
    private func configureGalleryController(camera : Bool) {
        gallery = GalleryController()
        gallery.delegate = self
        Config.tabsToShow =  camera ? [.cameraTab] : [.imageTab , .videoTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        Config.VideoEditor.maximumDuration = 30
        
        self.present(gallery, animated: true, completion: nil)
        
    }
    
    

}

extension MSGViewController : GalleryControllerDelegate {
    
    // if User Picked Image
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            images.first?.resolve(completion: { (image) in
                self.send(text: nil, photo: image, video: nil, audio: nil, location: nil)

            })
        }

        controller.dismiss(animated: true, completion: nil)
    }
    // if User Picked Video
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        self.send(text: nil, photo: nil, video: video, audio: nil, location: nil)

        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
       
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

