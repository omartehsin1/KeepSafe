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
    
    var theMessages: [ChatMessage] = []
    var member: Member!
    let refreshControl = UIRefreshControl()
    let users = [Users]()
    let messageDataBase = FirebaseConstants.messagesDatabase
    let SOSDatabase = FirebaseConstants.SOSDatabase
    var recepient = String()
    var friendsUID = String()
    var senderid = String()
    var displayName = String()
    //var toID = String()
    let timestamp = ServerValue.timestamp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let name = Auth.auth().currentUser?.email else {return}
        member = Member(name: name, color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        navigationItem.title = recepient
        //messagesCollectionView.messageCellDelegate = self
        let timestamp = ServerValue.timestamp()
        //messagesCollectionView.reloadData()
        retreieveChat()

    }
    func retreieveChat() {
        
        
        messageDataBase.queryOrdered(byChild: "toID").queryEqual(toValue: friendsUID).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(dictionary)
                //                messages.messageTopLabel.text = dictionary["sender"] as? String ?? ""
                //                messages.messageLabel.text = dictionary["messageBody"] as? String ?? ""
                let theSender = dictionary["sender"] as? String ?? ""
                let message = dictionary["messageBody"] as? String ?? ""
                
                let newMess =  ChatMessage(member: self.member, text: message, messageId: "dunno")
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
                let sosMessage = ChatMessage(member: self.member, text: message, messageId: "dunno")
                self.theMessages.append(sosMessage)
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
            }
        }

    }
}
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        
        return Sender(id: member.name, displayName: member.name)
        
        //return Sender(id: member.name, displayName: member.name)
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
        avatarView.isHidden = true
    }
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message)
            ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

extension ChatViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newMessage = ChatMessage(
            member: member,
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
        let messageDictionary : NSDictionary = ["sender": member.name, "messageBody": message, "recepient" : recepient, "fromID": myUID, "toID": friendsUID, "timestamp": timestamp]
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


//extension ChatViewController: MessageCellDelegate {
//
//    func didTapAvatar(in cell: MessageCollectionViewCell) {
//        print("Avatar tapped")
//    }
//
//    func didTapMessage(in cell: MessageCollectionViewCell) {
//        print("Message tapped")
//
//    }
//
//    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
//        print("Top cell label tapped")
//    }
//
//    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
//        print("Top message label tapped")
//    }
//
//    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
//        print("Bottom label tapped")
//    }
//
//    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
//        print("Accessory view tapped")
//    }
//}
//
