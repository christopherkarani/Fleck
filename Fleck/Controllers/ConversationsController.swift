//
//  ConversationsController.swift
//  Fleck
//
//  Created by macuser1 on 23/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

class ConversationsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        setupNavigationItems()
        checkIfUserIsLoggedIn()

        
    }
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child(FDNodeName.userNode()).child(uid!)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            })
            
        }
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
