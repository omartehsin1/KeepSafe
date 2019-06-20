//
//  FriendsViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-06-19.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class Friend: NSObject {
    var name: String?
    var profileImageName: String?
}
class TheMessage: NSObject{
    var text: String?
    var date: NSDate?
    
    var friend: Friend?
}

class FriendsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellID = "cellID"
    var theMessages: [TheMessage]?
    var myMessages: [Message] = [Message]()
    var users = [Users]()
    var tempLast : [String] = []
    var lastMessage : [String] = []
    
    func setUpData() {
        let omar = Friend()
        omar.name = "Omar Tehsin"
        omar.profileImageName = "defaultUser"
        
        let message = TheMessage()
        message.friend = omar
        message.text = "Hello my name is omar. Nice to meet you..."
        message.date = NSDate()
        
        theMessages = [message]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.backgroundColor = UIColor.white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true
        navigationItem.title = "Messages"
        retrieveMessages()
        //print(lastMessage)

        //setUpData()

    }
    func retrieveMessages() {
//        if let uid = Auth.auth().currentUser?.uid {
//            Database.database().reference().child("users").child(uid).child("Messages").observe(.value) { (snapshot) in
//                for chatLogMessages in snapshot.children.allObjects as! [DataSnapshot] {
//                    if let dictionary = chatLogMessages.value as? [String: AnyObject] {
//                        let lastVal = dictionary["MessageBody"] as? String ?? ""
//
//                        self.tempLast.append(lastVal)
//
//
//                        let message = Message()
//                        message.messageBody = dictionary["MessageBody"] as? String ?? ""
//                        message.recepient = dictionary["Recepient"] as? String ?? ""
//                        self.myMessages.append(message)
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                            self.appendTheArray()
//
//                        }
//                    }
//
//                }
//            }
//        }
        if let otherUID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(otherUID).child("Messages").queryLimited(toLast: 1)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                for chatLogMessages in snapshot.children.allObjects as! [DataSnapshot] {
                    if let dictionary = chatLogMessages.value as? [String: AnyObject] {
                        let message = Message()
                        message.messageBody = dictionary["MessageBody"] as? String ?? ""
                        message.recepient = dictionary["Recepient"] as? String ?? ""
                        self.myMessages.append(message)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        
        
    }
    func appendTheArray() {
        guard let mostRecentMessage = tempLast.last else { return }
        lastMessage.append(mostRecentMessage)
        //print(lastMessage)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return myMessages.count
        //return lastMessage.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell

        let message = myMessages[indexPath.row]
        //let message = lastMessage[indexPath.row]
        cell.message = message
            
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }

}

class MessageCell: BaseCell {
    
//    var message: TheMessage? {
//        didSet {
//            nameLabel.text = message?.friend?.name
//
//            if let profileImageName = message?.friend?.profileImageName {
//                profileImageView.image = UIImage(named: profileImageName)
//                hasReadImageView.image = UIImage(named: profileImageName)
//            }
//
//            messageLabel.text = message?.text
//
//            if let date = message?.date {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "h:mm a"
//                timeLabel.text = dateFormatter.string(from: date as Date)
//
//            }
//        }
//    }
    var message: Message? {
        didSet {
            nameLabel.text = message?.recepient
            
            messageLabel.text = message?.messageBody
        }
    }
    
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
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05 pm"
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
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
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
