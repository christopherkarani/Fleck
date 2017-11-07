//
//  ConversationsController.swift
//  Fleck
//
//  Created by macuser1 on 23/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

protocol ConversationsControllerDelegate: class {
    func setupNavigationBar(withUser user: LocalUser)
    func fetchUserSetupNavigationBar()
    func showChatController(forUser user: LocalUser)
    
}

class ConversationsController: UITableViewController, ConversationsControllerDelegate {
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var cellID : String = "CellID"
    var timer : Timer?
    var nameLabel : UILabel?
    var profileImageView: UIImageView?
    let layout = UICollectionViewFlowLayout()
    var chatController : ChatController?
    var newMessageController : NewMessageController?
    var loginController : LoginViewController?
    var isLoggedIn = false
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        checkIfUserIsLoggedIn()
        setupNavigationItems()
        observeUserMessages()
  
    }
    
    func setupTableView() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func observeUserMessages() {
        let uid = FDNodeRef.currentUserUID
        let ref = FDNodeRef.shared.userMessagesNode().child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let userID = snapshot.key
            FDNodeRef.shared.userMessagesNode().child(uid).child(userID).observe(.childAdded, with: { (snapshot) in
                let messageID = snapshot.key
                self.fetchMessage(withMessageID: messageID)
            })
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptToReloadTable()
        }
    }

    @objc func handleReload() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.timeStamp! > message2.timeStamp!
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func attemptToReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    
    private func fetchMessage(withMessageID messageID: String) {
        let messagesReferance = FDNodeRef.shared.messagesNode(toChild: messageID)
        messagesReferance.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)                //self.messages.append(message)
                if let chatPartnerID = message.chatPartnerID() {
                    self.messagesDictionary[chatPartnerID] = message
                }
                self.attemptToReloadTable()
            }
        })
    }
    
    //MARK: VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isLoggedIn == true {
            observeUserMessages()
        } else {
            checkIfUserIsLoggedIn()
        }
    }
    
    //MARK: USER LOGGED IN CHECK
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            isLoggedIn = false
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            isLoggedIn = true
            fetchUserSetupNavigationBar()
        }
    }
    func fetchUserSetupNavigationBar() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = FDNodeRef.shared.userNode(toChild: uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var user = LocalUser()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageURL = dictionary["profileImageUrl"] as? String
                self.setupNavigationBar(withUser: user)
            }
        })
    }
    
    //MARK: Setup NavigationBar(withUser:)
    func setupNavigationBar(withUser user: LocalUser) {
        //clean up before reloading
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        
        guard let profileImageURLString = user.profileImageURL else {
            print("Something went wrong while setting up Navigation Bar")
            return
        }
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.translatesAutoresizingMaskIntoConstraints = false

   
        profileImageView = UIImageView()
        profileImageView?.layer.cornerRadius = 20
        profileImageView?.clipsToBounds = true
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.contentMode = .scaleAspectFill
        profileImageView?.loadImageUsingCache(withURLString: profileImageURLString)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        
        nameLabel = UILabel()
        nameLabel?.text = user.name
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false

        
        containerView.addSubview(profileImageView!)
        containerView.addSubview(nameLabel!)

        // nameLabel Constrainsts
        nameLabel?.leftAnchor.constraint(equalTo: profileImageView!.rightAnchor, constant: 8).isActive = true
        nameLabel?.centerYAnchor.constraint(equalTo: profileImageView!.centerYAnchor).isActive = true
        nameLabel?.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel?.heightAnchor.constraint(equalTo: profileImageView!.heightAnchor).isActive = true

        //x,y,width,height
        profileImageView?.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView?.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // containerView Constraints
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
  
    }
    
    func showChatController(forUser user: LocalUser) {
        let layout = UICollectionViewFlowLayout()
        chatController = ChatController(collectionViewLayout: layout)
        chatController?.user = user
        navigationController?.pushViewController(chatController!, animated: true)
    }
       
    
    func setupNavigationItems() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = composeButton
    }
    
    @objc func handleNewMessage() {
        newMessageController = NewMessageController()
        newMessageController?.conversationsDelegate = self
        let navController = UINavigationController(rootViewController: newMessageController!)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            
        } catch let logoutError {
            print(logoutError)
        }
        
        loginController = LoginViewController()
        loginController!.delegate = self
        isLoggedIn = false
        present(loginController!, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// DataSource
extension ConversationsController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UserCell
        cell.message = message
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}
// Delegate Methods
extension ConversationsController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    private func fetchUserFromFirebase(withmessage message: Message) {

        guard let chatPartnerID = message.chatPartnerID() else {
            assertionFailure("For some reason, the message does NOT contain chat partneriD")
            return
        }
        
        let ref = FDNodeRef.shared.userNode(toChild: chatPartnerID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            var user = LocalUser()
            user.id = chatPartnerID
            user.name = dictionary["name"] as? String
            user.email = dictionary["email"] as? String
            user.profileImageURL = dictionary["profileImageUrl"] as? String

            self.showChatController(forUser: user)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        fetchUserFromFirebase(withmessage: message)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        if let chatPartnerID = message.chatPartnerID() {
            let ref = FDNodeRef.shared.userMessagesNode(toChild: FDNodeRef.currentUserUID, anotherChild: chatPartnerID)
            ref.removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Something went wrong when trying to delete", error!)
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerID)
                self.attemptToReloadTable()
                
            })
        }
    }
}


