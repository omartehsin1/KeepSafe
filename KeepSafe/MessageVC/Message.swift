//
//  Message.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-13.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase


class Message: NSObject {
    var fromID: String?
    var messageBody : String?
    var recepient : String?
    var sender : String?
    //var timestamp: NSNumber?
    var timestamp: Double?
    var toID: String?
    var SOSMessage: String?
    
//    func chatPartnerID() -> String? {
//        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
//    }
}
