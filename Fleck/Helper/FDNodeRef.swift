//
//  FDNodeRef.swift
//  Fleck
//
//  Created by macuser1 on 04/11/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import Foundation
import Firebase

class FDNodeRef {
    
    static let shared = FDNodeRef()
    
    func returnRootNode() -> DatabaseReference {
        return Database.database().reference()
    }
    
    /// returns the 'DatabaseReference' of "users" Node Reference inside of your Firebase Database
    func userNode() -> DatabaseReference {
        return  Database.database().reference().child("users")
    }
    
    /// returns the 'StorageReference' of "message_images" Node Reference inside of your Firebase Storage
    func uploadMesaageImageNode(toStorage: Bool) -> StorageReference {
        switch toStorage {
        case true:
            let randomString = UUID().uuidString
            return Storage.storage().reference().child("message_images").child(randomString)
        default:
            return Storage.storage().reference().child("message_images")
        }
    }
    
    /// returns the storage reference path where images sent from messages are stored
//    func uploadMessageImage(withName name: String) -> StorageReference {
//        return uploadMesaageImageNode().child("\(name).jpg")
//    }
    
    func messagesNode() -> DatabaseReference {
        return  Database.database().reference().child("messages")
    }
    
    func profileImagesStorageRef(toStoragePath: Bool) -> StorageReference {
        switch toStoragePath {
        case true:
            let imageName = UUID().uuidString
            return Storage.storage().reference().child("Profile_Images").child("\(imageName).jpg")
        case false:
           return Storage.storage().reference().child("Profile_Images")
        }
    }
    
}
