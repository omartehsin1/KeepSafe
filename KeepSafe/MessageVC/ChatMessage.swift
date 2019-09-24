//
//  ChatMessage.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-09-18.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation

class ChatMessage: NSObject {
    var id: String?
    var fromID: String?
    var messageBody: String?
    var recepient: String?
    var sender: String?
    var timeStamp: Double?
    var toID: String?
}
