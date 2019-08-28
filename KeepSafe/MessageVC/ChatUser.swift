//
//  ChatUser.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-17.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
