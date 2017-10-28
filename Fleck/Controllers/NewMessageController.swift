//
//  NewMessageController.swift
//  Fleck
//
//  Created by macuser1 on 26/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    var users = [LocalUser]()
    var cellID = "CellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationItem()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
    }
    
    func fetchUsers() {
        let ref = Database.database().reference().child(FDNodeName.userNode())
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var user = LocalUser()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageURL = dictionary["profileImageUrl"] as? String
                self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                }) 
            }
        }
        
    }
    
    func setupNavigationItem() {
        let cancleButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancleButton
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: DELEGATE
extension NewMessageController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myUser = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UserCell
        cell.textLabel?.text = myUser.name
        cell.detailTextLabel?.text = myUser.email
        if let profileImageURL = myUser.profileImageURL {
            cell.profileImageView.loadImageUsingCache(withURLString: profileImageURL)
        }
        return cell
    }
}

//MARK: DATASOURCE
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
