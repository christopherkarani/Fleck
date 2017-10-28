//
//  LoginController+Handlers.swift
//  Fleck
//
//  Created by macuser1 on 26/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleProfileImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage : UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }
        if let image = selectedImage {
            profileImageSelector.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Picker Did Cancle")
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController {
    //MARK: LOGIN FUNCTIONALITY
    @objc func handleLoginRegister() {
        if loginRegisterSegementedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text else {
            print("Invaid Email")
            return
        }
        guard let password = passwordTextField.text else {
            print("Invalid Password")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
            }
            print("Succesfully Logged in")
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func handleRegister() {
        guard let email = emailTextField.text else {
            print("Invaid Email")
            return
        }
        guard let password = passwordTextField.text else {
            print("Invalid Password")
            return
        }
        guard let name = nameTextField.text else {
            print("No valid name")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {
                fatalError("No user ID provided during auth")
            }
            
            guard let imageData = UIImagePNGRepresentation(self.profileImageSelector.image!) else {
                print("Image to PNG Error")
                return
            }
            // generate a unique string
            let imageName = UUID().uuidString
            //Store ImageInto Firebase DB
            let storageRef = Storage.storage().reference().child("Profile_Images").child("\(imageName).png")
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                }
                guard let profileImageURL = metadata?.downloadURL()?.absoluteString else {
                    print("Error: ProfileImageURLnot valid")
                    return
                }
                let values = ["name": name, "email": email, "profileImageUrl": profileImageURL]
                self.registerUserIntoDatabase(withUID: uid, andValues: values)

            })
        }
    }
     /// Register Users to database
    func registerUserIntoDatabase(withUID id: String, andValues values: [String:String]) {
        let ref = Database.database().reference()
        let usersRef = ref.child(FDNodeName.userNode()).child(id)
        usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}
