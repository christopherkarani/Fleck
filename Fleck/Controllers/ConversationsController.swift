//
//  ConversationsController.swift
//  Fleck
//
//  Created by macuser1 on 23/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit

class ConversationsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
       
        setupNavigationItems()
    }
    func setupNavigationItems() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func handleLogout() {
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
