//
//  ChatMessage.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-17.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

//struct Member {
//    let name: String
//    let color: UIColor
//}

struct ChatsMessages {
    let name: String
    let text: String
    let messageId: String
    //let timeStamp: Double
}

extension ChatsMessages: MessageType {
    var sender: SenderType {
        return Sender(senderId: name, displayName: name)
    }

    var sentDate: Date {
        return Date()
    }

    var kind: MessageKind {
        return .text(text)
    }
}
//struct ChatMessage: MessageType {
////    var sender: SenderType
//    var theSender: Sender
//    var messageId: String
//    var sender: SenderType
//    var sentDate: Date
//    var kind: MessageKind
//
//    init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
//        self.kind = kind
//        self.sender = sender
//        self.messageId = messageId
//        self.sentDate = date
//    }
//
//    init(text: String, sender: Sender, messageId: String, date: Date) {
//        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
//    }
//}
