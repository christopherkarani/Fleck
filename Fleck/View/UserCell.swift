//
//  UserCell.swift
//  Fleck
//
//  Created by macuser1 on 26/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message : Message? {
        didSet {

            setupNameAndProfileImage()
            detailTextLabel?.text = message?.text
            if let seconds = message?.timeStamp {
                let timeStampDate = Date(timeIntervalSince1970: TimeInterval(seconds))
                let timeString = Date().timeAgoSinceDate(date: timeStampDate as NSDate, numericDates: false)
                timeLabel.text = timeString
            }
        }
    }
    
    
    
    func setupNameAndProfileImage() {
        if let id = message?.chatPartnerID() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCache(withURLString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    let timeLabel: UILabel = {
       let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = UIColor.lightGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    

    
    private func setupConstrainsts() {
        

        // x,y, width and height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        guard let myTextLabel = textLabel else {
            print("No valid text label for constraint")
            return
        }
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: myTextLabel.heightAnchor).isActive = true
        

    }
    private func addViewsToCell() {
        addSubview(profileImageView)
        addSubview(timeLabel)
    }
    
    //MARK: LAYOUT SUBVIEWS
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 60,
                                  y: textLabel!.frame.origin.y,
                                  width: textLabel!.frame.width,
                                  height: textLabel!.frame.height - 2)
        detailTextLabel?.frame =  CGRect(x: 60,
                                         y: detailTextLabel!.frame.origin.y,
                                         width: detailTextLabel!.frame.width,
                                         height: detailTextLabel!.frame.height + 2)
    }
    
    
    // MARK: INIT
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addViewsToCell()
        setupConstrainsts()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
