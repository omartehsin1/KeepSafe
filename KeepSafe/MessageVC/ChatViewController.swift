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

class ChatViewController: MessagesViewController {
    
    var theMessages: [ChatMessage] = []
    var member: Member!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        member = Member(name: "bluemoon", color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //messagesCollectionView.messageCellDelegate = self

    }
}
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: member.name, displayName: member.name)
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

extension ChatViewController: MessagesLayoutDelegate, MessagesDisplayDelegate{}

extension ChatViewController: MessageInputBarDelegate {
//    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//        let newMessage = ChatMessage(
//            member: member,
//            text: text,
//            messageId: UUID().uuidString)
//
//        theMessages.append(newMessage)
//        inputBar.inputTextView.text = ""
//        messagesCollectionView.reloadData()
//        messagesCollectionView.scrollToBottom(animated: true)
//    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        let newMessage = ChatMessage(
            member: member,
            text: text,
            messageId: UUID().uuidString)

        theMessages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
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
