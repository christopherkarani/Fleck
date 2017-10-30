//
//  ConversationsController.swift
//  Fleck
//
//  Created by macuser1 on 23/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

protocol ConversationsControllerDelegate {
    func setupNavigationBar(withUser user: LocalUser)
    func fetchUserSetupNavigationBar()
}

class ConversationsController: UITableViewController, ConversationsControllerDelegate {
    
    var navigationTitile: String? {
        didSet {
            navigationItem.title = navigationTitile!
        }
    }
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        setupNavigationItems()
        checkIfUserIsLoggedIn()
  
    }
    
    //MARK: VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    //MARK: USER LOGGED IN CHECK
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserSetupNavigationBar()
        }
    }
    func fetchUserSetupNavigationBar() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(FDNodeName.userNode()).child(uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
//                self.navigationTitile = dictionary["name"] as? String
                var user = LocalUser()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageURL = dictionary["profileImageUrl"] as? String
                self.setupNavigationBar(withUser: user)
            }
        })
        
    }
    
    func setupNavigationBar(withUser user: LocalUser) {
        guard let profileImageURLString = user.profileImageURL else {
            print("Something went wrong while setting up Navigation Bar")
            return
        }
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = .red
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.loadImageUsingCache(withURLString: profileImageURLString)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        

        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)

        
        // nameLabel Constrainsts
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true

        //x,y,width,height
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // containerView Constraints
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
    }
    
    func setupNavigationItems() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = composeButton
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginViewController()
        loginController.delegate = self
        present(loginController, animated: true) {
            // Delete Keys from key chain.
            // End Session
            // Lock Screen
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
