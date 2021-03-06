//
//  MessageCell.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-06-25.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            //SOSMessageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var chatMessage: ChatMessage? {
        didSet {
            guard let myUID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users")
            if (chatMessage?.fromID != myUID) {
                nameLabel.text = chatMessage?.sender
                if let fromID = chatMessage?.fromID {
                    ref.child(fromID).observeSingleEvent(of: .value) { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            
                            if let profileImageURL = dictionary["profileImageURL"] as? String {
                                self.profileImageView.loadImageUsingCache(urlString: profileImageURL)
                            }
                        }
                    }
                }
            } else {
                nameLabel.text = chatMessage?.recepient
                if let toID = chatMessage?.toID {
                    ref.child(toID).observeSingleEvent(of: .value) { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            
                            if let profileImageURL = dictionary["profileImageURL"] as? String {
                                self.profileImageView.loadImageUsingCache(urlString: profileImageURL)
                            }
                        }
                    }
                }
            }
            messageLabel.text = chatMessage?.messageBody
            if let date = chatMessage?.timeStamp {
                let x = date / 1000
                let theDate = NSDate(timeIntervalSince1970: x)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                let elapsedTimeInSeconds = NSDate().timeIntervalSince(theDate as Date)
                
                let secondsInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > secondsInDays {
                    dateFormatter.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormatter.string(from: theDate as Date)
                
            }
        }
    }
    
    
//    var message: Message? {
//        
//        didSet {
//            
//            guard let myUID = Auth.auth().currentUser?.uid else { return }
//            let ref = Database.database().reference().child("users")
//            if (message?.fromID != myUID) {
//                nameLabel.text = message?.sender
//                if let fromID = message?.fromID {
//                    ref.child(fromID).observeSingleEvent(of: .value) { (snapshot) in
//                        if let dictionary = snapshot.value as? [String: AnyObject] {
//                            
//                            if let profileImageURL = dictionary["profileImageURL"] as? String {
//                                self.profileImageView.loadImageUsingCache(urlString: profileImageURL)
//                            }
//                        }
//                    }
//                }
//            } else {
//                nameLabel.text = message?.recepient
//                if let toID = message?.toID {
//                    ref.child(toID).observeSingleEvent(of: .value) { (snapshot) in
//                        if let dictionary = snapshot.value as? [String: AnyObject] {
//                            
//                            if let profileImageURL = dictionary["profileImageURL"] as? String {
//                                self.profileImageView.loadImageUsingCache(urlString: profileImageURL)
//                            }
//                        }
//                    }
//                }
//            }
//            
//            
//            messageLabel.text = message?.messageBody
//            
//            //SOSMessageLabel.text = message?.SOSMessage
//
//            
////            if let seconds = message?.timestamp?.doubleValue {
////                let timestampDate = NSDate(timeIntervalSince1970: seconds)
////                let dateFormatter = DateFormatter()
////                dateFormatter.dateFormat = "h:mm a"
////                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
////            }
//            
//            
//            
//
//        }
//    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Omar Tehsin"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friends message saying blah blah blah"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
//    let SOSMessageLabel: UILabel = {
//       let label = UILabel()
//        label.text = "Temporary SOS"
//        label.textColor = UIColor.red
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:10 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setUpContainerView()
        
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "defaultUser")
        hasReadImageView.image = UIImage(named: "defaultUser")
        
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        
        
    }
    private func setUpContainerView() {
        let containerView = UIView()
        
        addSubview(containerView)
        
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        //containerView.addSubview(SOSMessageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        backgroundColor = UIColor.blue
        
    }
}
