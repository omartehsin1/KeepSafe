//
//  FirebaseConstants.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-03.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

struct FirebaseConstants {
    static let friendRequestDatabase: DatabaseReference = Database.database().reference().child("friendReq")
    static let friendDataBase: DatabaseReference = Database.database().reference().child("friends")
    static let userDatabase: DatabaseReference = Database.database().reference().child("users")
    static let messagesDatabase: DatabaseReference = Database.database().reference().child("Message")
    static let SOSDatabase: DatabaseReference = Database.database().reference().child("SOS")
}
