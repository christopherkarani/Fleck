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
    
    //MARK: PROPERTIES
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    //MARK: VIEWS
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
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
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
    
    lazy var profileImageSelector: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "EmptyProfileIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImagePicker))
        imageView.addGestureRecognizer(tap)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    

    
    //MARK: SEGMENTED CONTROL
    lazy var loginRegisterSegementedControl : UISegmentedControl = {
        let control = UISegmentedControl(items: ["Login", "Register"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 1
        control.tintColor = .white
        control.addTarget(self, action: #selector(handleLoginRegisterSegmentChange), for: .valueChanged)
        return control
    }()
    
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
    
    
  
    //MARK: CONSTRAINTS
    private func handleConstraints () {

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
    
    //MARK: ADDINGSUBVIEWS
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
    //MARK: VIEWDIDLOAD
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
