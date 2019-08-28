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

struct Member {
    let name: String
    let color: UIColor
}

struct ChatMessage {
    let member: Member
    let text: String
    let messageId: String
}

extension ChatMessage: MessageType {    
    var sender: SenderType {
        return Sender(senderId: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
