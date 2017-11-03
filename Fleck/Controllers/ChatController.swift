//
//  ChatViewController.swift
//  Fleck
//
//  Created by macuser1 on 23/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

protocol ChatControllerDelegate: class {
    func performZoom(forSatringImage imageView: UIImageView)
}

class ChatController: UICollectionViewController {
    
    var user : LocalUser? {
        didSet {
            navigationItem.title = user?.name
            observerMessages()
        }
    }
    var messages = [Message]()
    let cellID = "cellID"
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Send a message to \(String(describing: self.user!.name!))..."
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    lazy var inputContainerView : UIView = {
       let containerView = UIView()
        let viewHeight : CGFloat = 50
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: viewHeight)
        containerView.backgroundColor = .white
        containerView.addSubview(self.inputTextField)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        let uploadImageView = UIImageView()
        uploadImageView.image = Theme.UploadImage
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewTouchArea = UIView()
        imageViewTouchArea.translatesAutoresizingMaskIntoConstraints = false
        imageViewTouchArea.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUploadImage))
        imageViewTouchArea.addGestureRecognizer(tap)
        
        imageViewTouchArea.addSubview(uploadImageView)
        
        //x,y,w,h uploadImageView Constraints
        uploadImageView.leftAnchor.constraint(equalTo: imageViewTouchArea.leftAnchor, constant: 14).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: imageViewTouchArea.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        containerView.addSubview(imageViewTouchArea)
        
        //x,y,w,h imageViewTouchArea Constraints
        imageViewTouchArea.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        imageViewTouchArea.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        imageViewTouchArea.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageViewTouchArea.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: imageViewTouchArea.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        containerView.addSubview(seperator)
        
        seperator.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        seperator.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        return containerView
    }()

    //MARK: Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8 , right: 0)
    
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        //setupInputComponents()
        setupKeyboardObservers()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    //MARK: Setup Input Components
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        //x,y,width,height
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        containerView.addSubview(seperator)
        
        seperator.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        seperator.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
  
    }
    
    ///Observes The messages node and appends thoe messages to the 'messages' Array
    func observerMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toID = user?.id else {
            return
        }
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toID)
        userMessageRef.observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageID)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    //MARK: SEND FUNCTION
    ///Handles Sending to the Firebase database. Messages are stored inside the "messages" node
    ///Messages recieve a unique ID via 'childByAutoId()'
    ///
    @objc func handleSend() {
        guard let inputText = inputTextField.text, !inputText.isEmpty else {
            print("no text")
            return
        }
        let properties: [String : Any] = ["text": inputText]
        sendMessage(withProperties: properties)
    }

}

extension ChatController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
// DataSource
extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(withCell: cell, andMessage: message)
        
        if let text = message.text {
            let padding: CGFloat = 32
            cell.bubbleWidthAnchor?.constant = estimatedFrame(forText: text).width + padding
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
        }

        return cell
    }
    
    func setupCell(withCell cell: ChatMessageCell, andMessage message: Message) {
        cell.chatDelegate = self
        
        if let profileImageURL = self.user?.profileImageURL {
            cell.profileImageView.loadImageUsingCache(withURLString: profileImageURL)
        }
        if let messageURL = message.imageUrl {
            cell.bubbleView.backgroundColor = .clear
            cell.messageImageView.loadImageUsingCache(withURLString: messageURL)
            cell.messageImageView.isHidden = false
            cell.textView.isHidden = true
        } else {
            cell.messageImageView.isHidden = true
            cell.textView.isHidden = false
        }
        
        if message.fromID == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = Theme.chatBubbleOutgoing
            cell.textView.textColor = .white
            cell.bubbleViewXAnchor?.isActive = false
            cell.bubbleViewXAnchor = cell.bubbleView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -8)
            cell.bubbleViewXAnchor?.isActive = true
            cell.profileImageView.isHidden = true
            
        } else {
            cell.bubbleViewXAnchor?.isActive = false
            cell.bubbleViewXAnchor = cell.bubbleView.leftAnchor.constraint(equalTo: cell.profileImageView.rightAnchor, constant: 8)
            cell.bubbleViewXAnchor?.isActive = true
            cell.bubbleView.backgroundColor = Theme.chatBubbleIncoming
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
        }
    }
}
//Delegate
extension ChatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        let padding: CGFloat = 20
        let message =  messages[indexPath.item]
        if let text = message.text {
            height = estimatedFrame(forText: text).height + padding
        } else if let imageHeight = message.imageHeight, let imageWidth = message.imageWidth {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
       return CGSize(width: view.frame.width, height: height)
    }
    
    func estimatedFrame(forText text: String) -> CGRect {
        // width is same as cell.texView width
        //height is an arbitrary larg value
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        return  NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout() // good fix when using constraints
    }
}
// Keyboard Logic
extension ChatController {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: .UIKeyboardDidShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(withNotification:)), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(withNotification:)), name: .UIKeyboardDidHide, object: nil)
    }
    @objc func handleKeyboardDidShow() {
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    @objc func handleKeyboardWillShow(withNotification notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        containerViewBottomAnchor?.constant = -(keyboardFrame?.height)!
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func handleKeyboardWillHide(withNotification notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    //Invalidate Notification Observers
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

// Accesory View
extension ChatController {
    override var inputAccessoryView: UIView? {
        get {
           return inputContainerView
        }
    }
    // if we dont set this, accesorry view is not visibile
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
//ImagePicker
extension ChatController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleUploadImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageData = handleSelectImage(withInfo: info)
        let image = imageData.image
        handleUploadToFirebase(withData: imageData.data, andImage: image)
        
    }
    
    func handleSelectImage(withInfo info : [String: Any]) -> (data: Data, image: UIImage) {
        var selectedImage : UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }
        guard let imageData = UIImageJPEGRepresentation(selectedImage!, 0.2) else {
            fatalError("Unable To convert image to data")
        }
        
        return (imageData, selectedImage!)
    }
    
    func handleUploadToFirebase(withData data: Data, andImage image: UIImage) {
        let ref = FDNodeRef.shared.uploadMesaageImageNode(toStorage: true)
        ref.putData(data, metadata: nil) { (metadata, error) in
            if error != nil  {
                print(error!)
                return
            }
            
            if let imageUrl = metadata?.downloadURL()?.absoluteString {
                self.handleSendImage(withUrlString: imageUrl, andImage: image)
            }
            
            self.dismiss(animated: true, completion: nil)
       
        }
        
    }
    
    private func handleSendImage(withUrlString urlString: String, andImage image: UIImage) {
        let properties: [String: Any] = ["imageUrl": urlString, "imageWidth": image.size.width, "imageHeight":image.size.height]
        sendMessage(withProperties: properties)
    }
    
    func sendMessage(withProperties properties : [String: Any]) {
        let messageRef = Database.database().reference().child("messages")
        let childRef = messageRef.childByAutoId()
        let toID = user!.id!
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        var values: [String : Any] = ["toID": toID,
                                      "fromID": fromID,
                                      "timestamp": timestamp,
                                      ]
        properties.forEach({values[$0.key] = $0.value})
                                      
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.inputTextField.text = nil
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromID).child(toID)
            let messageID = childRef.key
            userMessageRef.updateChildValues([messageID: 1])
            
            let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toID).child(fromID)
            recipientUserMessageRef.updateChildValues([messageID: 1])
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//handle zoom on tap image
extension ChatController: ChatControllerDelegate {
    func performZoom(forSatringImage imageView: UIImageView) {
       let startingFrame = imageView.superview?.convert(imageView.frame, from: nil)
        print(startingFrame)
    }
}


