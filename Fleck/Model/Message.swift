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
    
    func chatPartnerID() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}
