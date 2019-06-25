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

class Friend: NSObject {
    var name: String?
    var profileImageName: String?
}
class TheMessage: NSObject{
    var text: String?
    var date: NSDate?
    
    var friend: Friend?
}
//showChatLogController
//showMessageVC
class FriendsChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, EmptyDataSetSource, EmptyDataSetDelegate {
    private let cellID = "cellID"
    var theMessages: [TheMessage]?
    var myMessages: [Message] = [Message]()
    var users = [Users]()
    var recepient = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.backgroundColor = UIColor.white
        
        collectionView.alwaysBounceVertical = true
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        navigationItem.title = "Messages"
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        retrieveMessages()
        
        
    }

//        func retrieveMessages() {
//
//            if let otherUID = Auth.auth().currentUser?.uid {
//                let ref = Database.database().reference().child("users").child(otherUID).child("Messages").queryLimited(toLast: 1)
//                ref.observeSingleEvent(of: .value) { (snapshot) in
//                    for chatLogMessages in snapshot.children.allObjects as! [DataSnapshot] {
//                        if let dictionary = chatLogMessages.value as? [String: AnyObject] {
//                            let message = Message()
//                            message.messageBody = dictionary["messageBody"] as? String ?? ""
//                            message.recepient = dictionary["recepient"] as? String ?? ""
//
//                            message.date = dictionary["timestamp"] as? Double
//                            message.toID = dictionary["toID"] as? String ?? ""
//
//
//
//                            self.myMessages.append(message)
//
//                            DispatchQueue.main.async {
//                                self.collectionView.reloadData()
//                            }
//                        }
//                    }
//                }
//            }
//
//        }
    
    var messagesDictionary = [String: Message]()
    func retrieveMessages() {
        if let myUID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(myUID).child("Messages")
            ref.observe(.childAdded) { (snapshot) in
//                for chatLogMessages in snapshot.children.allObjects as! [DataSnapshot] {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let message = Message()
                        message.fromID = dictionary["fromID"] as? String ?? ""
                        message.messageBody = dictionary["messageBody"] as? String ?? ""
                        message.recepient = dictionary["recepient"] as? String ?? ""
                        message.sender = dictionary["sender"] as? String ?? ""
                        message.timestamp = dictionary["timestamp"] as? Double
                        message.toID = dictionary["toID"] as? String ?? ""

                        //message.setValuesForKeys(dictionary)
                        //print(message.messageBody)
                        //self.myMessages.append(message)
                        
                        
                        if let toID = message.toID {
                           self.messagesDictionary[toID] = message
                            self.myMessages = Array(self.messagesDictionary.values)
                            self.myMessages.sort(by: { (message1, message2) -> Bool in
                                guard let firstMessage = message1.timestamp else {return false}
                                guard let secondMessage = message2.timestamp else {return false}
                                return firstMessage > secondMessage
                            })
                        }
                        
                        

                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }


                    }

//                }
            }

        }

    }
    func showFriendMessageControllerForUser(theuser: Message) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let friendMesageController = storyBoard.instantiateViewController(withIdentifier: "friendMessageCollectionViewController") as! FriendMessageCollectionViewController
        navigationController?.pushViewController(friendMesageController, animated: true)
        friendMesageController.recepient = theuser.recepient ?? ""
        friendMesageController.toID = theuser.toID ?? ""
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myMessages.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
        
        let message = myMessages[indexPath.row]
        
        
        
        
        cell.message = message
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    //var friendMessageController: FriendMessageCollectionViewController?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "showMessageVC", sender: self)
        let theUsername = self.myMessages[indexPath.row]
        self.showFriendMessageControllerForUser(theuser: theUsername)
        
        
        
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



extension FriendsChatViewController {
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


