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
    func fetchUserSetupNavigationBar()
    var navigationTitile: String? { get set }
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
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child(FDNodeName.userNode()).child(uid!)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationTitile = dictionary["name"] as? String
                }
            })
        }
    }
    func fetchUserSetupNavigationBar() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(FDNodeName.userNode()).child(uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationTitile = dictionary["name"] as? String
            }
        })
        
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
