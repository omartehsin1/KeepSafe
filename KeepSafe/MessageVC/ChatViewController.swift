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
    var toID = String()
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
        retreieveChat()

    }
    func retreieveChat() {
        messageDataBase.queryOrderedByKey().observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(dictionary)
                //messages.messageTopLabel.text = dictionary["sender"] as? String ?? ""
                //messages.messageLabel.text = dictionary["messageBody"] as? String ?? ""
                let theSender = dictionary["sender"] as? String ?? ""
                let message = dictionary["messageBody"] as? String ?? ""
                
                let newMess =  ChatMessage(member: self.member, text: message, messageId: "dunno")
                self.theMessages.append(newMess)
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
                
            }
        }
//        messageDataBase.queryOrdered(byChild: "toID").queryEqual(toValue: toID).observe(.childAdded) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let messages = TextMessageCell()
//                let sender = MessageContentCell()
//                messages.messageTopLabel.text = dictionary["sender"] as? String ?? ""
//                messages.messageLabel.text = dictionary["messageBody"] as? String ?? ""
//
//            }
//        }
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
//extension ChatViewController: MessagesLayoutDelegate {
//    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 0
//    }
//}
//
//extension ChatViewController: MessagesDisplayDelegate {
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        let message = theMessages[indexPath.section]
//        let color = message.member.color
//        avatarView.backgroundColor = color
//    }
//}

extension ChatViewController: MessagesLayoutDelegate, MessagesDisplayDelegate{
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
        
        
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
