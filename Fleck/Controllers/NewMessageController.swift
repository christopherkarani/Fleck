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

    }
    
    func fetchUsers() {
        let ref = Database.database().reference().child(FDNodeName.userNode())
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let email = dictionary["email"] as? String
                let name = dictionary["name"] as? String
                let user = LocalUser(name: name!, email: email!)
                self.users.append(user)
                self.tableView.reloadData()
                
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
        print(users.count)
        let myUser = users[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        cell.textLabel?.text = myUser.name
        cell.detailTextLabel?.text = myUser.email
        
        return cell
    }
}

//MARK: DATASOURCE
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}
