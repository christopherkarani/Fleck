//
//  Message.swift
//  Fleck
//
//  Created by macuser1 on 30/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    var fromID: String?
    var text: String?
    var timeStamp: Int?
    var toID: String?
    var imageUrl: String?
    var imageWidth: CGFloat?
    var imageHeight: CGFloat?

    
    func chatPartnerID() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
    
    init(dictionary: [String: AnyObject]) {
        self.fromID = dictionary["fromID"] as? String
        self.toID = dictionary["toID"] as? String
        self.text = dictionary["text"] as? String
        self.timeStamp = dictionary["timestamp"] as? Int
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? CGFloat
        self.imageHeight = dictionary["imageHeight"] as? CGFloat
        
    }
}
