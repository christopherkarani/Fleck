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
    
    //MARK: Handle ImagePicker
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
    //MARK: handle Login/Register Condition
    @objc func handleLoginRegister() {
        if loginRegisterSegementedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    // MARK: Handle Login
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
            self.delegate?.fetchUserSetupNavigationBar()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: HandleRegister
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
            
            guard  let profileImage = self.profileImageSelector.image,
                let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) else {
                print("Something Went wrong while trying to turn image to jpeg")
                return
            }

            // generate a unique string
            let imageName = UUID().uuidString
            //Store ImageInto Firebase DB
            let storageRef = Storage.storage().reference().child("Profile_Images").child("\(imageName).jpg")
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
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
            var user = LocalUser()
            user.name = values["name"]
            user.email = values["email"]
            user.profileImageURL = values["profileImageURL"]
            self.delegate?.setupNavigationBar(withUser: user)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    /// handles the functionality of the segmented controller
    @objc func handleLoginRegisterSegmentChange() {
        let selectedIndex = loginRegisterSegementedControl.selectedSegmentIndex
        let title = loginRegisterSegementedControl.titleForSegment(at: selectedIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of containerView
        inputContainerViewHeightAnchor?.constant = selectedIndex == 0 ? 100 : 150
        
        //change other contraints
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }

    //MARK: ADDINGSUBVIEWS
    ///Handles the adding of subviews to the login Controller
    func handleAdditionOfSubviews() {
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageSelector)
        view.addSubview(loginRegisterSegementedControl)
        
        func inputContainer() {
            inputContainerView.addSubview(nameTextField)
            inputContainerView.addSubview(nameSeperatorLineUI)
            inputContainerView.addSubview(emailTextField)
            inputContainerView.addSubview(emailSeperatorLineUI)
            inputContainerView.addSubview(passwordTextField)
        }
        
        inputContainer()
    }
}

extension LoginViewController {
    //MARK: CONSTRAINTS
    func handleConstraints() {
        
        func inputViewConstrainsts() {
            inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
            
            inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
            inputContainerViewHeightAnchor?.isActive = true
        }
        
        func loginRegisterButtonConstraints() {
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 8).isActive = true
            loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        func profileImageSelectorConstraints() {
            let squareDimension: CGFloat = 150
            profileImageSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImageSelector.bottomAnchor.constraint(equalTo: loginRegisterSegementedControl.topAnchor, constant: -8).isActive = true
            profileImageSelector.widthAnchor.constraint(equalToConstant: squareDimension).isActive = true
            profileImageSelector.heightAnchor.constraint(equalToConstant: squareDimension).isActive = true
        }
        
        func segmentedControlConstraints() {
            // need x,y, width and height constraints
            loginRegisterSegementedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            loginRegisterSegementedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
            loginRegisterSegementedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
            loginRegisterSegementedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
        }
        
        func textFieldConstraints() {
            func nameTextFieldConstraints() {
                nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
                nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
                nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -6).isActive = true
                
                nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
                nameTextFieldHeightAnchor?.isActive = true
            }
            
            func emailTextFieldConstraints() {
                emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
                emailTextField.topAnchor.constraint(equalTo: nameSeperatorLineUI.topAnchor).isActive = true
                emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -8).isActive = true
                
                emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
                emailTextFieldHeightAnchor?.isActive = true
            }
            
            func passwordTextFieldConstraints() {
                passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
                passwordTextField.topAnchor.constraint(equalTo: emailSeperatorLineUI.topAnchor).isActive = true
                passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -8).isActive = true
                passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
                passwordTextFieldHeightAnchor?.isActive = true
            }
            
            func nameSeperatorLine() {
                nameSeperatorLineUI.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
                nameSeperatorLineUI.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
                nameSeperatorLineUI.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
                nameSeperatorLineUI.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
            
            func emailSeperatorLine() {
                emailSeperatorLineUI.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
                emailSeperatorLineUI.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
                emailSeperatorLineUI.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
                emailSeperatorLineUI.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
            
            nameTextFieldConstraints()
            nameSeperatorLine()
            emailTextFieldConstraints()
            emailSeperatorLine()
            passwordTextFieldConstraints()
            
        }
        
        inputViewConstrainsts()
        loginRegisterButtonConstraints()
        textFieldConstraints()
        profileImageSelectorConstraints()
        segmentedControlConstraints()
    }
}
