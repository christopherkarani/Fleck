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
enum FDNodeName: String {
    case users
    
    func returnRootNode() -> DatabaseReference {
        return Database.database().reference()
    }
    static func userNode() -> String {
        return "users"
    }
    static func nameNode() -> String {
        return "name"
    }
    
    static func emailNode() -> String {
        return "email"
    }
    
    static func profileImageURLNode() -> String {
        return "profileImageUrl"
    }
}
