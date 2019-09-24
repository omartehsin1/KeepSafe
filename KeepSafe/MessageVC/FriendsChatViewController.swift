//
//  FriendsViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-06-19.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import EmptyDataSet_Swift


class FriendsChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellID = "cellID"
    var users = [Users]()
    var recepient = String()
    var friendsUID = [String]()
    var chatMessageArray: [ChatMessage] = [ChatMessage]()
    //let messagesDatabase = FirebaseConstants.messagesDatabase
    let SOSDatabse = FirebaseConstants.SOSDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.backgroundColor = UIColor.white
        
        collectionView.alwaysBounceVertical = true
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        navigationItem.title = "Messages"
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        retrieveMessages()
    }
    
    func retrieveMessages() {
        var latestMessagesDictionary = [String: ChatMessage]()
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        let reference = Database.database().reference().child("latest-messages").child(myUID)
        
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
  
                //self.chatMessageArray.append(chatMessage)
                
                if let toID = chatMessage.toID {
                    latestMessagesDictionary[toID] = chatMessage
                    self.chatMessageArray = Array(latestMessagesDictionary.values)
                    self.chatMessageArray.sort(by: { (message1, message2) -> Bool in
                        guard let firstMessage = message1.timeStamp else {return false}
                        guard let secondMessage = message2.timeStamp else {return false}
                        //self.collectionView.reloadData()
                        return firstMessage > secondMessage
                    })
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        SOSDatabse.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let chatMessage = ChatMessage()
                chatMessage.messageBody = dictionary["SOSMessage"] as? String ?? ""
                chatMessage.toID = dictionary["toID"] as? String ?? ""
                
                if let toID = chatMessage.toID {
                    latestMessagesDictionary[toID] = chatMessage
                    self.chatMessageArray = Array(latestMessagesDictionary.values)
                    self.chatMessageArray.sort(by: { (message1, message2) -> Bool in
                        guard let firstMessage = message1.timeStamp else {return false}
                        guard let secondMessage = message2.timeStamp else {return false}
                        //self.collectionView.reloadData()
                        return firstMessage > secondMessage
                    })
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
  
    }
    func showFriendMessageControllerForUser(theuser: ChatMessage) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let friendMesageController = storyBoard.instantiateViewController(withIdentifier: "friendMessageCollectionViewController") as! FriendMessageCollectionViewController
        navigationController?.pushViewController(friendMesageController, animated: true)
        friendMesageController.recepient = theuser.recepient ?? ""
        friendMesageController.toID = theuser.toID ?? ""

        
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return chatMessageArray.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
        
        let message = chatMessageArray[indexPath.row]
        
        
        
        
        //cell.message = message
        cell.chatMessage = message
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = chatMessageArray[indexPath.row]
        print("Touched!")
        showFriendMessageControllerForUser(theuser: message)
//        guard let chatPartnerID = message.chatPartnerID() else {return}
//        let ref = Database.database().reference().child("users").child(chatPartnerID)
//
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
//
//            let user = Users()
//            user.setValuesForKeys(dictionary)
//
//        }, withCancel: nil)

        
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



extension FriendsChatViewController: EmptyDataSetSource, EmptyDataSetDelegate {
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



