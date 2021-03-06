//
//  ChatViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-17.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

//import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import UserNotifications

class ChatViewController: MessagesViewController {
    
    var theMessages: [ChatsMessages] = []
    //var member: Member!
    var currentUser = Auth.auth().currentUser!
    let refreshControl = UIRefreshControl()
    let users = [Users]()
    let messageDataBase = FirebaseConstants.messagesDatabase
    let SOSDatabase = FirebaseConstants.SOSDatabase
    var recepient = String()
    var friendsUID = String()
    var senderid = String()
    var displayName = String()
    let timestamp = ServerValue.timestamp()
    var name = String()
    
    
    //private var newMessages: [TheMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        navigationItem.title = recepient
        messagesCollectionView.messageCellDelegate = self
        let timestamp = ServerValue.timestamp()
        //messagesCollectionView.reloadData()
        retreieveChat()

    }
    func retreieveChat() {
        
        
//        messageDataBase.queryOrdered(byChild: "toID").queryEqual(toValue: friendsUID).observe(.childAdded) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let theSender = dictionary["sender"] as? String ?? ""
//                let message = dictionary["messageBody"] as? String ?? ""
//                guard let timeStamp = dictionary["timestamp"] as? Double else {return}
//                let newMess =  ChatMessage(member: self.member, text: message, messageId: "dunno")
//                self.theMessages.append(newMess)
//                DispatchQueue.main.async {
//                    self.messagesCollectionView.reloadData()
//                }
//
//            }
//        }
        messageDataBase.queryOrderedByKey().observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let theSender = dictionary["sender"] as? String ?? ""
                let message = dictionary["messageBody"] as? String ?? ""
                self.senderid = dictionary["fromID"] as? String ?? ""
                guard let timeStamp = dictionary["timestamp"] as? Double else {return}
                self.name = theSender
                //self.member = Member(name: theSender, color: .blue)
                let newMess =  ChatsMessages(name: theSender, text: message, messageId: "dunno")
                self.theMessages.append(newMess)
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
                
            }
        }
        SOSDatabase.queryOrdered(byChild: "toID").queryEqual(toValue: friendsUID).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let toID = dictionary["toID"] as? String ?? ""
                let message = dictionary["SOSMessage"] as? String ?? ""
                //let sosMessage = ChatMessage(member: self.member, text: message, messageId: "dunno")
                //self.theMessages.append(sosMessage)
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
            }
        }

    }
}
extension ChatViewController: MessagesDataSource {
//    func isFromCurrentSender(message: MessageType) -> Bool {
//        return message.sender == currentSender()
//    }
    func currentSender() -> SenderType {
        
        return Sender(id: name, displayName: name)
        
        
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return theMessages[indexPath.section]
        
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return theMessages.count
    }
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
         return 12
    }
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}


extension ChatViewController: MessagesLayoutDelegate, MessagesDisplayDelegate{
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = theMessages[indexPath.section]
        //let color = message.member.color
        avatarView.backgroundColor = UIColor.blue
        //avatarView.isHidden = true
    }
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        let myUID = Auth.auth().currentUser?.uid ?? ""
//        if senderid == myUID {
//            return .white
//        } else {
//            return .darkText
//        }

        
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        let myUID = Auth.auth().currentUser?.uid ?? ""
//
//        if senderid == myUID {
//            return UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//        } else {
//            return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
//        }
        
        return isFromCurrentSender(message: message)
            ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(corner, .curved)
//    }
}

extension ChatViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newMessage = ChatsMessages(
            name: name,
            text: text,
            messageId: UUID().uuidString)
        
        theMessages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
        sendPressed(message: text)
        
        
    }
    func sendPressed(message: String) {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        let messageDB = messageDataBase.childByAutoId()
        name = Auth.auth().currentUser?.email as! String
        let messageDictionary : NSDictionary = ["sender": name, "messageBody": message, "recepient" : recepient, "fromID": myUID, "toID": friendsUID, "timestamp": timestamp]
        messageDB.setValue(messageDictionary) {
            (error, ref) in
            if error != nil {
                print(error!)
            }
            else {
                print("Message Saved Successfully!")
            }
        }
        
//        let sender = PushNotificationSender()
//        let usersRef = Firestore.firestore().collection("users_table").document(self.friendsUID)
//        guard let theEmail = Auth.auth().currentUser?.email else {return}
//        
//        usersRef.getDocument { (docSnapshot, error) in
//            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
//            guard let myData = docSnapshot.data() else {return}
//            guard let theToken = myData["fcmToken"] as? String else {return}
//            sender.sendPushNotification(to: theToken, title: "\(theEmail)", body: message, vc: "chatViewController")
//        }
        
        
    }


}


extension ChatViewController: MessageCellDelegate {

    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")

    }

    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }

    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }

    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
}
//
