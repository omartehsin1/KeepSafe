//
//  FriendMessageCollectionViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-06-20.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import EmptyDataSet_Swift



class FriendMessageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, EmptyDataSetSource, EmptyDataSetDelegate {
    private let cellID = "cellID"
    var messagesArray: [Message] = [Message]()
    var users = [Users]()
    let textField = UITextView()
    let button = UIButton(type: .system)
    var recepient = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        navigationItem.title = "Chat"
        textField.delegate = self
        retrieveChat()
        createTextView()
        createButton()
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        
        
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatCell
        
        let message = messagesArray[indexPath.row]
        
        cell.message = message
        
        
        return cell
    }
    
    
    func retrieveChat() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).child("Messages").observe(.value) { (snapshot) in
                for messages in snapshot.children.allObjects as! [DataSnapshot] {
                    //self.messagesArray.removeAll()
                    if let dictionary = messages.value as? [String: AnyObject] {
                        let message = Message()
                        message.messageBody = dictionary["MessageBody"] as? String ?? ""
                        
                        message.sender = dictionary["Sender"] as? String ?? ""
                        message.recepient = dictionary["Recepient"] as? String ?? ""
                        self.messagesArray.append(message)
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
}

class ChatCell: BaseCell {
    var message: Message? {
        didSet {
            nameLabel.text = message?.sender
            messageLabel.text = message?.messageBody
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = dateFormatter.string(from: date as Date)
                
            }
        }
    }
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
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
        //addSubview(messageTextView)
        //addConstraintsWithFormat(format: "H:|[v0]|", views: messageTextView)
        //addConstraintsWithFormat(format: "V:|[v0]|", views: messageTextView)
        
        
        
        addSubview(profileImageView)
        
        
        setUpContainerView()
        
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "defaultUser")
        hasReadImageView.image = UIImage(named: "defaultUser")
        
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        
        
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

extension FriendMessageCollectionViewController {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let noCircle = UIImage(named: "noCircle")
        return noCircle
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title = "You have no chats!"
        let font = UIFont.boldSystemFont(ofSize: 18)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 1
        
        let attributes: [NSAttributedString.Key : Any] = [.font : font, .foregroundColor: UIColor.darkGray, .shadow: shadow]
        let attributedQuote = NSAttributedString(string: title, attributes: attributes)
        return attributedQuote
    }
}

//Create text view
extension FriendMessageCollectionViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func createTextView() {
        
        textField.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        textField.backgroundColor = .lightGray
        view.addSubview(textField)
        
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        [
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50)
            ].forEach{ $0.isActive = true}
        
        textField.isScrollEnabled = false
        textField.text = "Enter your message"
        
        
        
        
    }
    func createButton() {
        button.backgroundColor = UIColor.orange
        button.setTitle("Click Me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        textField.addSubview(button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.topAnchor.constraint(equalTo: textField.topAnchor).isActive = true
        
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 20).isActive = true
        view.bringSubviewToFront(button)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textField.sizeThatFits(size)
        
        textField.constraints.forEach { (constraints) in
            if constraints.firstAttribute == .height {
                constraints.constant = estimatedSize.height + 15
            }
        }
        
        
    }
    @objc func sendPressed() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        let messageDB = Database.database().reference().child("users").child(myUID).child("Messages").childByAutoId()
        //Auth.auth().currentUser?.email as! String
        let messageDictionary: NSDictionary = ["Sender": Auth.auth().currentUser?.email as! String, "MessageBody": textField.text, "Recepient": recepient]
        
        messageDB.setValue(messageDictionary) {
            (error, ref) in
            if error != nil {
                print(error!)
            }
            else {
                print("Message Saved Successfully!")
            }
            
            DispatchQueue.main.async {
                self.textField.text = ""
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
