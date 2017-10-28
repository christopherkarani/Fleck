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
    var delegate: ConversationsControllerDelegate?
    
    
    //MARK: VIEWS
    var inputContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.98, alpha: 0.98)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton : UIButton = {
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
