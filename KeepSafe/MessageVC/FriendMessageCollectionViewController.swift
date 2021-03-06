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
import UserNotifications


class FriendMessageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, EmptyDataSetSource, EmptyDataSetDelegate {
    
    
    private let cellID = "cellID"
    //var messagesArray: [Message] = [Message]()
    var chatMessageArray: [ChatMessage] = [ChatMessage]()
    var users = [Users]()
    let textField = UITextView()
    let button = UIButton(type: .system)
    var recepient = String()
    let timestamp = ServerValue.timestamp()
    var toID = String()
    //let messageDB = FirebaseConstants.messagesDatabase
    let SOSDatabase = FirebaseConstants.SOSDatabase
    
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
        
        return chatMessageArray.count
        //return messagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatCell
         let myUID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users")
        
        cell.messageTextView.text = chatMessageArray[indexPath.row].messageBody

        
        if(chatMessageArray[indexPath.row].fromID != myUID!) {
            navigationItem.title = chatMessageArray[indexPath.row].sender
        } else {
            navigationItem.title = chatMessageArray[indexPath.row].recepient
        }
        
        if let messageText = chatMessageArray[indexPath.item].messageBody {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
        
        if chatMessageArray[indexPath.row].sender == Auth.auth().currentUser?.email {
            cell.messageTextView.frame = CGRect(x:view.frame.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            cell.messageTextView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
        } else {
            cell.messageTextView.frame = CGRect(x:48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            cell.messageTextView.textColor = UIColor.black
            ref.child(chatMessageArray[indexPath.row].fromID!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if let profileImageURL = dictionary["profileImageURL"] as? String {
                        cell.profileImageView.isHidden = false
                        cell.profileImageView.loadImageUsingCache(urlString: profileImageURL)
                    }
                }
            }
            }
        }
        
        
        return cell
    }

    func retrieveChat() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        
        let reference = Database.database().reference().child("user-messages").child(myUID).child(toID)
        reference.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let chatMessage = ChatMessage()
                chatMessage.id = reference.key as? String
                chatMessage.fromID = dictionary["fromID"] as? String
                chatMessage.messageBody = dictionary["messageBody"] as? String
                chatMessage.recepient = dictionary["recepient"] as? String
                chatMessage.sender = dictionary["sender"] as? String
                chatMessage.timeStamp = dictionary["timestamp"] as? Double
               chatMessage.toID = dictionary["toID"] as? String
                
                

                self.chatMessageArray.append(chatMessage)
    
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
        
//        SOSDatabase.queryOrdered(byChild: "toID").queryEqual(toValue: toID).observe(.childAdded) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                //let message = Message()
//                //message.messageBody = dictionary["SOSMessage"] as? String ?? ""
//                //message.toID = dictionary["toID"] as? String ?? ""
//
//                //self.messagesArray.append(message)
//
//                let chatMessage = ChatMessage(id: " ", fromID: " ", messageBody: dictionary["SOSMessage"] as? String ?? "", recepient: " ", sender: " " , timeStamp: 2, toID: dictionary["toID"] as? String ?? "")
//
//                self.chatMessageArray.append(chatMessage)
//
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            }
//        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        if let messageText = chatMessageArray[indexPath.item].messageBody {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
            
        }
        
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
}

class ChatCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 15
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
    
    
    
    override func setupViews() {
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        
        
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
        //textField.backgroundColor = .lightGray
        textField.backgroundColor = UIColor.init(displayP3Red: 228, green: 232, blue: 220, alpha: 1.0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
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
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        textField.addSubview(button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.topAnchor.constraint(equalTo: textField.topAnchor).isActive = true
        
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 20).isActive = true
        view.bringSubviewToFront(button)
        //x: 135, y: 546, w: 107, h:30
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
        //        let messageDB = Database.database().reference().child("users").child(myUID).child("Messages").childByAutoId()
        //let messageDB = FirebaseConstants.messagesDatabase.childByAutoId()
        let reference = Database.database().reference().child("user-messages").child(myUID).child(toID).childByAutoId()
        let toReference = Database.database().reference().child("user-messages").child(toID).child(myUID).childByAutoId()
        guard let messageBody = textField.text else {return}
        guard let myEmail = Auth.auth().currentUser?.email else {return}
        let refKey = reference.key!
        
        let chatMessage : NSDictionary = ["id": refKey, "fromID": myUID, "messageBody": messageBody, "recepient": recepient, "sender": myEmail, "timestamp": timestamp, "toID": toID]
        
        reference.setValue(chatMessage)
        toReference.setValue(chatMessage)
        
        let latestMessageRef = Database.database().reference().child("latest-messages").child(myUID).child(toID)
        latestMessageRef.setValue(chatMessage) { (error, ref) in
            if error != nil {
                print(error!)
            }
            else {
                print("Message Saved Successfully!")
            }
            
            let sender = PushNotificationSender()

            let usersRef = Firestore.firestore().collection("users_table").document(self.toID)
            guard let theEmail = Auth.auth().currentUser?.email else {return}

            usersRef.getDocument(completion: { (docSnapshot, error) in
                guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
                guard let myData = docSnapshot.data() else {return}
                guard let theToken = myData["fcmToken"] as? String else {return}
                guard let theMessagebody = self.textField.text else {return}
                print("the token is: \(theToken)")
                sender.sendPushNotification(to: theToken, title: "\(theEmail)", body: "\(String(describing: messageBody))", vc: "friendMessageCollectionViewController")
            })
            
            DispatchQueue.main.async {
                self.textField.text = ""
                
            }
            
            
        }
        
        let latestMessageToRef = Database.database().reference().child("latest-messages").child(toID).child(myUID)
        latestMessageToRef.setValue(chatMessage)
        
        
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}


