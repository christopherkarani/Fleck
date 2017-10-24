//
//  LoginController.swift
//  Fleck
//
//  Created by macuser1 on 23/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController : UIViewController {
    
    private var inputContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.98, alpha: 0.98)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var loginRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    var nameSeperatorLineUI: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return view
    }()
    
    var emailSeperatorLineUI: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return view
    }()
    
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        return textField
    }()

    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var profileImageSelector: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "EmptyProfileIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc func handleRegister() {
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
//            guard error != nil else {
//                print(error)
//                return
//            }
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {
                fatalError("No user ID provided during auth")
            }
            
            //Register Users to database
            let ref = Database.database().reference()
            let usersRef = ref.child("users").child(uid)
            
            let values = ["name": name, "email": email]
            usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(error!)
                    return
                }
                
                print("Success Authenticating user to server")
            })
            
        }
    }
    
    private func handleConstraints () {

        func inputViewConstrainsts() {
            inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
            inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
        
        func loginRegisterButtonConstraints() {
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 8).isActive = true
            loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        }
        
        func profileImageSelectorConstraints() {
            let squareDimension: CGFloat = 150
            profileImageSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImageSelector.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -8).isActive = true
            profileImageSelector.widthAnchor.constraint(equalToConstant: squareDimension).isActive = true
            profileImageSelector.heightAnchor.constraint(equalToConstant: squareDimension).isActive = true
        }
        
        
        func textFieldConstraints() {
            func nameTextFieldConstraints() {
                nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
                nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
                nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -6).isActive = true
                nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
            }
            
            func emailTextFieldConstraints() {
                emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
                emailTextField.topAnchor.constraint(equalTo: nameSeperatorLineUI.topAnchor).isActive = true
                emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -8).isActive = true
                emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
            }
            
            func passwordTextFieldConstraints() {
                passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
                passwordTextField.topAnchor.constraint(equalTo: emailSeperatorLineUI.topAnchor).isActive = true
                passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -8).isActive = true
                passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
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
            profileImageSelectorConstraints()
        }
        
        inputViewConstrainsts()
        loginRegisterButtonConstraints()
        textFieldConstraints()
    }
    
    func handleAdditionOfSubviews() {
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageSelector)
        
        func inputContainer() {
            inputContainerView.addSubview(nameTextField)
            inputContainerView.addSubview(nameSeperatorLineUI)
            inputContainerView.addSubview(emailTextField)
            inputContainerView.addSubview(emailSeperatorLineUI)
            inputContainerView.addSubview(passwordTextField)
        }
        
        inputContainer()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(r: 61, g: 91, b: 151)
        handleAdditionOfSubviews()
        handleConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
