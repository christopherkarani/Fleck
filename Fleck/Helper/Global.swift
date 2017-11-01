//
//  Global.swift
//  Fleck
//
//  Created by macuser1 on 23/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


//Contains Firbase DB Node Names
enum FDNodeRef: String {
    case users
    
    func returnRootNode() -> DatabaseReference {
        return Database.database().reference()
    }
    
    /// returns the 'DatabaseReference' of "users" Node Reference inside of your Firebase Database
    static func userNode() -> DatabaseReference {
        let ref = Database.database().reference().child("users")
        return ref
    }
//    static func userNode() -> DatabaseReference {
//        let ref = Database.database().reference().child("users")
//        return ref
//    }
    
    /// returns the 'DatabaseReference' of "users" Node Reference inside of your Firebase Database
    static func nameNode() -> String? {
        
        return "name"
    }
    
    static func emailNode() -> String {
        return "email"
    }
    
    static func messagesNode() ->String {
        return "messages"
    }
    
    static func profileImageURLNode() -> String {
        return "profileImageUrl"
    }
    
    static func userMessagesNode() -> String {
        return "user-messages"
    }
}
