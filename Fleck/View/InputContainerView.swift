//
//  InputContainerView.swift
//  Fleck
//
//  Created by macuser1 on 07/11/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit


class InputContainerView: UIView {
    
    var chatDelegate : ChatControllerDelegate?
    
    var chatController : ChatController? {
        didSet {
            name = chatController?.user?.name!
            sendButton.addTarget(chatController, action: #selector(chatController?.handleSend), for: .touchUpInside)
            imageViewTouchArea.addGestureRecognizer(UITapGestureRecognizer(target: chatController, action: #selector(chatController?.handleUploadImage)))
        }
    }
    
    var name: String? {
        didSet {
            if let name = name {
                inputTextField.placeholder = "Send a message to \(String(describing: name))..."
            }
        }
    }
    
    lazy var inputTextField : UITextField = { 
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.image = Theme.UploadImage
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    let imageViewTouchArea : UIView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubViews()
        setupConstraints()
        chatDelegate?.testFunc();
    }

    deinit {
        print("Input View Deallocated")
    }
    
    private func addSubViews() {
        
        addSubview(sendButton)
        addSubview(inputTextField)
        addSubview(imageViewTouchArea)
    }
    
    private func setupConstraints() {
        
        //x,y,w,h imageViewTouchArea Constraints
        imageViewTouchArea.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageViewTouchArea.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageViewTouchArea.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageViewTouchArea.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        imageViewTouchArea.addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraint(equalTo: imageViewTouchArea.leftAnchor, constant: 14).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: imageViewTouchArea.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        

        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: imageViewTouchArea.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        addSubview(seperator)
        
        seperator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperator.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputContainerView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatController?.handleSend()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}


