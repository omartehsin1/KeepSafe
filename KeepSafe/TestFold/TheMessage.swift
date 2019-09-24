//
//  TheMessage.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-29.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Firebase
import MessageKit

struct TheMessage: MessageType {
    
    var sender: SenderType
    let id: String?
    let content: String
    let sentDate: Date
    
    //var te:
    
    var kind: MessageKind {
        if let image = image {
            return .photo(image as! MediaItem)
        } else {
            return .text(content)
        }
    }
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init(user: User, content: String) {
        sender = Sender(id: user.uid, displayName: AppSettings.displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    init(user: User, image: UIImage) {
        sender = Sender(id: user.uid, displayName: AppSettings.displayName)
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
}
extension TheMessage: Comparable {
    
    static func == (lhs: TheMessage, rhs: TheMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: TheMessage, rhs: TheMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}
